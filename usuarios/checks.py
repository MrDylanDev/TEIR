from django.core.checks import Warning, register, Tags
from django.db import connection
from django.db.utils import OperationalError, ProgrammingError

REQUIRED_VIEWS = [
    'v_calificacion_desarrolladores',
    'v_dashboard_desarrollador',
    'v_dashboard_empresa',
    'v_estadisticas_sistema',
    'v_notificaciones_pendientes',
    'v_portafolio_publico',
    'v_proyectos_alerta_inactividad',
    'v_proyectos_disponibles',
    'v_proyectos_en_desarrollo',
    'v_reputacion_empresas',
    'v_top_desarrolladores'
]

REQUIRED_SPS = [
    'sp_calificar_proyecto',
    'sp_cancelar_contratacion'
]

@register(Tags.database)
def check_sql_dependencies(app_configs, **kwargs):
    errors = []
    try:
        with connection.cursor() as cursor:
            # Check for views
            cursor.execute("SHOW FULL TABLES WHERE Table_type = 'VIEW'")
            existing_views = {row[0].lower() for row in cursor.fetchall()}
            
            for view in REQUIRED_VIEWS:
                if view.lower() not in existing_views:
                    errors.append(
                        Warning(
                            f"Falta la vista SQL requerida: '{view}'.",
                            hint="Verifica que el script 'Tem_bd.sql' se haya ejecutado en la base de datos.",
                            id='usuarios.W001',
                        )
                    )
            
            # Check for stored procedures
            cursor.execute("SHOW PROCEDURE STATUS WHERE Db = DATABASE()")
            existing_sps = {row[1].lower() for row in cursor.fetchall()}
            
            for sp in REQUIRED_SPS:
                if sp.lower() not in existing_sps:
                    errors.append(
                        Warning(
                            f"Falta el procedimiento almacenado requerido: '{sp}'.",
                            hint="Verifica que el script 'Tem_bd.sql' se haya ejecutado en la base de datos.",
                            id='usuarios.W002',
                        )
                    )
    except (OperationalError, ProgrammingError):
        # Base de datos no disponible o aún no inicializada
        pass

    return errors
