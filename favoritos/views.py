from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Favorito
from proyectos.models import Proyecto

@login_required
def toggle_favorito(request, proyecto_id):
    """Añadir o quitar un proyecto de favoritos"""
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
        
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    favorito_qs = Favorito.objects.filter(desarrollador=request.user, proyecto=proyecto)
    
    if favorito_qs.exists():
        favorito_qs.delete()
        messages.info(request, f"Proyecto '{proyecto.titulo}' quitado de favoritos.")
    else:
        Favorito.objects.create(desarrollador=request.user, proyecto=proyecto)
        messages.success(request, f"Proyecto '{proyecto.titulo}' añadido a favoritos ❤️")
        
    # Redirigir a donde venía el usuario
    return redirect(request.META.get('HTTP_REFERER', 'listar_proyectos'))

@login_required
def listar_favoritos(request):
    """Ver lista de proyectos favoritos del desarrollador"""
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
        
    favoritos = Favorito.objects.filter(desarrollador=request.user).select_related('proyecto')
    return render(request, 'favoritos/lista.html', {'favoritos': favoritos})
