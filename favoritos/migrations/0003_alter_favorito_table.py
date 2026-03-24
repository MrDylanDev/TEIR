

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('favoritos', '0002_alter_favorito_table'),
    ]

    operations = [
        migrations.AlterModelTable(
            name='favorito',
            table='favoritos',
        ),
    ]
