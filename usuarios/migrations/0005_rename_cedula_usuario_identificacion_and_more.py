
import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0004_alter_usuario_options_usuario_nombre_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='usuario',
            old_name='cedula',
            new_name='identificacion',
        ),
        migrations.AddField(
            model_name='perfildesarrollador',
            name='id',
            field=models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID'),
        ),
        migrations.AddField(
            model_name='perfilempresa',
            name='id',
            field=models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID'),
        ),
        migrations.AlterField(
            model_name='perfildesarrollador',
            name='usuario',
            field=models.OneToOneField(db_column='usuario_id', on_delete=django.db.models.deletion.CASCADE, related_name='perfil_desarrollador', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='perfilempresa',
            name='usuario',
            field=models.OneToOneField(db_column='usuario_id', on_delete=django.db.models.deletion.CASCADE, related_name='perfil_empresa', to=settings.AUTH_USER_MODEL),
        ),
    ]
