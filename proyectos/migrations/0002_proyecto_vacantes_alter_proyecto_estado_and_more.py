

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models

class Migration(migrations.Migration):

    dependencies = [
        ('proyectos', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='proyecto',
            name='vacantes',
            field=models.PositiveIntegerField(default=1),
        ),
        migrations.AlterField(
            model_name='proyecto',
            name='estado',
            field=models.CharField(choices=[('pendiente_aprobacion', 'Pendiente de Aprobación'), ('publicado', 'Publicado'), ('en_desarrollo', 'En Desarrollo'), ('en_revision', 'En Revisión'), ('finalizado', 'Finalizado'), ('rechazado', 'Rechazado'), ('inactivo', 'Inactivo')], default='publicado', max_length=25),
        ),
        migrations.CreateModel(
            name='HistorialEstadoProyecto',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('estado_anterior', models.CharField(max_length=50)),
                ('estado_nuevo', models.CharField(max_length=50)),
                ('fecha', models.DateTimeField(auto_now_add=True)),
                ('cambiado_por', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
                ('proyecto', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='historial_estados', to='proyectos.proyecto')),
            ],
            options={
                'verbose_name_plural': 'Historiales de Estados',
            },
        ),
        migrations.CreateModel(
            name='Valoracion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('puntuacion', models.PositiveSmallIntegerField()),
                ('comentario', models.TextField(blank=True, null=True)),
                ('fecha', models.DateTimeField(auto_now_add=True)),
                ('desarrollador', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='valoraciones_recibidas', to=settings.AUTH_USER_MODEL)),
                ('empresa', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='valoraciones_realizadas', to=settings.AUTH_USER_MODEL)),
                ('proyecto', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='valoracion', to='proyectos.proyecto')),
            ],
            options={
                'verbose_name_plural': 'Valoraciones',
            },
        ),
    ]
