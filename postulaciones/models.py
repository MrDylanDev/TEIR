from django.db import models
from usuarios.models import Usuario
from proyectos.models import Proyecto

class Postulacion(models.Model):
    ESTADO = [
        ('pendiente', 'Pendiente'),
        ('aceptada', 'Aceptada'),
        ('rechazada', 'Rechazada'),
    ]
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE)
    desarrollador = models.ForeignKey(Usuario, on_delete=models.CASCADE, limit_choices_to={'rol': 'desarrollador'})
    mensaje = models.TextField(blank=True, null=True)
    estado = models.CharField(max_length=10, choices=ESTADO, default='pendiente')
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('proyecto', 'desarrollador')

    def __str__(self):
        return f"{self.desarrollador.username} - {self.proyecto.titulo}"

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
