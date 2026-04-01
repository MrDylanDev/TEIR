
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contrataciones', '0005_alter_contratacion_estado_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='contratacion',
            name='asignado_por',
        ),
    ]
