
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('contrataciones', '0004_alter_contratacion_table'),
        ('proyectos', '0009_remove_proyecto_aprobado_por_and_more'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterField(
            model_name='contratacion',
            name='estado',
            field=models.CharField(choices=[('activa', 'Activa'), ('finalizada', 'Finalizada'), ('cancelada', 'Cancelada')], default='activa', max_length=25),
        ),
        migrations.AlterField(
            model_name='contratacion',
            name='fecha_inicio',
            field=models.DateField(auto_now_add=True, null=True),
        ),
        migrations.AddIndex(
            model_name='contratacion',
            index=models.Index(fields=['proyecto', 'desarrollador', 'estado'], name='idx_proy_dev_est'),
        ),
        migrations.AddIndex(
            model_name='contratacion',
            index=models.Index(fields=['empresa'], name='idx_empresa_contratos'),
        ),
    ]
