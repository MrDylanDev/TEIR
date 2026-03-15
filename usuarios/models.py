from django.db import models
from django.contrib.auth.models import AbstractUser

class Usuario(AbstractUser):
    cedula = models.CharField(max_length=20, unique=True, null=True, blank=True)
    rol = models.CharField(
        max_length=20,
        choices=[
            ('empresa', 'Empresa'),
            ('desarrollador', 'Desarrollador'),
            ('administrador', 'Administrador'),
        ],
        default='desarrollador'
    )
    estado = models.CharField(
        max_length=20,
        choices=[
            ('activo', 'Activo'),
            ('inactivo', 'Inactivo'),
            ('suspendido', 'Suspendido'),
        ],
        default='activo'
    )
    fecha_registro = models.DateTimeField(auto_now_add=True)
    ultimo_acceso = models.DateTimeField(null=True, blank=True)
    token_recuperacion = models.CharField(max_length=255, null=True, blank=True)
    token_expiracion = models.DateTimeField(null=True, blank=True)
    intentos_fallidos = models.PositiveSmallIntegerField(default=0)
    bloqueado_hasta = models.DateTimeField(null=True, blank=True)

    groups = models.ManyToManyField(
        'auth.Group',
        related_name='usuarios_groups',
        blank=True,
        help_text='The groups this user belongs to.'
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        related_name='usuarios_permissions',
        blank=True,
        help_text='Specific permissions for this user.'
    )

    def __str__(self):
        return f"{self.username} - {self.rol}"

class PerfilEmpresa(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE, primary_key=True)
    nombre_empresa = models.CharField(max_length=200, blank=True, null=True)
    nit = models.CharField(max_length=30, blank=True, null=True)
    sector = models.CharField(max_length=100, blank=True, null=True)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    descripcion = models.TextField(blank=True, null=True)
    ciudad = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.nombre_empresa or f"Empresa {self.usuario.username}"

class PerfilDesarrollador(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE, primary_key=True)
    programa_formacion = models.CharField(max_length=200, blank=True, null=True)
    ficha = models.CharField(max_length=50, blank=True, null=True)
    habilidades = models.TextField(blank=True, null=True)
    calificacion_promedio = models.DecimalField(max_digits=3, decimal_places=2, default=0.00)
    num_proyectos_completados = models.IntegerField(default=0)

    def __str__(self):
        return f"Desarrollador {self.usuario.username}"