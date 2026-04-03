from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction, connection
from django.db.models import Avg, Q, Count, Prefetch
from .models import Proyecto, Valoracion, Entregable, Equipo
from usuarios.models import Usuario, PerfilDesarrollador
from contrataciones.models import Contratacion
from favoritos.models import Favorito
from postulaciones.models import Postulacion
from notificaciones.models import Notificacion

@login_required
def listar_proyectos(request):
    # --- DESPERTANDO v_proyectos_disponibles ---
    proyectos = []
    
    tipo = request.GET.get('tipo')
    prioridad = request.GET.get('prioridad')
    
    sql = """
        SELECT v.id, v.titulo, v.descripcion, v.tipo_solucion, v.prioridad, v.fecha_publicacion, 
               v.nombre_empresa, v.num_postulaciones, v.empresa_reputacion, pe.logo
        FROM v_proyectos_disponibles v
        LEFT JOIN perfil_empresa pe ON pe.nombre_empresa = v.nombre_empresa
        WHERE 1=1
    """
    params = []
    
    if tipo:
        sql += " AND v.tipo_solucion = %s"
        params.append(tipo)
    if prioridad:
        sql += " AND v.prioridad = %s"
        params.append(prioridad)
        
    sql += " ORDER BY v.fecha_publicacion DESC"
    
    with connection.cursor() as cursor:
        cursor.execute(sql, params)
        rows = cursor.fetchall()
        for row in rows:
            proyectos.append({
                'id': row[0],
                'titulo': row[1],
                'descripcion': row[2],
                'tipo_solucion': row[3],
                'prioridad': row[4],
                'fecha_publicacion': row[5],
                'empresa_nombre': row[6],
                'num_postulaciones': row[7],
                'empresa_reputacion': row[8],
                'empresa_logo': row[9]
            })
    
    favoritos_ids = []
    
    if request.user.rol == 'desarrollador':
        # Obtener IDs de proyectos donde el usuario ya tiene una postulación
        postulaciones_ids = Postulacion.objects.filter(desarrollador=request.user).values_list('proyecto_id', flat=True)
        
        # Excluir esos proyectos de la lista
        proyectos = [p for p in proyectos if p['id'] not in postulaciones_ids]
        
        favoritos_ids = list(Favorito.objects.filter(desarrollador=request.user).values_list('proyecto_id', flat=True))
        
    return render(request, 'proyectos/listar.html', {
        'proyectos': proyectos,
        'favoritos_ids': favoritos_ids
    })

@login_required
def crear_proyecto(request):
    if request.user.rol != 'empresa':
        messages.error(request, "Solo las empresas pueden publicar proyectos.")
        return redirect('dashboard_empresa')

    if request.method == 'POST':
        try:
            proyecto = Proyecto(
                empresa=request.user,
                titulo=request.POST.get('titulo'),
                descripcion=request.POST.get('descripcion'),
                tipo_solucion=request.POST.get('tipo_solucion'),
                prioridad=request.POST.get('prioridad', 'media'),
                vacantes=int(request.POST.get('vacantes', 1)),
                fecha_limite=request.POST.get('fecha_limite') or None,
                estado='publicado'
            )
            proyecto.save()
            proyecto.registrar_cambio_estado('publicado', request.user, estado_anterior=None)
            messages.success(request, f"¡Proyecto '{proyecto.titulo}' publicado exitosamente!")
            return redirect('dashboard_empresa')
        except Exception as e:
            messages.error(request, f"Error: {e}")
            
    return redirect('dashboard_empresa')

