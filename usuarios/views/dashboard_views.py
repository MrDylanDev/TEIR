from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from django.contrib import messages
from django.db import transaction, connection, IntegrityError
from django.db.models import Avg, Q, Count, Prefetch, OuterRef, Subquery, Value, FloatField, F, Max
from django.db.models.functions import Coalesce
from django.core.cache import cache
from django.http import JsonResponse
from django.utils import timezone
from datetime import timedelta
import json

from ..models import Usuario, PerfilEmpresa, PerfilDesarrollador
from ..decorators import requiere_usuario_activo
from ..utils import get_admin_id, get_admin_ids
from proyectos.models import Proyecto, Valoracion, Entregable, Equipo
from postulaciones.models import Postulacion
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from favoritos.models import Favorito
from mensajes.models import Mensaje
from logs.models import LogAuditoria

from ._helpers import get_notificaciones_context


def inicio(request):
    proyectos_qs = Proyecto.objects.filter(estado='finalizada').select_related(
        'empresa__perfil_empresa'
    ).prefetch_related(
        Prefetch('contrataciones',
            queryset=Contratacion.objects.filter(estado='finalizada').select_related('desarrollador'),
            to_attr='contratos_finalizados')
    ).annotate(
        calificacion=Coalesce(Avg('valoraciones__puntuacion',
            filter=Q(valoraciones__rol_evaluador='empresa')),
            Value(0.0), output_field=FloatField())
    ).order_by('-fecha_publicacion')[:4]

    casos_exito = []
    for p in proyectos_qs:
        dev_nombre = p.contratos_finalizados[0].desarrollador.nombre if p.contratos_finalizados else ''
        casos_exito.append({
            'titulo': p.titulo,
            'tipo_solucion': p.tipo_solucion,
            'empresa_nombre': p.empresa.nombre,
            'desarrollador_nombre': dev_nombre,
            'calificacion': round(p.calificacion, 1),
        })

    return render(request, 'publico/index.html', {'casos_exito': casos_exito})

@login_required
@requiere_usuario_activo
def dashboard_empresa(request):
    if request.user.rol != 'empresa': return redirect('inicio')
    
    p_pub = Proyecto.objects.filter(empresa=request.user, estado='publicado').count()
    p_act = Proyecto.objects.filter(empresa=request.user, estado='en_desarrollo').count()
    post_pen = Postulacion.objects.filter(proyecto__empresa=request.user, estado='pendiente', proyecto__estado='publicado').count()
    dev_con = Contratacion.objects.filter(empresa=request.user, estado='activa').count()

    en_desarrollo_qs = Proyecto.objects.filter(
        empresa=request.user, estado='en_desarrollo'
    ).annotate(
        hitos_completados=Count('entregables', filter=Q(entregables__estado='completado')),
        hitos_totales=Count('entregables'),
    ).prefetch_related(
        Prefetch('contrataciones',
            queryset=Contratacion.objects.filter(estado='activa').select_related('desarrollador'),
            to_attr='contratos_activos')
    )
    en_desarrollo_v = []
    for p in en_desarrollo_qs:
        dev_ids = [c.desarrollador_id for c in p.contratos_activos]
        dev_nombres = ', '.join([c.desarrollador.nombre for c in p.contratos_activos])
        en_desarrollo_v.append({
            'proyecto_id': p.id,
            'titulo': p.titulo,
            'desarrolladores': dev_nombres,
            'hitos_completados': p.hitos_completados,
            'hitos_totales': p.hitos_totales,
            'ultimo_avance': None,
            'fecha_fin': p.fecha_limite,
            'estado': p.estado,
            'ids': ','.join(map(str, dev_ids)),
            'primer_dev_id': dev_ids[0] if dev_ids else None,
            'num_desarrolladores': len(dev_ids),
        })
    perfil, _ = PerfilEmpresa.objects.get_or_create(usuario=request.user)
    mis_ofertas = Proyecto.objects.filter(empresa=request.user, estado='publicado').order_by('-fecha_publicacion')
    
    # FILTRO CORREGIDO: Solo mostrar postulaciones de proyectos que aún estén PUBLICADOS
    postulaciones_pendientes_obj = Postulacion.objects.filter(
        proyecto__empresa=request.user, 
        estado='pendiente',
        proyecto__estado='publicado'
    )
    
    # Sincronizamos el contador del dashboard con el filtro corregido
    post_pen = postulaciones_pendientes_obj.count()
    
    # Soporte Admin Dinámico (None si no existe ningún administrador)
    admin_id = get_admin_id()

    # Reputación Corporativa
    valoraciones_dev = Valoracion.objects.filter(empresa=request.user, rol_evaluador='desarrollador').select_related('desarrollador', 'proyecto')
    promedio_empresa = valoraciones_dev.aggregate(Avg('puntuacion'))['puntuacion__avg'] or 0

    # --- Notificaciones (Centralizado con Utility) ---
    notificaciones_recientes, notificaciones_pendientes_count = get_notificaciones_context(request.user.id)

    # Filtramos para que solo aparezcan si el contrato está activo Y el proyecto NO ha finalizado
    colaboradores_activos = Contratacion.objects.filter(
        empresa=request.user, 
        estado='activa',
        proyecto__estado='en_desarrollo'
    ).select_related('desarrollador__perfil_desarrollador', 'proyecto')

    # --- Historial detallado para Empresa (Optimizado con anotación) ---
    historial_v = Proyecto.objects.filter(
        empresa=request.user, 
        estado='finalizado'
    ).annotate(num_desarrolladores=Count('contrataciones')).prefetch_related('contrataciones__desarrollador').order_by('-fecha_publicacion')

    context = {
        'total_proyectos': p_pub,
        'proyectos_activos': p_act,
        'total_postulaciones': post_pen,
        'total_contratados': dev_con,
        'mis_ofertas': mis_ofertas,
        'en_desarrollo_v': en_desarrollo_v,
        'colaboradores_activos': colaboradores_activos,
        'historial': historial_v, # Ahora es un queryset optimizado
        'valoraciones_recibidas': valoraciones_dev,
        'promedio_empresa': round(promedio_empresa, 1),
        'postulaciones_pendientes': postulaciones_pendientes_obj,
        'notificaciones': notificaciones_recientes,
        'notificaciones_pendientes_count': notificaciones_pendientes_count,
        'perfil': perfil,
        'admin_id': admin_id
    }
    return render(request, 'empresa/empresa.html', context)

