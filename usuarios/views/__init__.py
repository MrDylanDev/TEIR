# usuarios/views/__init__.py
# Re-exporta todas las vistas para mantener compatibilidad con urls.py
# (from . import views → views.login_view, views.inicio, etc.)

from .auth_views import (
    login_view,
    logout_view,
    recuperar_view,
    restablecer_view,
)

from .registration_views import (
    registro_view,
)

from .profile_views import (
    editar_perfil,
)

from .dashboard_views import (
    inicio,
    dashboard_empresa,
    dashboard_desarrollador,
    dashboard_admin,
    marcar_notificaciones_leidas,
    admin_toggle_usuario,
    admin_reactivar_proyecto,
    api_usuarios,
    api_usuario_detalle,
    api_crear_usuario,
    api_actualizar_usuario,
    api_eliminar_usuario,
)
