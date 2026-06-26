from notificaciones.models import Notificacion


def get_notificaciones_context(user_id):
    """Retorna historial de notificaciones y conteo de pendientes."""
    notificaciones_recientes = list(
        Notificacion.objects.filter(usuario_id=user_id)
        .order_by('-fecha')
        .values('tipo', 'mensaje', 'fecha', 'leida')[:10]
    )
    pendientes_count = Notificacion.objects.filter(usuario_id=user_id, leida=False).count()
    return notificaciones_recientes, pendientes_count
