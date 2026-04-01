from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth import logout
from functools import wraps

def requiere_usuario_activo(view_func):
    """
    Decorador para asegurar que el usuario no esté bloqueado.
    Si está suspendido o inactivo, cierra la sesión y redirige al login.
    """
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated:
            # Solo expulsamos si el estado es explícitamente de bloqueo
            if request.user.estado in ['suspendido', 'inactivo']:
                logout(request)
                messages.error(request, "Tu cuenta ha sido suspendida o está inactiva. Contacta al administrador.")
                return redirect('login')
        return view_func(request, *args, **kwargs)
    return _wrapped_view
