from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from django.contrib import messages
from .models import Favorito
from proyectos.models import Proyecto

@login_required
@require_POST
def toggle_favorito(request, proyecto_id):
    """Añadir o quitar un proyecto de favoritos"""
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
        
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    try:
        favorito, created = Favorito.objects.get_or_create(
            desarrollador=request.user,
            proyecto=proyecto
        )
        if not created:
            favorito.delete()
            messages.success(request, "Proyecto eliminado de favoritos.")
        else:
            messages.success(request, "Proyecto añadido a favoritos.")
    except Exception as e:
        messages.error(request, f"Error al procesar favorito: {e}")
        
    return redirect(request.META.get('HTTP_REFERER', 'listar_proyectos'))

@login_required
def listar_favoritos(request):
    """Ver lista de proyectos favoritos del desarrollador"""
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
        
    favoritos = Favorito.objects.filter(desarrollador=request.user).select_related('proyecto')
    return render(request, 'favoritos/lista.html', {'favoritos': favoritos})
