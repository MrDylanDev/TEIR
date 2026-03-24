from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Favorito
from proyectos.models import Proyecto

@login_required
def toggle_favorito(request, proyecto_id):
    """Añadir o quitar un proyecto de favoritos usando SP de MySQL"""
    if request.user.rol != 'desarrollador':
        return redirect('inicio')
        
    from django.db import connection
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    try:
        # Llamamos al procedimiento almacenado de MySQL
        with connection.cursor() as cursor:
            cursor.execute("CALL sp_toggle_favorito(%s, %s)", [request.user.id, proyecto_id])
            result = cursor.fetchone()
            mensaje = result[0] if result else "Acción realizada"
            
        messages.success(request, mensaje)
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
