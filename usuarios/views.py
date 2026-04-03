from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_POST
from django.contrib import messages
from django.db import transaction, connection, IntegrityError
from django.db.models import Avg, Q, Count, Prefetch, OuterRef, Subquery
from django.core.cache import cache
from django.http import JsonResponse
from django.utils import timezone
import json

from .forms import RegistroUsuarioForm, PerfilEmpresaForm, PerfilDesarrolladorForm
from .models import Usuario, PerfilEmpresa, PerfilDesarrollador
from .decorators import requiere_usuario_activo
from .utils import get_admin_id, get_admin_ids
from proyectos.models import Proyecto, Valoracion, Entregable
from postulaciones.models import Postulacion
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from favoritos.models import Favorito
from mensajes.models import Mensaje

def get_notificaciones_context(user_id):
    """Retorna historial de notificaciones y conteo de pendientes."""
    notificaciones_recientes = []
    pendientes_count = 0
    with connection.cursor() as cursor:
        # 1. Historial (10 últimas)
        cursor.execute("""
            SELECT tipo, mensaje, fecha, leida 
            FROM notificaciones 
            WHERE usuario_id = %s 
            ORDER BY fecha DESC 
            LIMIT 10
        """, [user_id])
        rows = cursor.fetchall()
        for row in rows:
            notificaciones_recientes.append({
                'tipo': row[0], 'mensaje': row[1], 'fecha': row[2], 'leida': row[3]
            })
        
        # 2. Conteo de pendientes desde la vista SQL
        cursor.execute("SELECT COUNT(*) FROM v_notificaciones_pendientes WHERE usuario_id = %s", [user_id])
        pendientes_count = cursor.fetchone()[0]
        
    return notificaciones_recientes, pendientes_count

