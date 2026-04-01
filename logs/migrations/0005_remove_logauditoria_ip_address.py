
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('logs', '0004_alter_copiaseguridad_ejecutado_por'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='logauditoria',
            name='ip_address',
        ),
    ]
