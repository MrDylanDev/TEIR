
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('avances', '0006_alter_avance_entregable'),
        ('proyectos', '0010_alter_valoracion_puntuacion'),
    ]

    operations = [
        migrations.AlterField(
            model_name='avance',
            name='entregable',
            field=models.ForeignKey(db_column='entregable_id', on_delete=django.db.models.deletion.CASCADE, to='proyectos.entregable'),
        ),
    ]
