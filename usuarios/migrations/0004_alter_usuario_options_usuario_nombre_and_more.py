

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('usuarios', '0003_alter_usuario_options_usuario_nombre_and_more'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='usuario',
            options={},
        ),
        migrations.AddField(
            model_name='usuario',
            name='nombre',
            field=models.CharField(default='', max_length=150),
            preserve_default=False,
        ),
        migrations.AlterField(
            model_name='usuario',
            name='email',
            field=models.EmailField(max_length=150, unique=True),
        ),
        migrations.AlterModelTable(
            name='perfildesarrollador',
            table='perfil_desarrollador',
        ),
        migrations.AlterModelTable(
            name='perfilempresa',
            table='perfil_empresa',
        ),
        migrations.AlterModelTable(
            name='usuario',
            table='usuarios',
        ),
    ]
