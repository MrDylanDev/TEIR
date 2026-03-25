from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction
from .models import Postulacion
from proyectos.models import Proyecto
from django.utils import timezone

@login_required
def ver_postulaciones_empresa(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    postulaciones = Postulacion.objects.filter(proyecto=proyecto).select_related('desarrollador').order_by('-fecha')
    return render(request, 'postulaciones/lista_empresa.html', {'proyecto': proyecto, 'postulaciones': postulaciones})

@login_required
def postularse_a_proyecto(request, proyecto_id):
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, estado='publicado')
    
    if request.method == 'POST':
        mensaje = request.POST.get('mensaje')
        try:
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.callproc('sp_postularse', [proyecto.id, request.user.id, mensaje])
                
            messages.success(request, f"¡Te has postulado exitosamente al proyecto '{proyecto.titulo}'!")
        except Exception as e:
            error_msg = str(e)
            if 'No puedes tener más de 3' in error_msg:
                messages.error(request, "Límite alcanzado: Tienes 3 proyectos activos/postulaciones. Finaliza o cancela para aplicar a nuevos.")
            elif 'Ya te postulaste' in error_msg:
                messages.warning(request, "Ya te habías postulado a este proyecto anteriormente.")
            else:
                messages.error(request, f"Error al postularse: {e}")
                
    return redirect('dashboard_desarrollador')

@login_required
def aceptar_postulacion(request, postulacion_id):
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado. Solo empresas pueden aceptar postulaciones.")
        return redirect('inicio')

    postulacion = get_object_or_404(Postulacion, id=postulacion_id, proyecto__empresa=request.user)
    proyecto_id = postulacion.proyecto.id

    if request.method == 'POST':
        try:
            from django.db import connection
            
            # Invocamos sp_aceptar_postulacion
            
            with connection.cursor() as cursor:
                cursor.callproc('sp_aceptar_postulacion', [postulacion_id, request.user.id])
                result = cursor.fetchone()
                msg_exito = result[1] if result and len(result) > 1 else "Contratación realizada exitosamente."
                
            messages.success(request, msg_exito)
        except Exception as e:
            error_msg = str(e)
            if 'Postulación no válida' in error_msg:
                messages.warning(request, "La postulación ya no es válida o el proyecto ya no tiene vacantes.")
            else:
                messages.error(request, f"Error al procesar la contratación: {e}")
    else:
        messages.warning(request, "Para contratar utiliza el botón de aceptar en la lista de postulaciones.")

    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto_id)
