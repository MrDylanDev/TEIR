

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('logs', '0001_initial'),
    ]

    operations = [
        # Las tablas 'copias_seguridad' y 'logs_auditoria' ya existen en la BD con estos nombres.
        # No-op para sincronizar sin modificar la BD.
    ]
