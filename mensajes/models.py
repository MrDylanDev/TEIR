from django.db import models
from usuarios.models import Usuario
from proyectos.models import Proyecto

class Mensaje(models.Model):
    remitente = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='mensajes_enviados')
    receptor = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='mensajes_recibidos')
    proyecto = models.ForeignKey(Proyecto, null=True, blank=True, on_delete=models.CASCADE)
    asunto = models.CharField(max_length=200, blank=True, null=True)
    cuerpo = models.TextField()
    leido = models.BooleanField(default=False)
    archivado = models.BooleanField(default=False)
    fecha_envio = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"De: {self.remitente.username} Para: {self.receptor.username}"