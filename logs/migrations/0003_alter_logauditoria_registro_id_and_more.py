

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('logs', '0002_alter_copiaseguridad_table_alter_logauditoria_table'),
    ]

    operations = [
        migrations.AlterField(
            model_name='logauditoria',
            name='registro_id',
            field=models.BigIntegerField(blank=True, null=True),
        ),
        migrations.AlterModelTable(
            name='copiaseguridad',
            table='copias_seguridad',
        ),
        migrations.AlterModelTable(
            name='logauditoria',
            table='logs_auditoria',
        ),
    ]
