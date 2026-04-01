
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('avances', '0003_alter_avance_archivo_url_alter_avance_table'),
        ('proyectos', '0007_alter_historialestadoproyecto_estado_anterior_and_more'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='avance',
            name='porcentaje',
        ),
        migrations.AddField(
            model_name='avance',
            name='entregable',
            field=models.ForeignKey(db_column='entregable_id', null=True, on_delete=django.db.models.deletion.SET_NULL, to='proyectos.entregable'),
        ),
    ]