@login_required
def finalizar_proyecto(request, proyecto_id):
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    
    # NUEVA VALIDACIÓN ESTRICTA: Todos los hitos deben estar COMPLETADOS
    hitos_totales = proyecto.entregables.count()
    hitos_completados = proyecto.entregables.filter(estado='completado').count()
    
    if hitos_totales == 0:
        messages.error(request, "No puedes finalizar un proyecto que no tiene hitos definidos.")
        return redirect('gestionar_hitos', proyecto_id=proyecto.id)
        
    if hitos_completados < hitos_totales:
        pendientes = hitos_totales - hitos_completados
        messages.error(request, f"No puedes finalizar el proyecto. Aún quedan {pendientes} hitos sin completar o validar.")
        return redirect('ver_avances', proyecto_id=proyecto.id)
    
    # Buscamos quiénes faltan por calificar (Empresa califica a Desarrolladores)
    desarrolladores_pendientes = Usuario.objects.filter(
        id__in=Contratacion.objects.filter(proyecto=proyecto, estado='activa').values_list('desarrollador_id', flat=True)
    ).exclude(
        id__in=Valoracion.objects.filter(proyecto=proyecto, rol_evaluador='empresa').values_list('desarrollador_id', flat=True)
    )
    
    # Si ya no hay nadie más que calificar, cerramos el proyecto oficialmente
    if not desarrolladores_pendientes.exists():
        try:
            with transaction.atomic():
                # Bloqueo pesimista: Bloqueamos la fila para asegurar que el cambio de estado sea único
                proyecto_locked = Proyecto.objects.select_for_update().get(id=proyecto.id)
                
                if proyecto_locked.estado == 'finalizado':
                    messages.info(request, f"El proyecto '{proyecto_locked.titulo}' ya ha sido finalizado anteriormente.")
                    return redirect('dashboard_empresa')

                proyecto_locked.estado = 'finalizado'
                proyecto_locked.save()
                
                # Cerramos todas las contrataciones y notificamos
                contratos = Contratacion.objects.filter(proyecto=proyecto_locked, estado='activa')
                for c in contratos:
                    Notificacion.objects.create(
                        usuario=c.desarrollador,
                        tipo='aprobacion',
                        mensaje=f"El proyecto '{proyecto_locked.titulo}' ha finalizado. ¡Gracias por tu trabajo!"
                    )
                    c.estado = 'finalizada'
                    c.save()
                    
                    # Actualización de estadísticas: Eliminada lógica redundante. 
                    # El conteo se calcula en tiempo real vía Vistas SQL.

            messages.success(request, f"¡Excelente! Has calificado a todo el equipo y el proyecto '{proyecto.titulo}' ha finalizado.")
            return redirect('dashboard_empresa')
        except Exception as e:
            messages.error(request, f"Error crítico al finalizar: {str(e)}")
            return redirect('finalizar_proyecto', proyecto_id=proyecto.id)

    # Tomamos el primero de la lista para evaluarlo
    desarrollador = desarrolladores_pendientes.first()
    restantes = desarrolladores_pendientes.count() - 1

    if request.method == 'POST':
        try:
            puntuacion = request.POST.get('puntuacion')
            comentario = request.POST.get('comentario', '')
            
            if not puntuacion:
                messages.error(request, "Debes seleccionar una puntuación.")
                return redirect('finalizar_proyecto', proyecto_id=proyecto.id)

            with connection.cursor() as cursor:
                cursor.callproc('sp_calificar_proyecto', [
                    proyecto.id,
                    request.user.id,
                    desarrollador.id,
                    int(puntuacion),
                    comentario,
                    'empresa'
                ])

            # Actualización de estadísticas: Eliminada lógica redundante.
            # El promedio se calcula en tiempo real vía Vistas SQL.

            messages.success(request, f"Calificación registrada para {desarrollador.username}. " + 
                             (f"Quedan {restantes} por calificar." if restantes > 0 else "Era el último colaborador."))
            
            # Recargamos la misma vista para el siguiente desarrollador
            return redirect('finalizar_proyecto', proyecto_id=proyecto.id)
            
        except Exception as e:
            messages.error(request, f"Error: {str(e)}")
            return redirect('finalizar_proyecto', proyecto_id=proyecto.id)
    
    return render(request, 'proyectos/finalizar.html', {
        'proyecto': proyecto,
        'desarrollador': desarrollador,
        'restantes': restantes
    })

