from django.urls import path
from . import views

urlpatterns = [
    path('chat/<int:receptor_id>/<int:proyecto_id>/', views.sala_chat, name='sala_chat'),
    path('chat/<int:receptor_id>/', views.sala_chat, name='sala_chat_general'),
]
