
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contrataciones', '0006_remove_contratacion_asignado_por'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='contratacion',
            name='fecha_fin_estimada',
        ),
    ]
