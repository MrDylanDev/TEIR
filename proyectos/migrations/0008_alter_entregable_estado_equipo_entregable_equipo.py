
import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('proyectos', '0007_alter_historialestadoproyecto_estado_anterior_and_more'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AlterField(
            model_name='entregable',
            name='estado',
            field=models.CharField(choices=[('pendiente', 'Pendiente'), ('en_revision', 'En Revisión'), ('completado', 'Completado')], default='pendiente', max_length=20),
        ),
        migrations.CreateModel(
            name='Equipo',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('nombre', models.CharField(max_length=100)),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('miembros', models.ManyToManyField(related_name='mis_equipos', to=settings.AUTH_USER_MODEL)),
                ('proyecto', models.ForeignKey(db_column='proyecto_id', on_delete=django.db.models.deletion.CASCADE, related_name='equipos', to='proyectos.proyecto')),
            ],
            options={
                'db_table': 'equipos',
            },
        ),
        migrations.AddField(
            model_name='entregable',
            name='equipo',
            field=models.ForeignKey(blank=True, db_column='equipo_id', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='hitos', to='proyectos.equipo'),
        ),
    ]