def inicio(request):
    # --- DESPERTANDO v_portafolio_publico ---
    casos_exito = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT titulo, tipo_solucion, empresa_nombre, desarrollador_nombre, calificacion_proyecto 
            FROM v_portafolio_publico 
            ORDER BY fecha_finalizacion DESC 
            LIMIT 4
        """)
        rows = cursor.fetchall()
        for row in rows:
            casos_exito.append({
                'titulo': row[0],
                'tipo_solucion': row[1],
                'empresa_nombre': row[2],
                'desarrollador_nombre': row[3],
                'calificacion': row[4]
            })

    return render(request, 'publico/index.html', {'casos_exito': casos_exito})

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        rol_seleccionado = request.POST.get('rol_seleccionado')
        
        # 1. Verificación preventiva de bloqueo y obtención del objeto usuario
        user_to_check = None
        try:
            user_to_check = Usuario.objects.get(username=username)
            if user_to_check.estado in ['suspendido', 'inactivo']:
                messages.error(request, "Tu cuenta ha sido suspendida o está inactiva. Por favor, comunícate con el administrador para más información.")
                return redirect('inicio')
        except Usuario.DoesNotExist:
            pass

        # 2. Autenticación normal
        user = authenticate(username=username, password=password)

        if user is not None:
            # 3. Validación de rol: El rol real debe coincidir con el seleccionado en el frontend
            if user.rol != rol_seleccionado:
                messages.error(request, f"No tienes permisos de '{rol_seleccionado}' con esta cuenta.")
                return redirect('inicio')

            # Login exitoso: Resetear intentos fallidos si tenía alguno
            if user.intentos_fallidos > 0:
                user.intentos_fallidos = 0
                user.save(update_fields=['intentos_fallidos'])

            login(request, user)

            if user.rol == 'administrador': return redirect('dashboard_admin')
            if user.rol == 'empresa': return redirect('dashboard_empresa')
            return redirect('dashboard_desarrollador')            
        
        # 4. Manejo de intentos fallidos si el usuario existe
        if user_to_check:
            user_to_check.intentos_fallidos += 1
            if user_to_check.intentos_fallidos >= 5:
                user_to_check.estado = 'suspendido'
                user_to_check.save(update_fields=['intentos_fallidos', 'estado'])
                messages.error(request, "Tu cuenta ha sido suspendida por exceso de intentos fallidos. Contacta a soporte.")
            else:
                user_to_check.save(update_fields=['intentos_fallidos'])
                messages.error(request, f"Usuario o contraseña incorrectos. Intento {user_to_check.intentos_fallidos} de 5.")
        else:
            # Error genérico para usuarios que no existen
            messages.error(request, "Usuario o contraseña incorrectos.")
            
        return redirect('inicio')
            
    return render(request, 'publico/inicio_sesion.html')

def logout_view(request):
    logout(request)
    return redirect('inicio')

def registro_view(request):
    if request.method == 'POST':
        form = RegistroUsuarioForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            if user.rol == 'empresa': return redirect('dashboard_empresa')
            return redirect('dashboard_desarrollador')
    else:
        form = RegistroUsuarioForm()
    return render(request, 'publico/registro.html', {'form': form})

def recuperar_view(request):
    if request.method == 'POST':
        # Placeholder: Solo mostramos el mensaje sin realizar ninguna acción en la DB
        messages.success(request, "Se han enviado instrucciones de recuperación a dev@pro.com")
        return redirect('login')
            
    return render(request, 'publico/recuperarcon.html')

@login_required
@requiere_usuario_activo
def dashboard_empresa(request):
    if request.user.rol != 'empresa': return redirect('inicio')
    
    # --- DESPERTANDO v_dashboard_empresa ---
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT proyectos_publicados, proyectos_activos, postulaciones_pendientes, desarrolladores_contratados 
            FROM v_dashboard_empresa 
            WHERE empresa_id = %s
        """, [request.user.id])
        stats = cursor.fetchone()

    # Si no hay datos, inicializamos en cero
    p_pub, p_act, post_pen, dev_con = stats if stats else (0, 0, 0, 0)

    # --- DESPERTANDO v_proyectos_en_desarrollo (para Empresa) ---
    en_desarrollo_v = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT proyecto_id, titulo, desarrolladores_nombres, hitos_completados, hitos_totales, ultimo_avance, fecha_limite, estado, desarrolladores_ids
            FROM v_proyectos_en_desarrollo
            WHERE empresa_id = %s
        """, [request.user.id])
        rows = cursor.fetchall()
        for row in rows:
            dev_ids = row[8].split(',') if row[8] else []
            en_desarrollo_v.append({
                'proyecto_id': row[0],
                'titulo': row[1],
                'desarrolladores': row[2],
                'hitos_completados': row[3],
                'hitos_totales': row[4],
                'ultimo_avance': row[5],
                'fecha_fin': row[6],
                'estado': row[7],
                'ids': row[8],
                'primer_dev_id': dev_ids[0] if dev_ids else None,
                'num_desarrolladores': len(dev_ids)
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
    
    # Soporte Admin Dinámico
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

    # --- DESPERTANDO v_dashboard_desarrollador ---
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT calificacion_promedio, num_proyectos_completados, proyectos_activos, proyectos_favoritos 
            FROM v_dashboard_desarrollador 
            WHERE desarrollador_id = %s
        """, [request.user.id])
        stats = cursor.fetchone()

    # Si no tiene datos, inicializamos
    promedio, p_comp, p_act, p_fav = stats if stats else (0, 0, 0, 0)

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

    # --- DESPERTANDO v_proyectos_en_desarrollo (Vista de Avances) ---
    mis_proyectos_v = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT proyecto_id, titulo, empresa_nombre, hitos_completados, hitos_totales, ultimo_avance, fecha_limite, estado, empresa_id, desarrolladores_ids
            FROM v_proyectos_en_desarrollo
            WHERE FIND_IN_SET(%s, desarrolladores_ids) > 0
        """, [str(request.user.id)])
        rows = cursor.fetchall()

    if rows:
        # OPTIMIZACIÓN: Pre-cargar todos los hitos en una sola query (Evita N+1)
        proyectos_ids = [row[0] for row in rows]
        hitos_todos = Entregable.objects.filter(
            Q(proyecto_id__in=proyectos_ids) & 
            (Q(equipo__miembros=request.user) | Q(equipo__isnull=True))
        ).distinct().values('proyecto_id', 'titulo', 'estado', 'descripcion')

        # Agrupar hitos por proyecto en un diccionario
        hitos_por_proyecto = {}
        for h in hitos_todos:
            p_id = h['proyecto_id']
            if p_id not in hitos_por_proyecto:
                hitos_por_proyecto[p_id] = []
            hitos_por_proyecto[p_id].append(h)

        for row in rows:
            dev_ids = row[9].split(',') if row[9] else []
            mis_proyectos_v.append({
                'proyecto_id': row[0],
                'titulo': row[1],
                'empresa_nombre': row[2],
                'hitos_completados': row[3],
                'hitos_totales': row[4],
                'ultimo_avance': row[5],
                'fecha_fin': row[6],
                'estado': row[7],
                'empresa_id': row[8],
                'num_desarrolladores': len(dev_ids),
                'hitos': hitos_por_proyecto.get(row[0], []) # Usamos los hitos pre-cargados
            })
    # Soporte Admin Dinámico
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
    
    # --- UNIFICACIÓN: v_estadisticas_sistema (Motor de Salud Global) ---
    stats_globales = None
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT 
                total_empresas_activas, total_desarrolladores_activos, 
                proyectos_publicados, proyectos_en_desarrollo, proyectos_finalizados,
                proyectos_pendientes_aprobacion, postulaciones_pendientes, 
                calificacion_promedio_global, proyectos_con_retraso
            FROM v_estadisticas_sistema
        """)
        stats_globales = cursor.fetchone()

    # Mapeo de variables (Si la vista no devuelve nada, usamos ceros)
    if stats_globales:
        total_empresas, total_devs, p_pub, p_des, p_fin, p_pen, post_pen, promedio_global, p_ret = stats_globales
        total_proyectos = p_pub + p_des + p_fin + p_pen
        total_usuarios = total_empresas + total_devs
    else:
        total_empresas, total_devs, p_pub, p_des, p_fin, p_pen, post_pen, promedio_global, p_ret = (0, 0, 0, 0, 0, 0, 0, 0, 0)
        total_proyectos = 0
        total_usuarios = 0
    
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
    
    logs = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT l.id, u.username, l.accion, l.tabla_afectada, l.fecha_hora FROM logs_auditoria l JOIN usuarios u ON l.usuario_id = u.id ORDER BY l.fecha_hora DESC LIMIT 20")
        logs = cursor.fetchall()

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
    ranking_top = []
    ranking_bajo = []
    with connection.cursor() as cursor:
        # Mejores Calificados (Top Talento)
        cursor.execute("""
            SELECT nombre, num_proyectos_completados, calificacion_promedio, id 
            FROM v_top_desarrolladores 
            WHERE calificacion_promedio >= 4.0
            ORDER BY calificacion_promedio DESC, num_proyectos_completados DESC LIMIT 5
        """)
        ranking_top = cursor.fetchall()
        
        # Peores Calificados (Talento en Alerta)
        cursor.execute("""
            SELECT nombre, num_proyectos_completados, calificacion_promedio, id 
            FROM v_top_desarrolladores 
            WHERE calificacion_promedio < 4.0
            ORDER BY calificacion_promedio ASC, num_proyectos_completados ASC LIMIT 5
        """)
        ranking_bajo = cursor.fetchall()

    # 6. Obtener Indicadores de Salud Global (Ya extraídos de stats_globales)
    salud_global = (promedio_global, p_ret)

    # 7. Obtener Lista Detallada de Alertas (v_proyectos_alerta_inactividad)
    alertas_retraso = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT titulo, empresa_nombre, desarrollador_nombre, dias_sin_avance FROM v_proyectos_alerta_inactividad")
        alertas_retraso = cursor.fetchall()

    # 8. Ranking de Empresas (Top >= 4.0 y Alerta < 4.0)
    ranking_empresas_top = []
    ranking_empresas_bajo = []
    with connection.cursor() as cursor:
        # Mejores Empresas (Socio SENA)
        cursor.execute("""
            SELECT nombre_usuario, nombre_empresa, promedio_reputacion, total_evaluaciones, usuario_id 
            FROM v_reputacion_empresas 
            WHERE promedio_reputacion >= 4.0
            ORDER BY promedio_reputacion DESC, total_evaluaciones DESC LIMIT 5
        """)
        ranking_empresas_top = cursor.fetchall()
        
        # Empresas en Alerta (Bajo Desempeño)
        cursor.execute("""
            SELECT nombre_usuario, nombre_empresa, promedio_reputacion, total_evaluaciones, usuario_id 
            FROM v_reputacion_empresas 
            WHERE promedio_reputacion < 4.0
            ORDER BY promedio_reputacion ASC, total_evaluaciones ASC LIMIT 5
        """)
        ranking_empresas_bajo = cursor.fetchall()

    # 9. Obtener Reseñas Recientes para Auditoría (valoraciones directas)
    resenas_auditoria = []
    with connection.cursor() as cursor:
        # Simplificando la lógica de la consulta para evitar confusiones de JOIN
        cursor.execute("""
            SELECT 
                (SELECT nombre FROM usuarios WHERE id = (CASE WHEN rol_evaluador = 'empresa' THEN empresa_id ELSE desarrollador_id END)) as de,
                (SELECT nombre FROM usuarios WHERE id = (CASE WHEN rol_evaluador = 'empresa' THEN desarrollador_id ELSE empresa_id END)) as para,
                puntuacion, comentario, rol_evaluador
            FROM valoraciones ORDER BY fecha DESC LIMIT 10
        """)
        resenas_auditoria = cursor.fetchall()

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
    # Usamos el Procedimiento Almacenado de MySQL para mantener la lógica centralizada
    with connection.cursor() as cursor:
        cursor.callproc('sp_marcar_notificaciones_leidas', [request.user.id])
    
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
def editar_perfil(request):
    if request.user.rol == 'empresa':
        perfil, _ = PerfilEmpresa.objects.get_or_create(usuario=request.user)
        form = PerfilEmpresaForm(request.POST or None, request.FILES or None, instance=perfil)
        redirect_to = 'dashboard_empresa'
    elif request.user.rol == 'desarrollador':
        perfil, _ = PerfilDesarrollador.objects.get_or_create(usuario=request.user)
        form = PerfilDesarrolladorForm(request.POST or None, request.FILES or None, instance=perfil)
        redirect_to = 'dashboard_desarrollador'
    else: return redirect('inicio')

    if request.method == 'POST' and form.is_valid():
        form.save()
        messages.success(request, "Perfil actualizado")
        return redirect(redirect_to)
    return render(request, 'usuarios/editar_perfil.html', {'form': form})

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
        if 'estado' in data: user.estado = data['estado']
        
        user.save()

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
