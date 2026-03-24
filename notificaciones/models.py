from django.db import models
from usuarios.models import Usuario

class Notificacion(models.Model):
    TIPO_CHOICES = [
        ('postulacion', 'Postulación'),
        ('avance', 'Avance'),
        ('aprobacion', 'Aprobación'),
        ('mensaje', 'Mensaje'),
        ('alerta', 'Alerta'),
        ('otro', 'Otro'),
    ]
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='mis_notificaciones')
    tipo = models.CharField(max_length=20, choices=TIPO_CHOICES, default='otro')
    mensaje = models.TextField()
    leida = models.BooleanField(default=False) # Sincronizado con MySQL 'leida'
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notificaciones'
        verbose_name_plural = "Notificaciones"


    def __str__(self):
        return f"{self.tipo} - {self.usuario.username}"
