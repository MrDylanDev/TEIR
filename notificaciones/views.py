from django.shortcuts import render, get_object_or_404, redirect
from django.contrib.auth.decorators import login_required
from .models import Notificacion
from django.contrib import messages

@login_required
def lista_notificaciones(request):
    """Lista todas las notificaciones del usuario actual."""
    notificaciones = Notificacion.objects.filter(usuario=request.user).order_by('-fecha')
    
    # Obtenemos las últimas 10 para una vista rápida si se prefiere
    historial = notificaciones[:10]
    
    return render(request, 'notificaciones/lista.html', {
        'notificaciones': notificaciones,
        'historial': historial
    })

@login_required
def marcar_leida(request, notificacion_id):
    """Marca una notificación específica como leída."""
    notificacion = get_object_or_404(Notificacion, id=notificacion_id, usuario=request.user)
    notificacion.leida = True
    notificacion.save()
    return redirect('notificaciones_lista')

@login_required
def marcar_todas_leidas(request):
    """Marca todas las notificaciones pendientes del usuario como leídas."""
    Notificacion.objects.filter(usuario=request.user, leida=False).update(leida=True)
    messages.success(request, "Todas las notificaciones han sido marcadas como leídas.")
    return redirect('notificaciones_lista')
