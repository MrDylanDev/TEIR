from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Avance
from proyectos.models import Proyecto
from contrataciones.models import Contratacion

@login_required
def registrar_avance(request, proyecto_id):
    if request.user.rol != 'desarrollador':
        messages.error(request, "Solo los desarrolladores pueden registrar avances.")
        return redirect('dashboard_desarrollador' if request.user.rol == 'desarrollador' else 'inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    # 1. Verificar el estado del proyecto: Solo se permiten avances en proyectos 'en_desarrollo'
    if proyecto.estado != 'en_desarrollo':
        messages.warning(request, "Ya no puedes subir más avances para este proyecto, pues ya se encuentra al 100% y en proceso de revisión.")
        return redirect('/desarrollador/dashboard/?section=activos')

    # 2. Verificar que el desarrollador está contratado para este proyecto
    contratado = Contratacion.objects.filter(proyecto=proyecto, desarrollador=request.user, estado='activa').exists()
    if not contratado:
        messages.error(request, "No tienes un contrato activo para este proyecto.")
        return redirect('/desarrollador/dashboard/?section=activos')

    if request.method == 'POST':
        try:
            descripcion = request.POST.get('descripcion')
            archivo_url = request.POST.get('archivo_url')
            entregable_id = request.POST.get('entregable_id') # Nuevo campo
            
            if not entregable_id:
                messages.error(request, "Debes seleccionar un hito para registrar el avance.")
                return redirect('registrar_avance', proyecto_id=proyecto.id)

            from django.db import connection
            with connection.cursor() as cursor:
                cursor.callproc('sp_subir_avance', [
                    proyecto.id, 
                    request.user.id, 
                    entregable_id, # Enviamos el ID del hito
                    descripcion, 
                    archivo_url
                ])
                cursor.fetchone()
            
            messages.success(request, "¡Hito completado y avance registrado exitosamente!")
            return redirect('/desarrollador/dashboard/?section=activos')
        except Exception as e:
            error_msg = str(e)
            messages.error(request, f"Error al registrar avance: {error_msg}")

    # Obtener hitos pendientes para el select del formulario
    from proyectos.models import Entregable
    hitos_pendientes = Entregable.objects.filter(proyecto=proyecto, estado='pendiente')

    return render(request, 'avances/registrar.html', {
        'proyecto': proyecto,
        'hitos_pendientes': hitos_pendientes
    })

@login_required
def ver_avances(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    # Verificar si el usuario tiene relación con el proyecto (Desarrollador, Empresa, Admin)
    es_admin = request.user.rol == 'administrador'
    es_empresa_duena = (request.user.rol == 'empresa' and proyecto.empresa == request.user)
    es_desarrollador_relacionado = Contratacion.objects.filter(
        proyecto=proyecto, 
        desarrollador=request.user
    ).exists()

    if not (es_admin or es_empresa_duena or es_desarrollador_relacionado):
        messages.error(request, "No tienes permisos para ver los avances de este proyecto.")
        if request.user.rol == 'desarrollador':
            return redirect('dashboard_desarrollador')
        elif request.user.rol == 'empresa':
            return redirect('dashboard_empresa')
        return redirect('inicio')
        
    avances = Avance.objects.filter(proyecto=proyecto).order_by('-fecha_hora')
    
    # Obtener el progreso total desde la vista SQL
    individuales = 0
    from django.db import connection
    with connection.cursor() as cursor:
        cursor.execute("SELECT porcentaje_avance_promedio FROM v_proyectos_en_desarrollo WHERE proyecto_id = %s", [proyecto.id])
        row = cursor.fetchone()
        if row:
            individuales = row[0]

    return render(request, 'avances/ver_lista.html', {
        'proyecto': proyecto, 
        'avances': avances,
        'individuales': individuales
    })
