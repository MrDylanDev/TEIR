from django.shortcuts import redirect
from django.contrib import messages
from django.contrib.auth import logout
from functools import wraps

def requiere_usuario_activo(view_func):
    """
    Decorador para asegurar que el usuario tenga estado 'activo'.
    Si no lo tiene, cierra la sesión y redirige al login con un mensaje de error.
    """
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        if request.user.is_authenticated and request.user.estado != 'activo':
            logout(request)
            messages.error(request, "Tu cuenta ha sido suspendida o está inactiva. Contacta al administrador.")
            return redirect('login')
        return view_func(request, *args, **kwargs)
    return _wrapped_view
