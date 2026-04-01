
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0007_remove_usuario_bloqueado_hasta_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='usuario',
            name='first_name',
        ),
        migrations.RemoveField(
            model_name='usuario',
            name='last_name',
        ),
    ]