@login_required
@requiere_usuario_activo
def dashboard_desarrollador(request):
    if request.user.rol != 'desarrollador': return redirect('inicio')

    promedio = Valoracion.objects.filter(desarrollador=request.user, rol_evaluador='empresa').aggregate(Avg('puntuacion'))['puntuacion__avg'] or 0
    p_comp = Contratacion.objects.filter(desarrollador=request.user, estado='finalizada').count()
    p_act = Contratacion.objects.filter(desarrollador=request.user, estado='activa').count()
    p_fav = Favorito.objects.filter(desarrollador=request.user).count()

    # --- CONSULTAS DJANGO OPTIMIZADAS ---
    mis_postulaciones = Postulacion.objects.filter(desarrollador=request.user).select_related('proyecto')
    mis_proyectos_activos_q = Contratacion.objects.filter(desarrollador=request.user, estado='activa').select_related('proyecto', 'empresa')
    
    # HISTORIAL ROBUSTO: Cualquier contrato en un proyecto que ya esté FINALIZADO
    mis_proyectos_finalizados = Contratacion.objects.filter(
        Q(desarrollador=request.user) & 
        (Q(estado='finalizada') | Q(proyecto__estado='finalizado'))
    ).select_related('proyecto', 'empresa').annotate(
        num_desarrolladores=Count('proyecto__contrataciones')
    ).distinct()
    
    # IDs de proyectos donde el usuario YA TIENE acción (para excluir de favoritos)
    proyectos_con_accion = set(mis_postulaciones.values_list('proyecto_id', flat=True))
    proyectos_con_accion.update(mis_proyectos_activos_q.values_list('proyecto_id', flat=True))
    proyectos_con_accion.update(mis_proyectos_finalizados.values_list('proyecto_id', flat=True))

    # Favoritos: Solo proyectos PUBLICADOS y donde NO TENGA acción aún
    mis_favoritos = Favorito.objects.filter(
        desarrollador=request.user, 
        proyecto__estado='publicado'
    ).exclude(proyecto_id__in=proyectos_con_accion).select_related('proyecto')

    # Enriquecer los contratos finalizados con su valoración y CONTEO DE EQUIPO
    
    # Pre-cargamos las valoraciones que la empresa hizo al desarrollador en estos proyectos
    valoraciones_queryset = Valoracion.objects.filter(desarrollador=request.user, rol_evaluador='empresa')
    
    # Optimizamos mis_proyectos_finalizados para traer el conteo de desarrolladores y la valoración de una vez
    mis_proyectos_finalizados = mis_proyectos_finalizados.prefetch_related(
        Prefetch('proyecto__valoraciones', queryset=valoraciones_queryset, to_attr='valoracion_empresa')
    )

    for contrato in mis_proyectos_finalizados:
        # Asignar la valoración pre-cargada
        contrato.valoracion = contrato.proyecto.valoracion_empresa[0] if contrato.proyecto.valoracion_empresa else None

    mis_proyectos_qs = Proyecto.objects.filter(
        equipos__miembros=request.user, estado='en_desarrollo'
    ).select_related('empresa').annotate(
        hitos_completados=Count('entregables', filter=Q(entregables__estado='completado')),
        hitos_totales=Count('entregables'),
    ).prefetch_related(
        Prefetch('contrataciones',
            queryset=Contratacion.objects.filter(estado='activa').select_related('desarrollador'),
            to_attr='contratos_activos'),
    ).distinct()

    mis_proyectos_v = []
    proyectos_ids = list(mis_proyectos_qs.values_list('id', flat=True))

    if proyectos_ids:
        hitos_todos = Entregable.objects.filter(
            Q(proyecto_id__in=proyectos_ids) & 
            (Q(equipo__miembros=request.user) | Q(equipo__isnull=True))
        ).distinct().values('proyecto_id', 'titulo', 'estado', 'descripcion')

        hitos_por_proyecto = {}
        for h in hitos_todos:
            p_id = h['proyecto_id']
            if p_id not in hitos_por_proyecto:
                hitos_por_proyecto[p_id] = []
            hitos_por_proyecto[p_id].append(h)

        for p in mis_proyectos_qs:
            dev_ids = [c.desarrollador_id for c in p.contratos_activos]
            mis_proyectos_v.append({
                'proyecto_id': p.id,
                'titulo': p.titulo,
                'empresa_nombre': p.empresa.nombre,
                'hitos_completados': p.hitos_completados,
                'hitos_totales': p.hitos_totales,
                'ultimo_avance': None,
                'fecha_fin': p.fecha_limite,
                'estado': p.estado,
                'empresa_id': p.empresa_id,
                'num_desarrolladores': len(dev_ids),
                'hitos': hitos_por_proyecto.get(p.id, []),
            })
    # Soporte Admin Dinámico (None si no existe ningún administrador)
    admin_id = get_admin_id()

    # --- Notificaciones (Centralizado con Utility) ---
    notificaciones_recientes, notificaciones_pendientes_count = get_notificaciones_context(request.user.id)

    perfil, _ = PerfilDesarrollador.objects.get_or_create(usuario=request.user)
    context = {
        'proyectos_activos_count': p_act,
        'proyectos_completados': p_comp,
        'calificacion_promedio': round(float(promedio), 1) if promedio else 0,
        'favoritos_count': p_fav,
        'nuevos_proyectos': Proyecto.objects.filter(estado='publicado').count(),
        'notificaciones': notificaciones_recientes,
        'notificaciones_pendientes_count': notificaciones_pendientes_count,
        'mis_proyectos_activos_v': mis_proyectos_v,
        'mis_proyectos_finalizados': mis_proyectos_finalizados,
        'mis_postulaciones': mis_postulaciones,
        'favoritos': mis_favoritos,
        'perfil': perfil,
        'admin_id': admin_id
    }
    return render(request, 'Desarrollador/Desarrollador.html', context)

