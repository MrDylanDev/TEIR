
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('postulaciones', '0003_alter_postulacion_table'),
    ]

    operations = [
        migrations.AlterField(
            model_name='postulacion',
            name='estado',
            field=models.CharField(choices=[('pendiente', 'Pendiente'), ('aceptada', 'Aceptada'), ('rechazada', 'Rechazada')], default='pendiente', max_length=25),
        ),
    ]
