from django.urls import path
from . import views

urlpatterns = [
    path('mis-contratados/', views.listar_contrataciones_empresa, name='listar_contrataciones_empresa'),
    path('detalle/<int:contratacion_id>/', views.ver_detalle_contrato, name='ver_detalle_contrato'),
    path('cancelar/<int:contratacion_id>/', views.cancelar_contratacion, name='cancelar_contratacion'),
]
