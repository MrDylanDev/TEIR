
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0006_remove_usuario_fecha_registro_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='usuario',
            name='bloqueado_hasta',
        ),
        migrations.RemoveField(
            model_name='usuario',
            name='is_staff',
        ),
    ]
