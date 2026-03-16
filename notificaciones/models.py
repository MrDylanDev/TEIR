from django.db import models
from usuarios.models import Usuario

class Notificacion(models.Model):
    TIPO = [
        ('postulacion', 'Postulación'),
        ('avance', 'Avance'),
        ('aprobacion', 'Aprobación'),
        ('mensaje', 'Mensaje'),
        ('alerta', 'Alerta'),
        ('otro', 'Otro'),
    ]
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    tipo = models.CharField(max_length=20, choices=TIPO, default='otro')
    mensaje = models.TextField()
    leida = models.BooleanField(default=False)
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notificaciones'

    def __str__(self):
        return f"{self.tipo} - {self.usuario.username}"
