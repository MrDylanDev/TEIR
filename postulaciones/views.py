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
            from django.db import connection
            mensaje = request.POST.get('mensaje')
            
            # Llamamos al procedimiento almacenado de MySQL (Soberanía MySQL)
            # Esto validará automáticamente el límite de 3 proyectos.
            with connection.cursor() as cursor:
                cursor.execute("CALL sp_postularse(%s, %s, %s)", [proyecto_id, request.user.id, mensaje])
                result = cursor.fetchone()
                msg_exito = result[1] if result else "Postulación enviada."
                
            messages.success(request, msg_exito)
            return redirect('dashboard_desarrollador')
        except Exception as e:
            # Capturamos el error enviado por el SIGNAL de MySQL
            error_msg = str(e).split(",")[1].replace("'", "").strip() if "," in str(e) else str(e)
            messages.error(request, f"Error: {error_msg}")
            
    return render(request, 'postulaciones/postularse.html', {'proyecto': proyecto})

@login_required
def ver_postulaciones_empresa(request, proyecto_id):
    if request.user.rol != 'empresa':
        return redirect('inicio')
        
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    postulaciones = Postulacion.objects.filter(proyecto=proyecto)
    return render(request, 'postulaciones/lista_recibidas.html', {'proyecto': proyecto, 'postulaciones': postulaciones})

@login_required
def aceptar_postulacion(request, postulacion_id):
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado. Solo las empresas pueden contratar.")
        return redirect('inicio')

    postulacion = get_object_or_404(Postulacion, id=postulacion_id, proyecto__empresa=request.user)
    proyecto = postulacion.proyecto

    if proyecto.estado != 'publicado':
        messages.error(request, f"El proyecto '{proyecto.titulo}' ya no está disponible para contratación (Estado actual: {proyecto.get_estado_display()}).")
        return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)

    if request.method == 'POST':
        try:
            with transaction.atomic():
                # BLOQUEO ATÓMICO: Seleccionamos el proyecto y bloqueamos la fila en la DB 
                # hasta que termine la transacción para evitar condiciones de carrera.
                proyecto_lock = Proyecto.objects.select_for_update().get(id=proyecto.id)
                
                # Verificar nuevamente disponibilidad bajo bloqueo
                contrataciones_actuales = Contratacion.objects.filter(proyecto=proyecto_lock, estado='activa').count()
                
                if contrataciones_actuales >= proyecto_lock.vacantes:
                    messages.error(request, "Ya no hay vacantes disponibles para este proyecto.")
                    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)

                # 1. Actualizar estado de la postulación
                postulacion.estado = 'aceptada'
                postulacion.save()

                # 2. Crear el registro de contratación
                Contratacion.objects.create(
                    proyecto=proyecto_lock,
                    desarrollador=postulacion.desarrollador,
                    empresa=request.user,
                    fecha_inicio=timezone.now().date(),
                    estado='activa'
                )

                # 3. Verificar si tras esta contratación se llenaron las vacantes
                nuevas_contrataciones = contrataciones_actuales + 1
                
                if nuevas_contrataciones >= proyecto_lock.vacantes:
                    # Cerrar proyecto
                    proyecto_lock.estado = 'en_desarrollo'
                    proyecto_lock.save()

                    # Rechazar automáticamente las demás postulaciones pendientes
                    Postulacion.objects.filter(proyecto=proyecto_lock, estado='pendiente').update(estado='rechazada')
                    
                    messages.success(request, f"¡Contratación exitosa! Se han completado las vacantes y el proyecto ha pasado a desarrollo.")
                else:
                    messages.success(request, f"Has contratado a {postulacion.desarrollador.username}. Quedan {proyecto_lock.vacantes - nuevas_contrataciones} vacantes.")

        except Exception as e:
            messages.error(request, f"Error técnico al procesar la contratación: {str(e)}")
            # Log del error para depuración
            print(f"DEBUG ERROR: {e}")
    else:
        messages.warning(request, "Acción no permitida vía GET.")

    return redirect('ver_postulaciones_empresa', proyecto_id=proyecto.id)
