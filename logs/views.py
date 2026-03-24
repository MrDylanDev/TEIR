import csv
from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.db.models import Avg
from proyectos.models import Proyecto, Valoracion
from usuarios.models import Usuario, PerfilDesarrollador, PerfilEmpresa

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
    """Generar reporte de desempeño de aprendices en CSV"""
    if request.user.rol != 'administrador':
        return redirect('inicio')

    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="reporte_aprendices_tem.csv"'

    writer = csv.writer(response)
    writer.writerow(['Usuario', 'Nombre', 'Programa', 'Ficha', 'Promedio', 'Proyectos'])

    aprendices = PerfilDesarrollador.objects.select_related('usuario').all()
    for a in aprendices:
        writer.writerow([
            a.usuario.username,
            a.usuario.nombre,
            a.programa_formacion or '-',
            a.ficha or '-',
            a.calificacion_promedio,
            a.num_proyectos_completados
        ])
    return response

@login_required
def reporte_vista_impresion(request):
    """Vista optimizada para imprimir reportes generales"""
    if request.user.rol != 'administrador':
        return redirect('inicio')
    
    context = {
        'proyectos': Proyecto.objects.all().order_by('-fecha_publicacion'),
        'aprendices': PerfilDesarrollador.objects.all().order_by('-calificacion_promedio'),
        'total_usuarios': Usuario.objects.count(),
        'total_proyectos': Proyecto.objects.count(),
    }
    return render(request, 'logs/reporte_impresion.html', context)

@login_required
def reporte_empresas_csv(request):
    """Generar reporte de todas las empresas en CSV (Excel)"""
    if request.user.rol != 'administrador':
        return redirect('inicio')
        
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="reporte_empresas_tem.csv"'
    
    writer = csv.writer(response)
    writer.writerow(['Empresa', 'NIT', 'Sector', 'Ciudad', 'Telefono', 'Email', 'Proyectos Publicados', 'Reputación (★)'])
    
    empresas = PerfilEmpresa.objects.select_related('usuario').all()
    for e in empresas:
        proyectos_count = Proyecto.objects.filter(empresa=e.usuario).count()
        # Calcular promedio de reputación recibida de desarrolladores
        promedio = Valoracion.objects.filter(empresa=e.usuario, rol_evaluador='desarrollador').aggregate(Avg('puntuacion'))['puntuacion__avg'] or 0
        
        writer.writerow([
            e.nombre_empresa or e.usuario.username,
            e.nit or '-',
            e.sector or '-',
            e.ciudad or '-',
            e.telefono or '-',
            e.usuario.email,
            proyectos_count,
            round(promedio, 2)
        ])
        
    return response
