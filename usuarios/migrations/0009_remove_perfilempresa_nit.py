
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0008_remove_usuario_first_name_remove_usuario_last_name'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='perfilempresa',
            name='nit',
        ),
    ]
