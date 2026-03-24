

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contrataciones', '0003_alter_contratacion_table'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='contratacion',
            table='contrataciones',
        ),
    ]
