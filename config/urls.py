from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from usuarios import views

urlpatterns = [
    # ===== DASHBOARDS =====
    path('admin/dashboard/', views.dashboard_admin, name='dashboard_admin'),
    path('empresa/dashboard/', views.dashboard_empresa, name='dashboard_empresa'),
    path('desarrollador/dashboard/', views.dashboard_desarrollador, name='dashboard_desarrollador'),
    path('perfil/editar/', views.editar_perfil, name='editar_perfil'),
    
    # ===== APLICACIONES =====
    path('proyectos/', include('proyectos.urls')),
    path('postulaciones/', include('postulaciones.urls')),
    path('avances/', include('avances.urls')),
    path('mensajes/', include('mensajes.urls')),
    path('logs/', include('logs.urls')),
    path('favoritos/', include('favoritos.urls')),
    
    # ===== API =====
    path('api/usuarios/', views.api_usuarios, name='api_usuarios'),
    path('api/usuarios/<int:usuario_id>/', views.api_usuario_detalle, name='api_usuario_detalle'),
    path('api/usuarios/crear/', views.api_crear_usuario, name='api_crear_usuario'),
    path('api/usuarios/<int:usuario_id>/actualizar/', views.api_actualizar_usuario, name='api_actualizar_usuario'),
    path('api/usuarios/<int:usuario_id>/eliminar/', views.api_eliminar_usuario, name='api_eliminar_usuario'),
    
    # ===== ADMIN DJANGO =====
    path('admin/', admin.site.urls),
    
    # ===== PÚBLICO =====
    path('', views.inicio, name='inicio'),
    path('login/', views.login_view, name='login'),
    path('logout/', views.logout_view, name='logout'),
    path('registro/', views.registro_view, name='registro'),
    path('recuperar/', views.recuperar_view, name='recuperar'),
]

# Servir archivos estáticos y media en desarrollo
if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