@login_required
def calificar_empresa(request, proyecto_id):
    """Permite al desarrollador calificar a la empresa tras finalizar un proyecto"""
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, estado='finalizado')
    contratacion = get_object_or_404(Contratacion, proyecto=proyecto, desarrollador=request.user)
    
    if request.method == 'POST':
        try:
            puntuacion = int(request.POST.get('puntuacion'))
            comentario = request.POST.get('comentario')
            
            with connection.cursor() as cursor:
                # Usamos el SP universal: sp_calificar_proyecto
                cursor.callproc('sp_calificar_proyecto', [
                    proyecto.id,
                    request.user.id,        # Evaluador (Desarrollador)
                    proyecto.empresa.id,    # Evaluado (Empresa)
                    puntuacion,
                    comentario,
                    'desarrollador'         # Rol del evaluador
                ])
                
            messages.success(request, "¡Gracias! Tu calificación ha sido registrada.")
            return redirect('dashboard_desarrollador')
        except Exception as e:
            error_msg = str(e).split(",")[1].replace("'", "").strip() if "," in str(e) else str(e)
            messages.error(request, f"Error: {error_msg}")
            
    return render(request, 'proyectos/calificar_empresa.html', {'proyecto': proyecto})

@login_required
def gestionar_equipos(request, proyecto_id):
    if request.user.rol != 'empresa': return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    desarrolladores = Usuario.objects.filter(
        id__in=Contratacion.objects.filter(proyecto=proyecto, estado='activa').values_list('desarrollador_id', flat=True)
    )

    if desarrolladores.count() < 2:
        messages.warning(request, "Para crear grupos o parejas se requieren al menos 2 desarrolladores contratados.")
        return redirect('gestionar_hitos', proyecto_id=proyecto.id)

    if request.method == 'POST':
        nombre = request.POST.get('nombre')
        miembros_ids = request.POST.getlist('miembros')
        
        if nombre and miembros_ids:
            equipo = Equipo.objects.create(nombre=nombre, proyecto=proyecto)
            equipo.miembros.set(miembros_ids)
            
            # Notificación: Avisar a cada miembro
            for miembro_id in miembros_ids:
                Notificacion.objects.create(
                    usuario_id=miembro_id,
                    tipo='mensaje',
                    mensaje=f"Has sido asignado al equipo '{nombre}' en el proyecto: {proyecto.titulo}"
                )
            
            messages.success(request, f"Equipo '{nombre}' creado y miembros notificados.")
            return redirect('gestionar_equipos', proyecto_id=proyecto.id)

    equipos = proyecto.equipos.all().prefetch_related('miembros')
    
    return render(request, 'proyectos/gestionar_equipos.html', {
        'proyecto': proyecto,
        'desarrolladores': desarrolladores,
        'equipos': equipos
    })

@login_required
def eliminar_equipo(request, equipo_id):
    equipo = get_object_or_404(Equipo, id=equipo_id, proyecto__empresa=request.user)
    proyecto_id = equipo.proyecto.id
    equipo.delete()
    messages.info(request, "Equipo eliminado.")
    return redirect('gestionar_equipos', proyecto_id=proyecto_id)

