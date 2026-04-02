
from django.conf import settings
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('contrataciones', '0007_remove_contratacion_fecha_fin_estimada'),
        ('proyectos', '0010_alter_valoracion_puntuacion'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='contratacion',
            unique_together={('proyecto', 'desarrollador')},
        ),
    ]
