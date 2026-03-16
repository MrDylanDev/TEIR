import csv
from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from proyectos.models import Proyecto
from usuarios.models import Usuario, PerfilDesarrollador

@login_required
def reporte_proyectos_csv(request):
    """Generar reporte de todos los proyectos en CSV (Excel)"""
    if request.user.rol != 'administrador':
        return redirect('inicio')

    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="reporte_proyectos_tem.csv"'

    writer = csv.writer(response)
    writer.writerow(['Título', 'Empresa', 'Tipo', 'Prioridad', 'Estado', 'Fecha Publicación'])

    proyectos = Proyecto.objects.all().order_by('-fecha_publicacion')
    for p in proyectos:
        writer.writerow([
            p.titulo, 
            p.empresa.username, 
            p.get_tipo_solucion_display(), 
            p.get_prioridad_display(), 
            p.get_estado_display(), 
            p.fecha_publicacion.strftime('%d/%m/%Y %H:%M')
        ])

    return response

@login_required
def reporte_aprendices_csv(request):
    """Generar reporte de desempeño de aprendices en CSV (Excel)"""
    if request.user.rol != 'administrador':
        return redirect('inicio')

    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="reporte_desempeno_aprendices.csv"'

    writer = csv.writer(response)
    writer.writerow(['Usuario', 'Cédula', 'Programa', 'Ficha', 'Proyectos Completados', 'Calificación Promedio'])

    aprendices = PerfilDesarrollador.objects.all().select_related('usuario')
    for a in aprendices:
        writer.writerow([
            a.usuario.username,
            a.usuario.cedula or 'N/A',
            a.programa_formacion or 'N/A',
            a.ficha or 'N/A',
            a.num_proyectos_completados,
            a.calificacion_promedio
        ])

    return response

@login_required
def reporte_vista_impresion(request):
    """Vista HTML diseñada para ser impresa como PDF (Reporte General)"""
    if request.user.rol != 'administrador':
        return redirect('inicio')
    
    context = {
        'proyectos': Proyecto.objects.all().order_by('-fecha_publicacion'),
        'aprendices': PerfilDesarrollador.objects.all().order_by('-calificacion_promedio'),
        'total_usuarios': Usuario.objects.count(),
        'total_proyectos': Proyecto.objects.count(),
    }
    return render(request, 'logs/reporte_impresion.html', context)
