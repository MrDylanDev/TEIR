from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Contratacion
from proyectos.models import Proyecto
from notificaciones.models import Notificacion

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
    
    # Seguridad: Solo las partes involucradas o el admin pueden ver
    if request.user != contrato.empresa and request.user != contrato.desarrollador and request.user.rol != 'administrador':
        return redirect('inicio')
        
    return render(request, 'contrataciones/detalle.html', {'contrato': contrato})

@login_required
def cancelar_contratacion(request, contratacion_id):
    """Permitir a la empresa cancelar un contrato activo"""
    if request.user.rol != 'empresa':
        return redirect('inicio')
        
    contrato = get_object_or_404(Contratacion, id=contratacion_id, empresa=request.user)
    
    if contrato.estado == 'activa':
        proyecto = contrato.proyecto
        
        # 1. Cancelar el contrato primero
        contrato.estado = 'cancelada'
        contrato.save()
        
        # 2. Recalcular vacantes ocupadas
        contrataciones_restantes = Contratacion.objects.filter(proyecto=proyecto, estado='activa').count()
        
        # 3. Solo volver a 'publicado' si ahora hay vacantes libres (ocupadas < totales)
        if contrataciones_restantes < proyecto.vacantes:
            proyecto.estado = 'publicado'
            proyecto.save()
            msg_estado = "El proyecto vuelve a estar disponible en el catálogo."
        else:
            msg_estado = "El proyecto permanece en desarrollo con las vacantes restantes."
        
        # 4. Notificar al desarrollador
        Notificacion.objects.create(
            usuario=contrato.desarrollador,
            tipo='alerta',
            mensaje=f"Tu contrato para el proyecto '{proyecto.titulo}' ha sido cancelado por la empresa."
        )
        
        messages.warning(request, f"Contrato con {contrato.desarrollador.username} cancelado. {msg_estado}")
    else:
        messages.error(request, "Solo se pueden cancelar contratos que estén en estado activo.")
        
    return redirect('dashboard_empresa')
