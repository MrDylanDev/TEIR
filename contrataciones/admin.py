from django.contrib import admin
from .models import Contratacion


@admin.register(Contratacion)
class ContratacionAdmin(admin.ModelAdmin):
    list_display = ('id', 'proyecto', 'empresa', 'desarrollador', 'estado', 'fecha_inicio')
    list_filter = ('estado', 'fecha_inicio')
    search_fields = ('proyecto__titulo', 'empresa__username', 'desarrollador__username')
