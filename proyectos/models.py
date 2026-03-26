from django.db import models
from usuarios.models import Usuario

class Proyecto(models.Model):
    TIPO_SOLUCION = [
        ('sitio_web', 'Sitio Web'),
        ('aplicacion_movil', 'Aplicación Móvil'),
        ('automatizacion', 'Automatización'),
        ('sistema_escritorio', 'Sistema de Escritorio'),
        ('otro', 'Otro'),
    ]
    PRIORIDAD = [
        ('alta', 'Alta'),
        ('media', 'Media'),
        ('baja', 'Baja'),
    ]
    ESTADO = [
        ('pendiente_aprobacion', 'Pendiente de Aprobación'),
        ('publicado', 'Publicado'),
        ('en_desarrollo', 'En Desarrollo'),
        ('en_revision', 'En Revisión'),
        ('finalizado', 'Finalizado'),
        ('rechazado', 'Rechazado'),
        ('inactivo', 'Inactivo'),
    ]

    empresa = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='proyectos_empresa')
    titulo = models.CharField(max_length=200)
    descripcion = models.TextField()
    tipo_solucion = models.CharField(max_length=30, choices=TIPO_SOLUCION)
    prioridad = models.CharField(max_length=10, choices=PRIORIDAD, default='media')
    vacantes = models.PositiveIntegerField(default=1)
    estado = models.CharField(max_length=25, choices=ESTADO, default='publicado')
    fecha_publicacion = models.DateTimeField(auto_now_add=True)
    fecha_limite = models.DateField(null=True, blank=True)
    aprobado_por = models.ForeignKey(Usuario, null=True, blank=True, on_delete=models.SET_NULL, related_name='proyectos_aprobados')
    fecha_aprobacion = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.titulo} ({self.get_estado_display()})"

    class Meta:
        db_table = 'proyectos'

class Valoracion(models.Model):
    ROL_EVALUADOR = [
        ('empresa', 'Empresa'),
        ('desarrollador', 'Desarrollador'),
    ]
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE, related_name='valoraciones', db_column='proyecto_id')
    empresa = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='valoraciones_como_empresa', db_column='empresa_id')
    desarrollador = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='valoraciones_como_dev', db_column='desarrollador_id')
    rol_evaluador = models.CharField(max_length=20, choices=ROL_EVALUADOR, default='empresa')
    puntuacion = models.PositiveSmallIntegerField()
    comentario = models.TextField(blank=True, null=True)
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'valoraciones'
        unique_together = ('proyecto', 'rol_evaluador')
        verbose_name_plural = "Valoraciones"

class HistorialEstadoProyecto(models.Model):
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE, related_name='historial_estados', db_column='proyecto_id')
    estado_anterior = models.CharField(max_length=50)
    estado_nuevo = models.CharField(max_length=50)
    cambiado_por = models.ForeignKey(Usuario, on_delete=models.SET_NULL, null=True, db_column='cambiado_por')
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'historial_estado_proyecto'
        verbose_name_plural = "Historiales de Estados"
