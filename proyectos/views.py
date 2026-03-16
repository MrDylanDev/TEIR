from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction
from django.db.models import Avg
from .models import Proyecto, Valoracion
from usuarios.models import Usuario, PerfilDesarrollador
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from favoritos.models import Favorito

@login_required
def listar_proyectos(request):
    """CU 3: Consultar proyectos disponibles (para Desarrolladores)"""
    # Solo proyectos publicados
    proyectos = Proyecto.objects.filter(estado='publicado').order_by('-fecha_publicacion')
    
    # Aplicar filtros (RN 36)
    tipo = request.GET.get('tipo')
    prioridad = request.GET.get('prioridad')
    if tipo:
        proyectos = proyectos.filter(tipo_solucion=tipo)
    if prioridad:
        proyectos = proyectos.filter(prioridad=prioridad)
    
    # Identificar cuáles son favoritos del usuario actual
    favoritos_ids = []
    if request.user.rol == 'desarrollador':
        favoritos_ids = Favorito.objects.filter(desarrollador=request.user).values_list('proyecto_id', flat=True)
        
    return render(request, 'proyectos/listar.html', {
        'proyectos': proyectos,
        'favoritos_ids': favoritos_ids
    })

@login_required
def crear_proyecto(request):
    """CU 3: Publicar una necesidad tecnológica (para Empresas)"""
    if request.user.rol != 'empresa':
        messages.error(request, "Solo las empresas pueden publicar proyectos.")
        return redirect('dashboard_empresa')

    if request.method == 'POST':
        try:
            proyecto = Proyecto(
                empresa=request.user,
                titulo=request.POST.get('titulo'),
                descripcion=request.POST.get('descripcion'),
                tipo_solucion=request.POST.get('tipo_solucion'),
                prioridad=request.POST.get('prioridad', 'media'),
                vacantes=int(request.POST.get('vacantes', 1)),
                fecha_limite=request.POST.get('fecha_limite') or None
            )
            proyecto.save()
            messages.success(request, "Proyecto enviado a revisión exitosamente.")
            return redirect('dashboard_empresa')
        except Exception as e:
            messages.error(request, f"Error: {e}")
            
    return render(request, 'proyectos/crear.html')

@login_required
def validar_proyectos_admin(request):
    """CU 3 Admin: Validar proyectos publicados"""
    if request.user.rol != 'administrador':
        return redirect('inicio')
        
    pendientes = Proyecto.objects.filter(estado='pendiente_aprobacion')
    return render(request, 'proyectos/validar_admin.html', {'proyectos': pendientes})

@login_required
def aprobar_proyecto(request, proyecto_id):
    if request.user.rol != 'administrador':
        return redirect('inicio')
        
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    proyecto.estado = 'publicado'
    proyecto.aprobado_por = request.user
    from django.utils import timezone
    proyecto.fecha_aprobacion = timezone.now()
    proyecto.save()
    messages.success(request, f"Proyecto '{proyecto.titulo}' aprobado y publicado.")
    return redirect('dashboard_admin')

@login_required
def rechazar_proyecto(request, proyecto_id):
    if request.user.rol != 'administrador':
        return redirect('inicio')
        
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    proyecto.estado = 'rechazado'
    proyecto.save()
    messages.warning(request, f"Proyecto '{proyecto.titulo}' rechazado.")
    return redirect('dashboard_admin')

@login_required
def finalizar_proyecto(request, proyecto_id):
    """CU 6: Finalizar proyecto y valorar desarrollador (Empresa)"""
    if request.user.rol != 'empresa':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    
    # Solo se puede finalizar si está en desarrollo o en revisión
    if proyecto.estado not in ['en_desarrollo', 'en_revision']:
        messages.error(request, "Este proyecto no puede ser finalizado en su estado actual.")
        return redirect('dashboard_empresa')
    
    # Obtener el contrato activo para saber quién es el desarrollador
    contratacion = get_object_or_404(Contratacion, proyecto=proyecto, estado='activa')
    desarrollador = contratacion.desarrollador

    if request.method == 'POST':
        try:
            puntuacion = int(request.POST.get('puntuacion'))
            comentario = request.POST.get('comentario')
            
            with transaction.atomic():
                # 1. Crear valoración
                Valoracion.objects.create(
                    proyecto=proyecto,
                    empresa=request.user,
                    desarrollador=desarrollador,
                    puntuacion=puntuacion,
                    comentario=comentario
                )
                
                # 2. Actualizar estado del proyecto
                proyecto.estado = 'finalizado'
                proyecto.save()
                
                # 3. Finalizar contratación
                contratacion.estado = 'finalizada'
                contratacion.save()
                
                # 4. Actualizar estadísticas del desarrollador
                perfil_dev = PerfilDesarrollador.objects.get(usuario=desarrollador)
                # Recalcular promedio
                promedio = Valoracion.objects.filter(desarrollador=desarrollador).aggregate(Avg('puntuacion'))['puntuacion__avg']
                perfil_dev.calificacion_promedio = promedio
                perfil_dev.num_proyectos_completados += 1
                perfil_dev.save()
                
                # 5. Notificar al desarrollador
                Notificacion.objects.create(
                    usuario=desarrollador,
                    tipo='aprobacion',
                    mensaje=f"¡Felicidades! La empresa ha finalizado el proyecto '{proyecto.titulo}' y te ha calificado con {puntuacion} estrellas."
                )
                
            messages.success(request, f"Proyecto '{proyecto.titulo}' finalizado y desarrollador calificado.")
            return redirect('dashboard_empresa')
        except Exception as e:
            messages.error(request, f"Error al finalizar proyecto: {e}")

    return render(request, 'proyectos/finalizar.html', {'proyecto': proyecto, 'desarrollador': desarrollador})

@login_required
def desactivar_proyecto(request, proyecto_id):
    """Permitir que la empresa retire la oferta manualmente"""
    if request.user.rol != 'empresa':
        return redirect('inicio')
    
    proyecto = get_object_or_404(Proyecto, id=proyecto_id, empresa=request.user)
    if proyecto.estado == 'publicado':
        proyecto.estado = 'inactivo'
        proyecto.save()
        messages.info(request, f"El proyecto '{proyecto.titulo}' ha sido retirado del catálogo.")
    else:
        messages.error(request, "Solo se pueden retirar proyectos que estén en estado publicado.")
        
    return redirect('dashboard_empresa')
