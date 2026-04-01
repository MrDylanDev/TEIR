
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('avances', '0004_remove_avance_porcentaje_avance_entregable'),
    ]

    operations = [
        migrations.AddField(
            model_name='avance',
            name='comentario_revision',
            field=models.TextField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='avance',
            name='estado',
            field=models.CharField(choices=[('pendiente', 'Pendiente de Revisión'), ('aceptado', 'Aceptado'), ('rechazado', 'Rechazado')], default='pendiente', max_length=20),
        ),
    ]
