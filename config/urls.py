from django.contrib import admin
from django.urls import path
from usuarios import views

urlpatterns = [
    # ===== RUTAS PERSONALIZADAS (DASHBOARDS) =====
    path('admin/dashboard/', views.dashboard_admin, name='dashboard_admin'),
    path('empresa/dashboard/', views.dashboard_empresa, name='dashboard_empresa'),
    path('desarrollador/dashboard/', views.dashboard_desarrollador, name='dashboard_desarrollador'),
    
    # ===== API PARA EL CRUD =====
    path('api/usuarios/', views.api_usuarios, name='api_usuarios'),
    path('api/usuarios/<int:usuario_id>/', views.api_usuario_detalle, name='api_usuario_detalle'),
    path('api/usuarios/crear/', views.api_crear_usuario, name='api_crear_usuario'),
    path('api/usuarios/<int:usuario_id>/actualizar/', views.api_actualizar_usuario, name='api_actualizar_usuario'),
    path('api/usuarios/<int:usuario_id>/eliminar/', views.api_eliminar_usuario, name='api_eliminar_usuario'),
    
    # ===== PANEL DE ADMINISTRACIÓN DE DJANGO =====
    path('admin/', admin.site.urls),
    
    # ===== RUTAS PÚBLICAS =====
    path('', views.inicio, name='inicio'),
    path('login/', views.login_view, name='login'),
    path('registro/', views.registro_view, name='registro'),
    path('recuperar/', views.recuperar_view, name='recuperar'),
]