@login_required
@requiere_usuario_activo
def dashboard_admin(request):
    if request.user.rol != 'administrador': return redirect('inicio')
    
    user_stats = Usuario.objects.aggregate(
        total_empresas=Count('id', filter=Q(rol='empresa', is_active=True)),
        total_devs=Count('id', filter=Q(rol='desarrollador', is_active=True)),
    )
    proy_stats = Proyecto.objects.aggregate(
        p_pub=Count('id', filter=Q(estado='publicado')),
        p_des=Count('id', filter=Q(estado='en_desarrollo')),
        p_fin=Count('id', filter=Q(estado='finalizado')),
        p_pen=Count('id', filter=Q(estado='pendiente_aprobacion')),
    )
    post_pen = Postulacion.objects.filter(estado='pendiente').count()
    promedio_global = Valoracion.objects.aggregate(avg=Avg('puntuacion'))['avg'] or 0
    p_ret = Proyecto.objects.filter(
        estado='en_desarrollo', fecha_limite__lt=timezone.now()
    ).count()

    total_empresas = user_stats['total_empresas']
    total_devs = user_stats['total_devs']
    p_pub = proy_stats['p_pub']
    p_des = proy_stats['p_des']
    p_fin = proy_stats['p_fin']
    p_pen = proy_stats['p_pen']
    total_proyectos = p_pub + p_des + p_fin + p_pen
    total_usuarios = total_empresas + total_devs
    
    usuarios_lista = Usuario.objects.all().order_by('-date_joined')[:50]
    # Traemos proyectos con sus empresas y pre-cargamos sus contrataciones activas con los desarrolladores
    proyectos_lista = Proyecto.objects.all().select_related('empresa').prefetch_related(
        Prefetch(
            'contrataciones',
            queryset=Contratacion.objects.filter(estado='activa').select_related('desarrollador').annotate(
                hitos_completados=Count('proyecto__entregables', filter=Q(proyecto__entregables__estado='completado')),
                total_hitos=Count('proyecto__entregables')
            ),
            to_attr='contratos_activos'
        )
    ).order_by('-fecha_publicacion')[:50]
    
    logs = list(LogAuditoria.objects.select_related('usuario').order_by('-fecha_hora').values_list(
        'id', 'usuario__username', 'accion', 'tabla_afectada', 'fecha_hora'
    )[:20])

    admin_ids = get_admin_ids()
    
    # --- CONTEO DE MENSAJES NO LEÍDOS PARA EL BADGE ---
    mensajes_no_leidos_admin = Mensaje.objects.filter(receptor_id__in=admin_ids, leido=False).count()

    mensajes_soporte = Mensaje.objects.filter(Q(remitente_id__in=admin_ids) | Q(receptor_id__in=admin_ids)).values_list('remitente_id', 'receptor_id')
    u_ids = set()
    for r, s in mensajes_soporte:
        if r not in admin_ids: u_ids.add(r)
        if s not in admin_ids: u_ids.add(s)
    
    # --- OPTIMIZACIÓN DE CONVERSACIONES (Eliminando N+1 con Subquery) ---
    ultimo_mensaje_sq = Mensaje.objects.filter(
        (Q(remitente=OuterRef('pk'), receptor_id__in=admin_ids) | 
         Q(remitente_id__in=admin_ids, receptor=OuterRef('pk')))
    ).order_by('-fecha_envio').values('id')[:1]

    contactos = Usuario.objects.filter(id__in=u_ids).annotate(
        ultimo_mensaje_id=Subquery(ultimo_mensaje_sq)
    )
    
    conversaciones = []
    # Ahora solo traemos los mensajes cuyos IDs ya identificamos en la subconsulta
    mensajes_ids = [c.ultimo_mensaje_id for c in contactos if c.ultimo_mensaje_id]
    ultimos_mensajes = {m.id: m for m in Mensaje.objects.filter(id__in=mensajes_ids).select_related('remitente')}

    for contacto in contactos:
        ultimo_m = ultimos_mensajes.get(contacto.ultimo_mensaje_id)
        if ultimo_m:
            tiene_pendientes = (ultimo_m.remitente_id == contacto.id and not ultimo_m.leido)
            conversaciones.append({
                'usuario': contacto, 
                'ultimo_mensaje': ultimo_m,
                'pendiente': tiene_pendientes
            })
    conversaciones.sort(key=lambda x: x['ultimo_mensaje'].fecha_envio, reverse=True)

    # 5. Ranking de Desarrolladores (Top >= 4.0 y Bajo Desempeño < 4.0)
    desarrolladores_qs = Usuario.objects.filter(rol='desarrollador').annotate(
        promedio=Coalesce(Avg('valoraciones_como_dev__puntuacion',
            filter=Q(valoraciones_como_dev__rol_evaluador='empresa')),
            Value(0.0), output_field=FloatField()),
        proyectos_comp=Count('contrataciones_dev',
            filter=Q(contrataciones_dev__estado='finalizada')),
    )
    ranking_top = list(desarrolladores_qs.filter(promedio__gte=4.0)
        .order_by('-promedio', '-proyectos_comp')[:5]
        .values_list('nombre', 'proyectos_comp', 'promedio', 'id'))
    ranking_bajo = list(desarrolladores_qs.filter(promedio__lt=4.0)
        .order_by('promedio', 'proyectos_comp')[:5]
        .values_list('nombre', 'proyectos_comp', 'promedio', 'id'))

    # 6. Obtener Indicadores de Salud Global (Ya extraídos de stats_globales)
    salud_global = (promedio_global, p_ret)

    # 7. Obtener Lista Detallada de Alertas (v_proyectos_alerta_inactividad)
    siete_dias_atras = timezone.now() - timedelta(days=7)
    proyectos_alerta = Proyecto.objects.filter(
        estado='en_desarrollo'
    ).annotate(
        ultimo_avance=Max('entregables__fecha_creacion'),
    ).filter(
        Q(ultimo_avance__lt=siete_dias_atras) | Q(ultimo_avance__isnull=True)
    ).select_related('empresa').prefetch_related(
        Prefetch('contrataciones',
            queryset=Contratacion.objects.filter(estado='activa').select_related('desarrollador'),
            to_attr='contratos_activos')
    ).distinct()

    alertas_retraso = []
    for p in proyectos_alerta:
        dev_nombre = p.contratos_activos[0].desarrollador.nombre if p.contratos_activos else ''
        dias = 0
        if p.ultimo_avance:
            dias = (timezone.now() - p.ultimo_avance).days
        elif p.contratos_activos:
            dias = (timezone.now().date() - p.contratos_activos[0].fecha_inicio).days
        alertas_retraso.append((p.titulo, p.empresa.nombre, dev_nombre, dias))

    # 8. Ranking de Empresas (Top >= 4.0 y Alerta < 4.0)
    empresas_qs = Usuario.objects.filter(rol='empresa').annotate(
        promedio=Coalesce(Avg('valoraciones_como_empresa__puntuacion',
            filter=Q(valoraciones_como_empresa__rol_evaluador='desarrollador')),
            Value(0.0), output_field=FloatField()),
        total_eval=Count('valoraciones_como_empresa',
            filter=Q(valoraciones_como_empresa__rol_evaluador='desarrollador')),
        nombre_empresa=Coalesce(F('perfil_empresa__nombre_empresa'), Value('')),
    )
    ranking_empresas_top = list(empresas_qs.filter(promedio__gte=4.0)
        .order_by('-promedio', '-total_eval')[:5]
        .values_list('nombre', 'nombre_empresa', 'promedio', 'total_eval', 'id'))
    ranking_empresas_bajo = list(empresas_qs.filter(promedio__lt=4.0)
        .order_by('promedio', 'total_eval')[:5]
        .values_list('nombre', 'nombre_empresa', 'promedio', 'total_eval', 'id'))

    # 9. Obtener Reseñas Recientes para Auditoría (valoraciones directas)
    resenas_auditoria = []
    for v in Valoracion.objects.select_related('empresa', 'desarrollador').order_by('-fecha')[:10]:
        if v.rol_evaluador == 'empresa':
            de = v.empresa.nombre
            para = v.desarrollador.nombre
        else:
            de = v.desarrollador.nombre
            para = v.empresa.nombre
        resenas_auditoria.append((de, para, v.puntuacion, v.comentario, v.rol_evaluador))

    # 10. Notificaciones para el Admin (Centralizado con Utility)
    notificaciones_admin, notificaciones_pendientes_count = get_notificaciones_context(request.user.id)

    context = {
        'total_usuarios': total_usuarios, 'total_proyectos': total_proyectos,
        'total_devs': total_devs, 'total_empresas': total_empresas,
        'p_pub': p_pub, 'p_des': p_des, 'p_fin': p_fin, 'p_pen': p_pen,
        'post_pen': post_pen, 'promedio_global': promedio_global, 'p_ret': p_ret,
        'usuarios_todos': usuarios_lista, 'proyectos_todos': proyectos_lista,
        'logs_auditoria': logs, 'conversaciones': conversaciones, 
        'mensajes_no_leidos_admin': mensajes_no_leidos_admin,
        'ranking_talento': ranking_top,
        'ranking_bajo': ranking_bajo,
        'ranking_empresas': ranking_empresas_top,
        'ranking_empresas_bajo': ranking_empresas_bajo,
        'resenas_auditoria': resenas_auditoria,
        'salud_global': salud_global,
        'alertas_retraso': alertas_retraso,
        'notificaciones': notificaciones_admin,
        'notificaciones_pendientes_count': notificaciones_pendientes_count,
        'admin_id': request.user.id,
        'admin_ids': list(admin_ids)
    }
    return render(request, 'administrador/Administrador.html', context)

