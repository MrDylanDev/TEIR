
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mensajes', '0002_alter_mensaje_table'),
        ('proyectos', '0004_valoracion_rol_evaluador_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='mensaje',
            name='proyecto',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='proyectos.proyecto'),
        ),
        migrations.AlterModelTable(
            name='mensaje',
            table='mensajes',
        ),
    ]
