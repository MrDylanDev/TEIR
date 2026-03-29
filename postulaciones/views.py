from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction
from .models import Postulacion
from proyectos.models import Proyecto
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from django.utils import timezone

@login_required
def ver_postulaciones_empresa(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    
    # --- DESPERTANDO v_postulaciones_activas ---
    postulaciones = []
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT id, desarrollador_nombre, calificacion_promedio, num_proyectos_completados, habilidades, mensaje, fecha 
            FROM v_postulaciones_activas 
            WHERE proyecto_id = %s AND estado = 'pendiente'
            ORDER BY fecha DESC
        """, [proyecto_id])
        rows = cursor.fetchall()
        for row in rows:
            postulaciones.append({
                'id': row[0],
                'desarrollador': {'nombre': row[1]},
                'calificacion_promedio': row[2],
                'proyectos_completados': row[3],
                'habilidades': row[4],
                'mensaje': row[5],
                'fecha': row[6]
            })
            
    return render(request, 'postulaciones/lista_recibidas.html', {'proyecto': proyecto, 'postulaciones': postulaciones})

@login_required
def postularse_a_proyecto(request, proyecto_id):
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
    
    proyecto = Proyecto.objects.filter(id=proyecto_id).first()

    if not proyecto:
        messages.error(request, "El proyecto solicitado no existe.")
        return redirect('dashboard_desarrollador')

    if proyecto.estado != 'publicado':
        messages.warning(request, f"Lo sentimos, el proyecto '{proyecto.titulo}' ya no acepta postulaciones (Estado: {proyecto.get_estado_display()}).")
        return redirect('dashboard_desarrollador')
    
    if request.method == 'POST':
        mensaje = request.POST.get('mensaje')
        try:
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.callproc('sp_postularse', [proyecto.id, request.user.id, mensaje])
                
            messages.success(request, f"¡Te has postulado exitosamente al proyecto '{proyecto.titulo}'!")
            return redirect('dashboard_desarrollador')
        except Exception as e:
            error_msg = e.args[1] if hasattr(e, 'args') and len(e.args) > 1 else str(e)
            
            if 'Límite alcanzado' in error_msg:
                messages.error(request, "Límite alcanzado: No puedes tener más de 3 postulaciones o proyectos activos.")
            elif 'Ya te has postulado' in error_msg:
                messages.warning(request, "Ya te habías postulado a este proyecto anteriormente.")
            else:
                messages.error(request, f"Error del sistema: {error_msg}")
            
            return redirect('dashboard_desarrollador')
                
    return render(request, 'postulaciones/postularse.html', {'proyecto': proyecto})

@login_required
def aceptar_postulacion(request, postulacion_id):
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')

    # Buscamos la postulación sin filtrar por estado 'pendiente' para dar un error personalizado si ya fue procesada
    postulacion = get_object_or_404(Postulacion, id=postulacion_id, proyecto__empresa=request.user)
    proyecto = postulacion.proyecto

    if request.method == 'POST':
        try:
            if postulacion.estado != 'pendiente':
                messages.warning(request, f"Esta postulación ya ha sido {postulacion.estado}.")
                return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)

            with transaction.atomic():
                # 1. Verificar vacantes
                vacantes_ocupadas = Contratacion.objects.filter(proyecto=proyecto, estado='activa').count()
                if vacantes_ocupadas >= proyecto.vacantes:
                    messages.warning(request, "Límite de vacantes alcanzado para este proyecto.")
                    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)

                # 2. Aceptar postulación
                postulacion.estado = 'aceptada'
                postulacion.save()

                # 3. Crear Contratación (Migrado del Trigger)
                Contratacion.objects.get_or_create(
                    proyecto=proyecto,
                    desarrollador=postulacion.desarrollador,
                    empresa=request.user,
                    estado='activa'
                )

                # 4. Actualizar estado del proyecto si se llenaron las vacantes
                nueva_cuenta = Contratacion.objects.filter(proyecto=proyecto, estado='activa').count()
                if nueva_cuenta >= proyecto.vacantes:
                    proyecto.estado = 'en_desarrollo'
                    proyecto.save()

                # 5. Notificar al desarrollador
                Notificacion.objects.create(
                    usuario=postulacion.desarrollador,
                    tipo='aprobacion',
                    mensaje=f"¡Felicidades! Has sido contratado para el proyecto: {proyecto.titulo}"
                )

                messages.success(request, f"¡Contratación exitosa! {postulacion.desarrollador.username} ha sido vinculado.")
        except Exception as e:
            messages.error(request, f"Error al procesar: {str(e)}")
    else:
        messages.warning(request, "Acción no permitida.")

    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)
