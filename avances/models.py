from django.db import models
from usuarios.models import Usuario
from proyectos.models import Proyecto

class Avance(models.Model):
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE)
    desarrollador = models.ForeignKey(Usuario, on_delete=models.CASCADE, limit_choices_to={'rol': 'desarrollador'})
    descripcion = models.TextField()
    archivo_url = models.URLField(max_length=500, blank=True, null=True)
    porcentaje = models.PositiveSmallIntegerField(default=0)
    fecha_hora = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'avances'

    def __str__(self):
        return f"Avance {self.porcentaje}% - {self.proyecto.titulo}"

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
