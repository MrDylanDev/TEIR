from django.db import connection


def get_notificaciones_context(user_id):
    """Retorna historial de notificaciones y conteo de pendientes."""
    notificaciones_recientes = []
    pendientes_count = 0
    with connection.cursor() as cursor:
        # 1. Historial (10 últimas)
        cursor.execute("""
            SELECT tipo, mensaje, fecha, leida 
            FROM notificaciones 
            WHERE usuario_id = %s 
            ORDER BY fecha DESC 
            LIMIT 10
        """, [user_id])
        rows = cursor.fetchall()
        for row in rows:
            notificaciones_recientes.append({
                'tipo': row[0], 'mensaje': row[1], 'fecha': row[2], 'leida': row[3]
            })
        
        # 2. Conteo de pendientes desde la vista SQL
        cursor.execute("SELECT COUNT(*) FROM v_notificaciones_pendientes WHERE usuario_id = %s", [user_id])
        pendientes_count = cursor.fetchone()[0]
        
    return notificaciones_recientes, pendientes_count