@login_required
@require_POST
def marcar_notificaciones_leidas(request):
    Notificacion.objects.filter(usuario_id=request.user.id, leida=False).update(leida=True)
    
    # Redirección inteligente según el rol
    if request.user.rol == 'administrador':
        return redirect('dashboard_admin')
    elif request.user.rol == 'empresa':
        return redirect('dashboard_empresa')
    else:
        return redirect('dashboard_desarrollador')

@login_required
@require_POST
def admin_toggle_usuario(request, usuario_id):
    if request.user.rol != 'administrador': return redirect('inicio')
    user = get_object_or_404(Usuario, id=usuario_id)
    
    # trigger.
    if user.estado == 'activo':
        user.estado = 'inactivo'
        user.is_active = False
    else:
        user.estado = 'activo'
        user.is_active = True
        
    user.save()
    LogAuditoria.objects.create(
        usuario=request.user,
        accion=f"Cambió estado del usuario {user.username} a {user.estado}",
        tabla_afectada='usuarios',
        registro_id=user.id,
    )
    messages.info(request, f"Estado del usuario {user.username} actualizado a {user.estado}.")
    return redirect(reverse('dashboard_admin') + '?section=usersSection')

@login_required
@require_POST
def admin_reactivar_proyecto(request, proyecto_id):
    """Acción de moderación: Reactiva un proyecto finalizado a petición de la empresa"""
    if request.user.rol != 'administrador':
        messages.error(request, "Acceso denegado.")
        return redirect('inicio')
    
    with transaction.atomic():
        proyecto = Proyecto.objects.select_for_update().get(id=proyecto_id)
        
        if proyecto.estado != 'finalizado':
            messages.warning(request, "Solo se pueden reactivar proyectos finalizados.")
            return redirect('ver_avances', proyecto_id=proyecto.id)

        # 1. Cambiar estado del proyecto
        estado_anterior = proyecto.estado
        proyecto.estado = 'en_desarrollo'
        proyecto.save()
        
        # Registrar Historial (Captura que fue el ADMIN)
        proyecto.registrar_cambio_estado('en_desarrollo', request.user, estado_anterior=estado_anterior)
        
        # 2. Reactivar contrataciones
        Contratacion.objects.filter(proyecto=proyecto, estado='finalizada').update(estado='activa')
        
        # 3. Notificar a los involucrados (Empresa y Devs)
        notificaciones = [
            Notificacion(
                usuario=proyecto.empresa,
                tipo='avance',
                mensaje=f"SOPORTE: Tu proyecto '{proyecto.titulo}' ha sido reactivado exitosamente."
            )
        ]
        
        devs_ids = Contratacion.objects.filter(proyecto=proyecto, estado='activa').values_list('desarrollador_id', flat=True)
        for dev_id in devs_ids:
            notificaciones.append(Notificacion(
                usuario_id=dev_id,
                tipo='avance',
                mensaje=f"ALERTA: El proyecto '{proyecto.titulo}' ha sido reactivado por la empresa."
            ))
        
        Notificacion.objects.bulk_create(notificaciones)

    messages.success(request, f"Proyecto '{proyecto.titulo}' reactivado y contratos restablecidos.")
    return redirect('ver_avances', proyecto_id=proyecto.id)

