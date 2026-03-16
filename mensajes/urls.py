from django.urls import path
from . import views

urlpatterns = [
    path('inbox/', views.mensajeria_inbox, name='mensajeria_inbox'),
    path('enviados/', views.mensajeria_sent, name='mensajeria_sent'),
    path('ver/<int:mensaje_id>/', views.ver_mensaje, name='ver_mensaje'),
    path('redactar/', views.enviar_mensaje, name='enviar_mensaje'),
]
