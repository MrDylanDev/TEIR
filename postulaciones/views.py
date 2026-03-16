from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction
from .models import Postulacion
from proyectos.models import Proyecto
from contrataciones.models import Contratacion
from django.utils import timezone

@login_required
def postularse_a_proyecto(request, proyecto_id):
    """CU 4: Postularse a un proyecto disponible"""
    if request.user.rol != 'desarrollador':
        messages.error(request, "Solo los desarrolladores pueden postularse.")
        return redirect('dashboard_desarrollador')

    proyecto = get_object_or_404(Proyecto, id=proyecto_id, estado='publicado')
    
    # Verificar si ya está postulado
    if Postulacion.objects.filter(proyecto=proyecto, desarrollador=request.user).exists():
        messages.error(request, "Ya te has postulado a este proyecto.")
        return redirect('listar_proyectos')

    if request.method == 'POST':
        try:
            postulacion = Postulacion(
                proyecto=proyecto,
                desarrollador=request.user,
                mensaje=request.POST.get('mensaje')
            )
            postulacion.save() # Ejecuta validación de límite de 3 (Paso 2)
            messages.success(request, f"Te has postulado exitosamente al proyecto '{proyecto.titulo}'.")
            return redirect('dashboard_desarrollador')
        except Exception as e:
            messages.error(request, f"Error: {e}")
            
    return render(request, 'postulaciones/postularse.html', {'proyecto': proyecto})

@login_required
def ver_postulaciones_empresa(request, proyecto_id):
    """CU 4: Ver postulaciones recibidas para seleccionar desarrollador"""
    if request.user.rol != 'empresa':
        return redirect('inicio')
        
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    postulaciones = Postulacion.objects.filter(proyecto=proyecto)
    return render(request, 'postulaciones/lista_recibidas.html', {'proyecto': proyecto, 'postulaciones': postulaciones})

@login_required
def aceptar_postulacion(request, postulacion_id):
    """CU 4: Seleccionar desarrollador / equipo (Empresa)"""
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')

    postulacion = get_object_or_404(Postulacion, id=postulacion_id, proyecto__empresa=request.user)
    proyecto = postulacion.proyecto

    if proyecto.estado != 'publicado':
        messages.error(request, "Este proyecto ya no está disponible para contratación.")
        return redirect('dashboard_empresa')

    try:
        with transaction.atomic():
            # 1. Aceptar esta postulación
            postulacion.estado = 'aceptada'
            postulacion.save()

            # 2. Crear la contratación
            Contratacion.objects.create(
                proyecto=proyecto,
                desarrollador=postulacion.desarrollador,
                empresa=request.user,
                fecha_inicio=timezone.now().date(),
                estado='activa'
            )

            # 3. Verificar si se agotaron las vacantes
            contrataciones_actuales = Contratacion.objects.filter(proyecto=proyecto, estado='activa').count()
            if contrataciones_actuales >= proyecto.vacantes:
                # 3.1 Cambiar estado del proyecto a 'en_desarrollo'
                proyecto.estado = 'en_desarrollo'
                proyecto.save()

                # 3.2 Rechazar otras postulaciones pendientes para este proyecto
                Postulacion.objects.filter(proyecto=proyecto, estado='pendiente').update(estado='rechazada')
                messages.success(request, f"Has completado las {proyecto.vacantes} vacantes para '{proyecto.titulo}'.")
            else:
                messages.success(request, f"Has contratado a {postulacion.desarrollador.username}. Quedan {proyecto.vacantes - contrataciones_actuales} vacantes.")

    except Exception as e:
        messages.error(request, f"Error al procesar la contratación: {e}")

    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)