@login_required
def gestionar_hitos(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    hitos = Entregable.objects.filter(proyecto=proyecto).order_by('fecha_creacion')

    if request.method == 'POST':
        titulo = request.POST.get('titulo')
        descripcion = request.POST.get('descripcion')
        equipo_id = request.POST.get('equipo_id')

        if titulo:
            # Validacion de integridad: El equipo debe pertenecer al proyecto
            equipo = None
            if equipo_id:
                equipo = Equipo.objects.filter(id=equipo_id, proyecto=proyecto).first()
                if not equipo:
                    messages.error(request, "Error: El equipo seleccionado no pertenece a este proyecto.")
                    return redirect('gestionar_hitos', proyecto_id=proyecto.id)

            Entregable.objects.create(
                proyecto=proyecto, 
                titulo=titulo, 
                descripcion=descripcion,
                equipo=equipo
            )

            # Notificacion
            if equipo:
                # Avisar solo a los miembros del equipo
                for miembro in equipo.miembros.all():
                    Notificacion.objects.create(
                        usuario=miembro,
                        tipo='avance',
                        mensaje=f"Nueva tarea asignada a tu equipo '{equipo.nombre}': {titulo}"
                    )
            else:
                # Avisar a todos los contratados en el proyecto (Hito General)
                desarrolladores = Usuario.objects.filter(
                    id__in=Contratacion.objects.filter(proyecto=proyecto, estado='activa').values_list('desarrollador_id', flat=True)
                )
                for dev in desarrolladores:
                    Notificacion.objects.create(
                        usuario=dev,
                        tipo='avance',
                        mensaje=f"Nueva tarea general en '{proyecto.titulo}': {titulo}"
                    )

            messages.success(request, f"Hito '{titulo}' creado y desarrolladores notificados.")
            return redirect('gestionar_hitos', proyecto_id=proyecto.id)

    equipos = proyecto.equipos.all()

    return render(request, 'proyectos/gestionar_hitos.html', {
        'proyecto': proyecto, 
        'hitos': hitos,
        'equipos': equipos
    })

@login_required
def eliminar_hito(request, hito_id):
    hito = get_object_or_404(Entregable, id=hito_id, proyecto__empresa=request.user)
    proyecto_id = hito.proyecto.id
    if hito.estado == 'pendiente':
        hito.delete()
        messages.success(request, "Hito eliminado.")
    else:
        messages.error(request, "No se puede eliminar un hito que ya ha sido completado.")
    return redirect('gestionar_hitos', proyecto_id=proyecto_id)

@login_required
def desactivar_proyecto(request, proyecto_id):
    if request.user.rol != 'empresa':
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    
    if proyecto.estado == 'publicado' or proyecto.estado == 'en_desarrollo':
        with transaction.atomic():
            estado_anterior = proyecto.estado
            proyecto.estado = 'inactivo'
            proyecto.save()
            
            # 1. Registrar Historial
            proyecto.registrar_cambio_estado('inactivo', request.user, estado_anterior=estado_anterior)
            
            # 2. Gestionar Postulaciones y Notificaciones en bloque
            postulaciones = Postulacion.objects.filter(proyecto=proyecto).select_related('desarrollador')
            
            if postulaciones.exists():
                # Notificaciones masivas para postulantes
                notificaciones_lista = [
                    Notificacion(
                        usuario=pos.desarrollador,
                        tipo='alerta',
                        mensaje=f"El proyecto '{proyecto.titulo}' ha sido retirado por la empresa. Tu postulación ya no está vigente."
                    ) for pos in postulaciones
                ]
                
                # Actualización masiva de estados
                postulaciones.update(estado='rechazada')
                # Creación masiva de notificaciones
                Notificacion.objects.bulk_create(notificaciones_lista)

            # 3. Gestionar contrataciones en bloque
            contratos = Contratacion.objects.filter(proyecto=proyecto, estado='activa').select_related('desarrollador')
            
            if contratos.exists():
                # Notificaciones masivas para contratados
                notificaciones_contratos = [
                    Notificacion(
                        usuario=c.desarrollador,
                        tipo='alerta',
                        mensaje=f"Importante: El proyecto '{proyecto.titulo}' en el que trabajabas ha sido CANCELADO por la empresa."
                    ) for c in contratos
                ]
                
                # Actualización masiva de contratos
                contratos.update(estado='cancelada')
                # Creación masiva de notificaciones
                Notificacion.objects.bulk_create(notificaciones_contratos)

        messages.info(request, f"El proyecto '{proyecto.titulo}' ha sido retirado y los desarrolladores han sido notificados.")
    else:
        messages.error(request, "No se puede retirar un proyecto que ya está finalizado o inactivo.")
        
    return redirect('dashboard_empresa')
