
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('notificaciones', '0003_alter_notificacion_options_and_more'),
        ('proyectos', '0010_alter_valoracion_puntuacion'),
    ]

    operations = [
        migrations.AddField(
            model_name='notificacion',
            name='proyecto',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='notificaciones', to='proyectos.proyecto'),
        ),
    ]
