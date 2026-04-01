
import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('proyectos', '0009_remove_proyecto_aprobado_por_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='valoracion',
            name='puntuacion',
            field=models.PositiveSmallIntegerField(validators=[django.core.validators.MinValueValidator(1), django.core.validators.MaxValueValidator(5)]),
        ),
    ]
