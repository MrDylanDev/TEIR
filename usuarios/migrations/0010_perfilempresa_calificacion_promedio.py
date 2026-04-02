
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0009_remove_perfilempresa_nit'),
    ]

    operations = [
        migrations.AddField(
            model_name='perfilempresa',
            name='calificacion_promedio',
            field=models.DecimalField(decimal_places=2, default=0.0, max_digits=3),
        ),
    ]
