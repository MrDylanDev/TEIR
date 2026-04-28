from django.core.cache import cache
from .models import Usuario

def get_admin_id():
    """
    Retorna el ID del primer administrador encontrado, usando caché para optimizar el rendimiento.
    Retorna None si no existe ningún administrador en el sistema (nunca usa un ID por defecto).
    """
    cached_id = cache.get('admin_id')
    if cached_id is not None:
        return cached_id

    admin_id = Usuario.objects.filter(rol='administrador').values_list('id', flat=True).first()

    # Solo cacheamos si encontramos un admin real; evitamos cachear None
    if admin_id is not None:
        cache.set('admin_id', admin_id, timeout=300)

    return admin_id  # Puede ser None si no hay administradores

def get_admin_ids():
    """Retorna una lista con los IDs de todos los administradores del sistema, optimizando con caché."""
    cached_ids = cache.get('admin_ids_list')
    if cached_ids:
        return cached_ids
        
    ids = list(Usuario.objects.filter(rol='administrador').values_list('id', flat=True))
    
    # Cacheamos la lista por 5 minutos
    cache.set('admin_ids_list', ids, timeout=300)
    return ids
