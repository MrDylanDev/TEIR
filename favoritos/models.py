from django.db import models
from usuarios.models import Usuario
from proyectos.models import Proyecto

class Favorito(models.Model):
    desarrollador = models.ForeignKey(Usuario, on_delete=models.CASCADE, limit_choices_to={'rol': 'desarrollador'})
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE)
    fecha = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('desarrollador', 'proyecto')

    def __str__(self):
        return f"{self.desarrollador.username} -> {self.proyecto.titulo}"
