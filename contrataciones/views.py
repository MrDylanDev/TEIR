from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import connection
from .models import Contratacion
from proyectos.models import Proyecto

@login_required
def listar_contrataciones_empresa(request):
    """Listado de todos los desarrolladores contratados por la empresa"""
    if request.user.rol != 'empresa':
        return redirect('inicio')
    
    contrataciones = Contratacion.objects.filter(empresa=request.user).select_related('proyecto', 'desarrollador').order_by('-fecha_inicio')
    return render(request, 'contrataciones/lista_empresa.html', {'contrataciones': contrataciones})

@login_required
def ver_detalle_contrato(request, contratacion_id):
    """Ver detalles técnicos de un contrato específico"""
    contrato = get_object_or_404(Contratacion, id=contratacion_id)
    
    # Seguridad
    if request.user != contrato.empresa and request.user != contrato.desarrollador and request.user.rol != 'administrador':
        return redirect('inicio')
        
    return render(request, 'contrataciones/detalle.html', {'contrato': contrato})

@login_required
def cancelar_contratacion(request, contratacion_id):
    """Permitir a la empresa cancelar un contrato activo mediante un Procedimiento Almacenado"""
    if request.user.rol != 'empresa':
        return redirect('inicio')
        
    contrato = get_object_or_404(Contratacion, id=contratacion_id, empresa=request.user)
    
    try:
        with connection.cursor() as cursor:
            # Invocar la lógica atómica de la base de datos
            cursor.callproc('sp_cancelar_contratacion', [contrato.id, request.user.id])
            
            # Capturar el resultado del SP
            row = cursor.fetchone()
            if row and len(row) > 1:
                messages.warning(request, row[1]) # Mensaje dinámico desde la DB
            else:
                messages.warning(request, "Contrato cancelado exitosamente.")
                
    except Exception as e:
        messages.error(request, f"Error al cancelar contrato: {str(e)}")
        
    return redirect('dashboard_empresa')
