
import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('proyectos', '0006_alter_valoracion_unique_together'),
    ]

    operations = [
        migrations.AlterField(
            model_name='historialestadoproyecto',
            name='estado_anterior',
            field=models.CharField(blank=True, max_length=50, null=True),
        ),
        migrations.CreateModel(
            name='Entregable',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('titulo', models.CharField(max_length=200)),
                ('descripcion', models.TextField(blank=True, null=True)),
                ('estado', models.CharField(choices=[('pendiente', 'Pendiente'), ('completado', 'Completado')], default='pendiente', max_length=20)),
                ('fecha_creacion', models.DateTimeField(auto_now_add=True)),
                ('proyecto', models.ForeignKey(db_column='proyecto_id', on_delete=django.db.models.deletion.CASCADE, related_name='entregables', to='proyectos.proyecto')),
            ],
            options={
                'db_table': 'entregables',
            },
        ),
    ]