@login_required
def api_usuarios(request):
    if request.user.rol != 'administrador':
        return JsonResponse({'error': 'Acceso denegado. Solo administradores pueden listar usuarios.'}, status=403)
    usuarios = list(Usuario.objects.values('id', 'username', 'nombre', 'email', 'rol', 'identificacion'))
    return JsonResponse(usuarios, safe=False)

@login_required
def api_usuario_detalle(request, usuario_id):
    if request.user.rol != 'administrador':
        return JsonResponse({'error': 'Acceso denegado.'}, status=403)
    
    if request.method != 'GET':
        return JsonResponse({'error': 'Método no permitido.'}, status=405)

    user = get_object_or_404(Usuario, id=usuario_id)
    return JsonResponse({
        'id': user.id, 
        'username': user.username, 
        'nombre': user.nombre,
        'email': user.email, 
        'rol': user.rol,
        'identificacion': user.identificacion,
        'estado': user.estado
    })

@login_required
def api_crear_usuario(request):
    if request.user.rol != 'administrador':
        return JsonResponse({'error': 'Acceso denegado.'}, status=403)
    
    if request.method != 'POST':
        return JsonResponse({'error': 'Método no permitido. Use POST.'}, status=405)

    try:
        data = json.loads(request.body)
        # Validación de campos requeridos
        required = ['username', 'email', 'password', 'rol']
        if not all(k in data for k in required):
            return JsonResponse({'error': f'Faltan campos requeridos: {required}'}, status=400)

        user = Usuario.objects.create_user(
            username=data['username'], 
            email=data['email'], 
            password=data['password'], 
            rol=data['rol']
        )
        
        # Invalidad caché administrativa si el nuevo usuario es admin
        if user.rol == 'administrador':
            cache.delete('admin_id')
            cache.delete('admin_ids_list')
            
        return JsonResponse({'id': user.id, 'status': 'created'}, status=201)
    except IntegrityError:
        return JsonResponse({'error': 'El nombre de usuario o email ya existe.'}, status=409)
    except (json.JSONDecodeError, KeyError) as e:
        return JsonResponse({'error': f'Datos JSON inválidos: {str(e)}'}, status=400)
    except Exception as e:
        return JsonResponse({'error': f'Error interno: {str(e)}'}, status=500)

