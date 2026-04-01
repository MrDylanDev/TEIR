from django.db import models
from usuarios.models import Usuario
from proyectos.models import Proyecto

class Mensaje(models.Model):
    remitente = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='mensajes_enviados')
    receptor = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='mensajes_recibidos', null=True, blank=True)
    proyecto = models.ForeignKey(Proyecto, null=True, blank=True, on_delete=models.SET_NULL)
    titulo = models.CharField(max_length=200, blank=True, null=True)
    contenido = models.TextField()
    leido = models.BooleanField(default=False)
    fecha_envio = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'mensajes'

    def __str__(self):
        receptor_name = self.receptor.username if self.receptor else "GRUPO"
        return f"De: {self.remitente.username} Para: {receptor_name}"
