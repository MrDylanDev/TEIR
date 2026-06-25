from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from django.utils import timezone
from django.core.mail import send_mail
from django.conf import settings
from django.urls import reverse
from datetime import timedelta
import secrets

from ..models import Usuario


def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        rol_seleccionado = request.POST.get('rol_seleccionado')
        
        # 1. Verificación preventiva de bloqueo y obtención del objeto usuario
        user_to_check = None
        try:
            user_to_check = Usuario.objects.get(username=username)
            if user_to_check.estado in ['suspendido', 'inactivo']:
                messages.error(request, "Tu cuenta ha sido suspendida o está inactiva. Por favor, comunícate con el administrador para más información.")
                return redirect('inicio')
        except Usuario.DoesNotExist:
            pass

        # 2. Autenticación normal
        user = authenticate(username=username, password=password)

        if user is not None:
            # 3. Validación de rol: El rol real debe coincidir con el seleccionado en el frontend
            if user.rol != rol_seleccionado:
                messages.error(request, f"No tienes permisos de '{rol_seleccionado}' con esta cuenta.")
                return redirect('inicio')

            # Login exitoso: Resetear intentos fallidos si tenía alguno
            if user.intentos_fallidos > 0:
                user.intentos_fallidos = 0
                user.save(update_fields=['intentos_fallidos'])

            login(request, user)

            if user.rol == 'administrador': return redirect('dashboard_admin')
            if user.rol == 'empresa': return redirect('dashboard_empresa')
            return redirect('dashboard_desarrollador')            
        
        # 4. Manejo de intentos fallidos si el usuario existe
        if user_to_check:
            user_to_check.intentos_fallidos += 1
            if user_to_check.intentos_fallidos >= 5:
                user_to_check.estado = 'suspendido'
                user_to_check.is_active = False  # Bloquear a nivel Django, no solo chequeo manual
                user_to_check.save(update_fields=['intentos_fallidos', 'estado', 'is_active'])
                messages.error(request, "Tu cuenta ha sido suspendida por exceso de intentos fallidos. Contacta a soporte.")
            else:
                user_to_check.save(update_fields=['intentos_fallidos'])
                messages.error(request, f"Usuario o contraseña incorrectos. Intento {user_to_check.intentos_fallidos} de 5.")
        else:
            # Error genérico para usuarios que no existen
            messages.error(request, "Usuario o contraseña incorrectos.")
            
        return redirect('inicio')
            
    return render(request, 'publico/inicio_sesion.html')

def logout_view(request):
    logout(request)
    return redirect('inicio')

def recuperar_view(request):
    if request.method == 'POST':
        email = request.POST.get('email')
        try:
            usuario = Usuario.objects.get(email=email)
            token = secrets.token_urlsafe(32)
            usuario.token_recuperacion = token
            usuario.token_expiracion = timezone.now() + timedelta(hours=1)
            usuario.save(update_fields=['token_recuperacion', 'token_expiracion'])
            
            enlace = request.build_absolute_uri(reverse('restablecer', args=[token]))
            
            mensaje = f"""
Hola {usuario.nombre},

Recibimos una solicitud para restablecer tu contraseña en TEM.
Para elegir una nueva contraseña, haz clic en el siguiente enlace:

{enlace}

Este enlace expirará en 1 hora. Si no solicitaste este cambio, puedes ignorar este correo.

Saludos,
El equipo de TEM
"""
            send_mail(
                'Restablecer tu contraseña en TEM',
                mensaje,
                settings.DEFAULT_FROM_EMAIL,
                [email],
                fail_silently=False,
            )
        except Usuario.DoesNotExist:
            pass # No revelamos si el email existe o no por seguridad
            
        messages.success(request, "Si el correo electrónico existe en nuestra base de datos, recibirás instrucciones para restablecer tu contraseña.")
        return redirect('login')
            
    return render(request, 'publico/recuperarcon.html')

def restablecer_view(request, token):
    try:
        usuario = Usuario.objects.get(token_recuperacion=token)
        
        # Verificar expiración
        if usuario.token_expiracion and usuario.token_expiracion < timezone.now():
            messages.error(request, "El enlace de recuperación ha expirado. Por favor, solicita uno nuevo.")
            return redirect('recuperar')
            
        if request.method == 'POST':
            password = request.POST.get('password')
            password_confirm = request.POST.get('password_confirm')
            
            if password != password_confirm:
                messages.error(request, "Las contraseñas no coinciden.")
                return render(request, 'publico/restablecercon.html', {'token': token})
                
            if len(password) < 8:
                messages.error(request, "La contraseña debe tener al menos 8 caracteres.")
                return render(request, 'publico/restablecercon.html', {'token': token})
                
            # Actualizar contraseña e invalidar token
            usuario.set_password(password)
            usuario.token_recuperacion = None
            usuario.token_expiracion = None
            # Resetear intentos fallidos por si estaba bloqueado temporalmente por contraseña incorrecta
            usuario.intentos_fallidos = 0
            if usuario.estado == 'suspendido' and not usuario.is_active:
                # Si estaba suspendido por intentos, se reactiva
                usuario.estado = 'activo'
                usuario.is_active = True
                
            usuario.save()
            
            messages.success(request, "Tu contraseña ha sido restablecida exitosamente. Ahora puedes iniciar sesión.")
            return redirect('login')
            
        return render(request, 'publico/restablecercon.html', {'token': token})
        
    except Usuario.DoesNotExist:
        messages.error(request, "El enlace de recuperación es inválido o ya ha sido utilizado.")
        return redirect('login')
