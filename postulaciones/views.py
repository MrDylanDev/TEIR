from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction, connection
from .models import Postulacion
from proyectos.models import Proyecto
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from logs.models import LogAuditoria

@login_required
def ver_postulaciones_empresa(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    
    postulaciones_orm = Postulacion.objects.filter(
        proyecto_id=proyecto_id,
        estado='pendiente'
    ).select_related('desarrollador__perfil_desarrollador').order_by('-fecha')
    
    postulaciones = []
    for p in postulaciones_orm:
        perfil = getattr(p.desarrollador, 'perfil_desarrollador', None)
        postulaciones.append({
            'id': p.id,
            'desarrollador': {
                'nombre': p.desarrollador.nombre,
                'foto_perfil': perfil.foto_perfil.url if perfil and perfil.foto_perfil else None,
            },
            'calificacion_promedio': perfil.calificacion_promedio if perfil else 0,
            'proyectos_completados': perfil.num_proyectos_completados if perfil else 0,
            'habilidades': perfil.habilidades if perfil else '',
            'mensaje': p.mensaje,
            'fecha': p.fecha,
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
        carta = request.POST.get('carta', '')
        experiencia = request.POST.get('experiencia', '')
        link = request.POST.get('link', '')
        
        mensaje = f"CARTA DE PRESENTACIÓN:\n{carta}\n\nEXPERIENCIA:\n{experiencia}\n\nPORTAFOLIO/ENLACE:\n{link}"
        
        try:
            # Validar duplicado
            if Postulacion.objects.filter(proyecto=proyecto, desarrollador=request.user).exists():
                messages.warning(request, "Ya te habías postulado a este proyecto anteriormente.")
                return redirect('dashboard_desarrollador')
            
            # Validar límite de 3 postulaciones/proyectos activos
            active_count = (
                Postulacion.objects.filter(desarrollador=request.user, estado='pendiente').count() +
                Contratacion.objects.filter(desarrollador=request.user, estado='activa').count()
            )
            if active_count >= 3:
                messages.error(request, "Límite alcanzado: No puedes tener más de 3 postulaciones o proyectos activos.")
                return redirect('dashboard_desarrollador')
            
            Postulacion.objects.create(
                proyecto=proyecto,
                desarrollador=request.user,
                mensaje=mensaje,
                estado='pendiente'
            )
            
            messages.success(request, f"¡Te has postulado al proyecto '{proyecto.titulo}'!")
            return redirect('dashboard_desarrollador')
        except Exception as e:
            messages.error(request, f"Error del sistema: {str(e)}")
            return redirect('dashboard_desarrollador')
                
    return render(request, 'postulaciones/postularse.html', {'proyecto': proyecto})

@login_required
def aceptar_postulacion(request, postulacion_id):
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')

    postulacion = get_object_or_404(Postulacion, id=postulacion_id, proyecto__empresa=request.user)
    proyecto_id = postulacion.proyecto.id

    if request.method == 'POST':
        try:
            with transaction.atomic():
                postulacion = Postulacion.objects.select_for_update().get(
                    id=postulacion_id, proyecto__empresa=request.user, estado='pendiente')
                proyecto = postulacion.proyecto

                Contratacion.objects.create(
                    proyecto=proyecto,
                    desarrollador=postulacion.desarrollador,
                    empresa=request.user,
                    estado='activa',
                )

                postulacion.estado = 'aceptada'
                postulacion.save()

                if proyecto.estado == 'publicado':
                    proyecto.estado = 'en_desarrollo'
                    proyecto.save()
                    proyecto.registrar_cambio_estado('en_desarrollo', request.user)

                LogAuditoria.objects.create(
                    usuario=request.user,
                    accion=f"Aceptó postulación de {postulacion.desarrollador.nombre} en {proyecto.titulo}",
                    tabla_afectada='postulaciones',
                    registro_id=postulacion.id,
                )

            messages.success(request, "¡Contratación exitosa! El desarrollador ha sido vinculado al proyecto.")
        except Postulacion.DoesNotExist:
            messages.error(request, "La postulación ya fue procesada o no existe.")
        except Exception as e:
            messages.error(request, f"Error al procesar: {str(e)}")
    else:
        messages.warning(request, "Acción no permitida.")

    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto_id)
