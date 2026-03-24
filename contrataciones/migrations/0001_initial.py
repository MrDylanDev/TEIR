

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models

class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('proyectos', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Contratacion',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fecha_inicio', models.DateField(blank=True, null=True)),
                ('fecha_fin_estimada', models.DateField(blank=True, null=True)),
                ('estado', models.CharField(choices=[('activa', 'Activa'), ('finalizada', 'Finalizada'), ('cancelada', 'Cancelada')], default='activa', max_length=10)),
                ('asignado_por', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to=settings.AUTH_USER_MODEL)),
                ('desarrollador', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='contrataciones_dev', to=settings.AUTH_USER_MODEL)),
                ('empresa', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='contrataciones_emp', to=settings.AUTH_USER_MODEL)),
                ('proyecto', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='proyectos.proyecto')),
            ],
        ),
    ]
