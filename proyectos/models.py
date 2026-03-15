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
    estado = models.CharField(max_length=25, choices=ESTADO, default='pendiente_aprobacion')
    fecha_publicacion = models.DateTimeField(auto_now_add=True)
    fecha_limite = models.DateField(null=True, blank=True)
    aprobado_por = models.ForeignKey(Usuario, null=True, blank=True, on_delete=models.SET_NULL, related_name='proyectos_aprobados')
    fecha_aprobacion = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.titulo