
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('mensajes', '0004_alter_mensaje_receptor'),
    ]

    operations = [
        migrations.RenameField(
            model_name='mensaje',
            old_name='cuerpo',
            new_name='contenido',
        ),
        migrations.RenameField(
            model_name='mensaje',
            old_name='asunto',
            new_name='titulo',
        ),
        migrations.RemoveField(
            model_name='mensaje',
            name='archivado',
        ),
    ]
