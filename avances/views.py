from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Avance
from proyectos.models import Proyecto
from contrataciones.models import Contratacion

@login_required
def registrar_avance(request, proyecto_id):
    if request.user.rol != 'desarrollador':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    # Verificar que el desarrollador está contratado para este proyecto
    contratado = Contratacion.objects.filter(proyecto=proyecto, desarrollador=request.user, estado='activa').exists()
    if not contratado:
        messages.error(request, "No tienes un contrato activo para este proyecto.")
        return redirect('dashboard_desarrollador')

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
            
            return redirect('dashboard_desarrollador')
        except Exception as e:
            # Capturar errores personalizados del SP (SIGNAL SQLSTATE '45000')
            error_msg = str(e)
            if 'Solo puedes registrar un avance' in error_msg:
                messages.warning(request, "Límite alcanzado: Solo puedes registrar un avance por día en este proyecto.")
            else:
                messages.error(request, f"Error al registrar avance: {e}")

    return render(request, 'avances/registrar.html', {'proyecto': proyecto})

@login_required
def ver_avances(request, proyecto_id):
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    # Solo la empresa dueña o el admin pueden ver avances
    if request.user.rol != 'administrador' and proyecto.empresa != request.user:
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')
        
    avances = Avance.objects.filter(proyecto=proyecto).order_by('-fecha_hora')
    return render(request, 'avances/ver_lista.html', {'proyecto': proyecto, 'avances': avances})
