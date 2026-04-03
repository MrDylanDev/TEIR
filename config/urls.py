from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    # Módulos de Aplicación (Modularizados)
    path('', include('usuarios.urls')), 
    path('proyectos/', include('proyectos.urls')),
    path('postulaciones/', include('postulaciones.urls')),
    path('contrataciones/', include('contrataciones.urls')),
    path('avances/', include('avances.urls')),
    path('mensajes/', include('mensajes.urls')),
    path('notificaciones/', include('notificaciones.urls')),
    path('logs/', include('logs.urls')),
    path('favoritos/', include('favoritos.urls')),
    
    # Admin de Django
    path('admin/', admin.site.urls),
]

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
