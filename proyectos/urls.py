from django.urls import path
from . import views

urlpatterns = [
    path('', views.listar_proyectos, name='listar_proyectos'),
    path('crear/', views.crear_proyecto, name='crear_proyecto'),
    path('desactivar/<int:proyecto_id>/', views.desactivar_proyecto, name='desactivar_proyecto'),
    path('finalizar/<int:proyecto_id>/', views.finalizar_proyecto, name='finalizar_proyecto'),
    path('calificar-empresa/<int:proyecto_id>/', views.calificar_empresa, name='calificar_empresa'),
]
