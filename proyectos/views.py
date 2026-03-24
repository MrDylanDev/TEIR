from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction
from django.db.models import Avg
from .models import Proyecto, Valoracion
from usuarios.models import Usuario, PerfilDesarrollador
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from favoritos.models import Favorito

@login_required
def listar_proyectos(request):
    proyectos = Proyecto.objects.filter(estado='publicado').order_by('-fecha_publicacion')
    
    tipo = request.GET.get('tipo')
    prioridad = request.GET.get('prioridad')
    if tipo:
        proyectos = proyectos.filter(tipo_solucion=tipo)
    if prioridad:
        proyectos = proyectos.filter(prioridad=prioridad)
    
    favoritos_ids = []
    
    if request.user.rol == 'desarrollador':
        from favoritos.models import Favorito
        from postulaciones.models import Postulacion
        
        # Obtener IDs de proyectos donde el usuario ya tiene una postulación
        postulaciones_ids = Postulacion.objects.filter(desarrollador=request.user).values_list('proyecto_id', flat=True)
        
        # Excluir esos proyectos de la lista principal
        proyectos = proyectos.exclude(id__in=postulaciones_ids)
        
        favoritos_ids = Favorito.objects.filter(desarrollador=request.user).values_list('proyecto_id', flat=True)
        
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
                estado='publicado' # Publicación directa
            )
            proyecto.save()
            messages.success(request, f"¡Proyecto '{proyecto.titulo}' publicado exitosamente!")
            return redirect('dashboard_empresa')
        except Exception as e:
            messages.error(request, f"Error: {e}")
            
    return render(request, 'proyectos/crear.html')

@login_required
def finalizar_proyecto(request, proyecto_id):
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    
    # Buscar la contratación activa para este proyecto
    contratacion = Contratacion.objects.filter(proyecto=proyecto, estado='activa').first()
    
    if not contratacion:
        messages.error(request, "No puedes finalizar un proyecto que no tiene un desarrollador contratado.")
        return redirect('dashboard_empresa')
    
    desarrollador = contratacion.desarrollador

    if request.method == 'POST':
        try:
            puntuacion = int(request.POST.get('puntuacion'))
            comentario = request.POST.get('comentario')

            # Al crear la valoración, el trigger MySQL trg_nueva_valoracion
            # actualizará automáticamente:
            # 1. El promedio del desarrollador.
            # 2. El número de proyectos completados.
            # 3. El estado del proyecto a 'finalizado'.
            Valoracion.objects.create(
                proyecto=proyecto,
                empresa=request.user,
                desarrollador=desarrollador,
                puntuacion=puntuacion,
                comentario=comentario
            )

            # Sincronizamos la contratación por si acaso (aunque MySQL lo hace, es bueno para el ORM)
            contratacion.estado = 'finalizada'
            contratacion.save()

            Notificacion.objects.create(
                usuario=desarrollador,
                tipo='aprobacion',
                mensaje=f"¡Felicidades! La empresa ha finalizado el proyecto '{proyecto.titulo}' y te ha calificado con {puntuacion} estrellas."
            )

            messages.success(request, f"Proyecto '{proyecto.titulo}' finalizado exitosamente.")
            return redirect('dashboard_empresa')

        except Exception as e:
            messages.error(request, f"Error al finalizar proyecto: {e}")

    return render(request, 'proyectos/finalizar.html', {'proyecto': proyecto, 'desarrollador': desarrollador})

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
            
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.execute("CALL sp_calificar_empresa(%s, %s, %s, %s, %s)", 
                               [proyecto.id, request.user.id, proyecto.empresa.id, puntuacion, comentario])
                
            messages.success(request, "¡Gracias! Tu calificación ha sido registrada.")
            return redirect('dashboard_desarrollador')
        except Exception as e:
            error_msg = str(e).split(",")[1].replace("'", "").strip() if "," in str(e) else str(e)
            messages.error(request, f"Error: {error_msg}")
            
    return render(request, 'proyectos/calificar_empresa.html', {'proyecto': proyecto})

@login_required
def desactivar_proyecto(request, proyecto_id):
    if request.user.rol != 'empresa':
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    if proyecto.estado == 'publicado':
        proyecto.estado = 'inactivo'
        proyecto.save()
        messages.info(request, f"El proyecto '{proyecto.titulo}' ha sido retirado del catálogo.")
    else:
        messages.error(request, "Solo se pueden retirar proyectos que estén en estado publicado.")
        
    return redirect('dashboard_empresa')
