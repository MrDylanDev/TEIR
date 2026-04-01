
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('avances', '0005_avance_comentario_revision_avance_estado'),
        ('proyectos', '0009_remove_proyecto_aprobado_por_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='avance',
            name='entregable',
            field=models.ForeignKey(db_column='entregable_id', null=True, on_delete=django.db.models.deletion.CASCADE, to='proyectos.entregable'),
        ),
    ]
