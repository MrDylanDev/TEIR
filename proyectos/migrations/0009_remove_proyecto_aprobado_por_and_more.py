
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('proyectos', '0008_alter_entregable_estado_equipo_entregable_equipo'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.RemoveField(
            model_name='proyecto',
            name='aprobado_por',
        ),
        migrations.RemoveField(
            model_name='proyecto',
            name='fecha_aprobacion',
        ),
        migrations.AddIndex(
            model_name='entregable',
            index=models.Index(fields=['estado'], name='idx_entregables_estado'),
        ),
        migrations.AddIndex(
            model_name='entregable',
            index=models.Index(fields=['fecha_creacion'], name='idx_entregables_fecha'),
        ),
        migrations.AddIndex(
            model_name='proyecto',
            index=models.Index(fields=['estado'], name='idx_estado'),
        ),
        migrations.AddIndex(
            model_name='proyecto',
            index=models.Index(fields=['tipo_solucion'], name='idx_proy_tipo'),
        ),
        migrations.AddIndex(
            model_name='proyecto',
            index=models.Index(fields=['prioridad'], name='idx_proy_prio'),
        ),
        migrations.AddIndex(
            model_name='proyecto',
            index=models.Index(fields=['fecha_publicacion'], name='idx_fecha_publicacion'),
        ),
    ]
