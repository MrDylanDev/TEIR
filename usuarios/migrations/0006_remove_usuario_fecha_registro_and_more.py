
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0005_rename_cedula_usuario_identificacion_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='usuario',
            name='fecha_registro',
        ),
        migrations.RemoveField(
            model_name='usuario',
            name='ultimo_acceso',
        ),
    ]
