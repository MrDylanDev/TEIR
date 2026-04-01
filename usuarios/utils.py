from django.core.cache import cache
from .models import Usuario

def get_admin_id():
    """Retorna el ID del primer administrador encontrado, usando caché para optimizar el rendimiento."""
    cached_id = cache.get('admin_id')
    if cached_id:
        return cached_id
        
    admin_id = Usuario.objects.filter(rol='administrador').values_list('id', flat=True).first()
    result = admin_id or 1
    
    # Cacheamos el resultado por 5 minutos (300 segundos) para mayor frescura
    cache.set('admin_id', result, timeout=300)
    return result

def get_admin_ids():
    """Retorna una lista con los IDs de todos los administradores del sistema, optimizando con caché."""
    cached_ids = cache.get('admin_ids_list')
    if cached_ids:
        return cached_ids
        
    ids = list(Usuario.objects.filter(rol='administrador').values_list('id', flat=True))
    
    # Cacheamos la lista por 5 minutos
    cache.set('admin_ids_list', ids, timeout=300)
    return ids
