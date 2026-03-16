from django.urls import path
from . import views

urlpatterns = [
    path('', views.listar_proyectos, name='listar_proyectos'),
    path('crear/', views.crear_proyecto, name='crear_proyecto'),
    path('validar/', views.validar_proyectos_admin, name='validar_proyectos_admin'),
    path('aprobar/<int:proyecto_id>/', views.aprobar_proyecto, name='aprobar_proyecto'),
    path('rechazar/<int:proyecto_id>/', views.rechazar_proyecto, name='rechazar_proyecto'),
    path('desactivar/<int:proyecto_id>/', views.desactivar_proyecto, name='desactivar_proyecto'),
    path('finalizar/<int:proyecto_id>/', views.finalizar_proyecto, name='finalizar_proyecto'),
]
