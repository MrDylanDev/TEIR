from django.db import models
from usuarios.models import Usuario
from proyectos.models import Proyecto

class Contratacion(models.Model):
    ESTADO = [
        ('activa', 'Activa'),
        ('finalizada', 'Finalizada'),
        ('cancelada', 'Cancelada'),
    ]
    proyecto = models.ForeignKey(Proyecto, on_delete=models.CASCADE, related_name='contrataciones')
    desarrollador = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='contrataciones_dev')
    empresa = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='contrataciones_emp')
    asignado_por = models.ForeignKey(Usuario, null=True, blank=True, on_delete=models.SET_NULL)
    fecha_inicio = models.DateField(null=True, blank=True)
    fecha_fin_estimada = models.DateField(null=True, blank=True)
    estado = models.CharField(max_length=10, choices=ESTADO, default='activa')

    def __str__(self):
        return f"Contrato: {self.proyecto.titulo}"
