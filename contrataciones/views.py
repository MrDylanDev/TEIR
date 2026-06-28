from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from django.contrib import messages
from django.db import transaction
from .models import Contratacion
from proyectos.models import Proyecto
from logs.models import LogAuditoria

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
@require_POST
def cancelar_contratacion(request, contratacion_id):
    """Permitir a la empresa cancelar un contrato activo"""
    if request.user.rol != 'empresa':
        return redirect('inicio')
        
    contrato = get_object_or_404(Contratacion, id=contratacion_id, empresa=request.user)
    
    try:
        with transaction.atomic():
            contrato = Contratacion.objects.select_for_update().get(
                id=contratacion_id, empresa=request.user, estado='activa')
            contrato.estado = 'cancelada'
            contrato.save()

            if Contratacion.objects.filter(
                proyecto=contrato.proyecto, estado='activa'
            ).count() == 0 and contrato.proyecto.estado == 'en_desarrollo':
                proy = contrato.proyecto
                estado_anterior = proy.estado
                proy.estado = 'publicado'
                proy.save()
                proy.registrar_cambio_estado('publicado', request.user, estado_anterior=estado_anterior)

            LogAuditoria.objects.create(
                usuario=request.user,
                accion=f"Canceló contratación en {contrato.proyecto.titulo}",
                tabla_afectada='contrataciones',
                registro_id=contrato.id,
            )

        messages.warning(request, "Contrato cancelado exitosamente.")
    except Exception as e:
        messages.error(request, f"Error al cancelar contrato: {str(e)}")
        
    return redirect('dashboard_empresa')