@login_required
def api_actualizar_usuario(request, usuario_id):
    if request.user.rol != 'administrador':
        return JsonResponse({'error': 'Acceso denegado.'}, status=403)
    
    if request.method != 'PUT':
        return JsonResponse({'error': 'Método no permitido. Use PUT.'}, status=405)

    try:
        data = json.loads(request.body)
        user = get_object_or_404(Usuario, id=usuario_id)
        
        # Actualización flexible de campos
        rol_anterior = user.rol
        if 'email' in data: user.email = data['email']
        if 'nombre' in data: user.nombre = data['nombre']
        if 'rol' in data: user.rol = data['rol']
        if 'estado' in data:
            user.estado = data['estado']
            # Sincronizar is_active: solo 'activo' permite autenticarse en Django
            user.is_active = (user.estado == 'activo')
        
        user.save()

        campos_modificados = [k for k in data if k in ('email', 'nombre', 'rol', 'estado')]
        LogAuditoria.objects.create(
            usuario=request.user,
            accion=f"Actualizó usuario {user.username}: {', '.join(campos_modificados)}",
            tabla_afectada='usuarios',
            registro_id=user.id,
        )

        # Invalidad caché si el rol cambió a/desde administrador
        if rol_anterior == 'administrador' or user.rol == 'administrador':
            cache.delete('admin_id')
            cache.delete('admin_ids_list')

        return JsonResponse({'status': 'updated'})
    except IntegrityError:
        return JsonResponse({'error': 'El email ya está en uso por otro usuario.'}, status=409)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Formato JSON inválido.'}, status=400)

@login_required
def api_eliminar_usuario(request, usuario_id):
    if request.user.rol != 'administrador':
        return JsonResponse({'error': 'Acceso denegado.'}, status=403)
    
    if request.method != 'DELETE':
        return JsonResponse({'error': 'Método no permitido. Use DELETE.'}, status=405)

    user = get_object_or_404(Usuario, id=usuario_id)
    if user.id == request.user.id:
        return JsonResponse({'error': 'No puedes eliminarte a ti mismo.'}, status=400)
        
    user.delete()
    return JsonResponse({'status': 'deleted'})
