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
            porcentaje = int(request.POST.get('porcentaje', 0))
            
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.callproc('sp_subir_avance', [
                    proyecto.id, 
                    request.user.id, 
                    descripcion, 
                    archivo_url, 
                    porcentaje
                ])
                # Capturamos el resultado del SP
                row = cursor.fetchone()
                if row and len(row) > 1:
                    messages.success(request, row[1]) # 'Avance registrado correctamente'
                else:
                    messages.success(request, "Avance registrado correctamente.")
            
            return redirect('/desarrollador/dashboard/?section=activos')
        except Exception as e:
            # Capturar mensaje de error del SIGNAL SQLSTATE '45000' de forma robusta
            error_msg = e.args[1] if hasattr(e, 'args') and len(e.args) > 1 else str(e)
            
            if 'Solo puedes registrar un avance' in error_msg:
                messages.warning(request, "Límite alcanzado: Solo puedes registrar un avance por día en este proyecto.")
            else:
                messages.error(request, f"Error al registrar avance: {error_msg}")

    return render(request, 'avances/registrar.html', {'proyecto': proyecto})

@login_required
def ver_avances(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    # Verificar si el usuario tiene relación con el proyecto (Desarrollador, Empresa dueña o Admin)
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
    return render(request, 'avances/ver_lista.html', {'proyecto': proyecto, 'avances': avances})
