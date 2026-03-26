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
    
    # En lugar de get_object_or_404, usamos filter para manejar el error amigablemente
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
            # Capturamos el mensaje de error del SIGNAL SQLSTATE '45000' de MySQL de forma robusta
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
            error_msg = e.args[1] if hasattr(e, 'args') and len(e.args) > 1 else str(e)
            if 'Postulación no válida' in error_msg:
                messages.warning(request, "La postulación ya no es válida o el proyecto ya no tiene vacantes.")
            else:
                messages.error(request, f"Error al procesar la contratación: {error_msg}")
    else:
        messages.warning(request, "Para contratar utiliza el botón de aceptar en la lista de postulaciones.")

    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto_id)
