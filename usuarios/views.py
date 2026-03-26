from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db import transaction, connection
from django.db.models import Avg, Q, Max
from django.http import JsonResponse
from django.utils import timezone
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import make_password
import json

from .forms import RegistroUsuarioForm, PerfilEmpresaForm, PerfilDesarrolladorForm
from .models import Usuario, PerfilEmpresa, PerfilDesarrollador
from proyectos.models import Proyecto
from postulaciones.models import Postulacion
from contrataciones.models import Contratacion
from notificaciones.models import Notificacion
from favoritos.models import Favorito
from mensajes.models import Mensaje

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
        
        # 1. Verificar si el usuario existe antes de autenticar
        try:
            user_check = Usuario.objects.get(username=username)
            if not user_check.is_active:
                messages.error(request, "Tu cuenta ha sido bloqueada por el administrador. Contacta con soporte.")
                return render(request, 'publico/inicio_sesion.html')
        except Usuario.DoesNotExist:
            pass # Dejamos que authenticate maneje el error genérico después

        user = authenticate(username=username, password=password)
        
        if user:
            # VALIDACIÓN DE SEGURIDAD: El rol real debe coincidir con el seleccionado
            if user.rol != rol_seleccionado:
                messages.error(request, f"Este usuario no tiene permisos para acceder como {rol_seleccionado}.")
                return render(request, 'publico/inicio_sesion.html')

            # Actualizar ultimo_acceso para disparar trigger de auditoría MySQL
            user.ultimo_acceso = timezone.now()
            user.save(update_fields=['ultimo_acceso'])
            
            login(request, user)
            if user.rol == 'administrador': return redirect('dashboard_admin')
            if user.rol == 'empresa': return redirect('dashboard_empresa')
            return redirect('dashboard_desarrollador')
            
        messages.error(request, "Usuario o contraseña incorrectos")
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
    return render(request, 'publico/recuperarcon.html')

@login_required
def dashboard_empresa(request):
    # --- CERROJO DE SEGURIDAD: Solo usuarios ACTIVOS ---
    if request.user.estado != 'activo':
        from django.contrib.auth import logout
        from django.contrib import messages
        logout(request)
        messages.error(request, "Tu cuenta ha sido suspendida o está inactiva. Contacta al administrador.")
        return redirect('login')

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
    proyectos_en_marcha = []
    with connection.cursor() as cursor:
        # Nota: La vista usa empresa_id_raw si queremos filtrar por el ID real
        # Si no existe empresa_id_raw, usamos empresa_id
        cursor.execute("""
            SELECT proyecto_id, titulo, desarrollador_nombre, porcentaje_avance, ultimo_avance, fecha_fin_estimada, estado, desarrollador_id 
            FROM v_proyectos_en_desarrollo 
            WHERE empresa_id = %s
        """, [request.user.id])
        rows = cursor.fetchall()
        for row in rows:
            proyectos_en_marcha.append({
                'proyecto_id': row[0],
                'titulo': row[1],
                'desarrollador_nombre': row[2],
                'porcentaje': row[3],
                'ultimo_avance': row[4],
                'fecha_fin': row[5],
                'estado': row[6],
                'desarrollador_id': row[7]
            })

    perfil, _ = PerfilEmpresa.objects.get_or_create(usuario=request.user)
    mis_ofertas = Proyecto.objects.filter(empresa=request.user, estado='publicado').order_by('-fecha_publicacion')
    
    # Optimizamos el historial para traer la contratación y el desarrollador asociado
    historial = Proyecto.objects.filter(
        empresa=request.user, 
        estado='finalizado'
    ).prefetch_related('contrataciones', 'contrataciones__desarrollador').order_by('-fecha_aprobacion')
    postulaciones_pendientes_obj = Postulacion.objects.filter(proyecto__empresa=request.user, estado='pendiente')
    
    # Soporte Admin Dinámico
    admin_instancia = Usuario.objects.filter(rol='administrador').first()
    admin_id = admin_instancia.id if admin_instancia else 1

    # Reputación Corporativa
    from proyectos.models import Valoracion
    valoraciones_dev = Valoracion.objects.filter(empresa=request.user, rol_evaluador='desarrollador').select_related('desarrollador', 'proyecto')
    promedio_empresa = valoraciones_dev.aggregate(Avg('puntuacion'))['puntuacion__avg'] or 0

    # --- MEJORA: Historial de Notificaciones (Leídas y No Leídas) ---
    notificaciones_recientes = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT tipo, mensaje, fecha, leida 
            FROM notificaciones 
            WHERE usuario_id = %s 
            ORDER BY fecha DESC 
            LIMIT 10
        """, [request.user.id])
        rows = cursor.fetchall()
        for row in rows:
            notificaciones_recientes.append({
                'tipo': row[0], 
                'mensaje': row[1], 
                'fecha': row[2],
                'leida': row[3]
            })

    # --- MEJORA: Conteo de Notificaciones Pendientes (Universal) ---
    notificaciones_pendientes_count = 0
    with connection.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM v_notificaciones_pendientes WHERE usuario_id = %s", [request.user.id])
        notificaciones_pendientes_count = cursor.fetchone()[0]

    context = {
        'total_proyectos': p_pub,
        'proyectos_activos': p_act,
        'total_postulaciones': post_pen,
        'total_contratados': dev_con,
        'mis_ofertas': mis_ofertas,
        'en_desarrollo_v': proyectos_en_marcha,
        'historial': historial,
        'valoraciones_recibidas': valoraciones_dev,
        'promedio_empresa': round(promedio_empresa, 1),
        'postulaciones_pendientes': postulaciones_pendientes_obj,
        'notificaciones': notificaciones_recientes,
        'notificaciones_pendientes_count': notificaciones_pendientes_count,
        'perfil': perfil,
        'mis_contrataciones_v': proyectos_en_marcha,
        'admin_id': admin_id
    }
    return render(request, 'empresa/empresa.html', context)

@login_required
def dashboard_desarrollador(request):
    # --- CERROJO DE SEGURIDAD: Solo usuarios ACTIVOS ---
    if request.user.estado != 'activo':
        from django.contrib.auth import logout
        from django.contrib import messages
        logout(request)
        messages.error(request, "Tu cuenta ha sido suspendida o está inactiva. Contacta al administrador.")
        return redirect('login')

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
    mis_proyectos_finalizados = Contratacion.objects.filter(desarrollador=request.user, estado='finalizada').select_related('proyecto', 'empresa')
    
    # IDs de proyectos donde el usuario YA TIENE acción (para excluir de favoritos)
    proyectos_con_accion = set(mis_postulaciones.values_list('proyecto_id', flat=True))
    proyectos_con_accion.update(mis_proyectos_activos_q.values_list('proyecto_id', flat=True))
    proyectos_con_accion.update(mis_proyectos_finalizados.values_list('proyecto_id', flat=True))

    # Favoritos: Solo proyectos PUBLICADOS y donde NO TENGA acción aún
    mis_favoritos = Favorito.objects.filter(
        desarrollador=request.user, 
        proyecto__estado='publicado'
    ).exclude(proyecto_id__in=proyectos_con_accion).select_related('proyecto')

    # Enriquecer los contratos finalizados con su valoración correspondiente
    from proyectos.models import Valoracion
    for contrato in mis_proyectos_finalizados:
        contrato.valoracion = Valoracion.objects.filter(
            proyecto=contrato.proyecto, 
            desarrollador=request.user,
            rol_evaluador='empresa' 
        ).first()

    # --- DESPERTANDO v_proyectos_en_desarrollo (Vista de Avances) ---
    mis_proyectos_v = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT proyecto_id, titulo, empresa_nombre, porcentaje_avance, ultimo_avance, fecha_fin_estimada, estado, empresa_id 
            FROM v_proyectos_en_desarrollo 
            WHERE desarrollador_id = %s
        """, [request.user.id])
        rows = cursor.fetchall()
        for row in rows:
            mis_proyectos_v.append({
                'proyecto_id': row[0],
                'titulo': row[1],
                'empresa_nombre': row[2],
                'porcentaje': row[3],
                'ultimo_avance': row[4],
                'fecha_fin': row[5],
                'estado': row[6],
                'empresa_id': row[7]
            })

    # Soporte Admin Dinámico
    admin_instancia = Usuario.objects.filter(rol='administrador').first()
    admin_id = admin_instancia.id if admin_instancia else 1

    # --- MEJORA: Historial de Notificaciones (Vista SQL Personalizada) ---
    notificaciones_recientes = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT tipo, mensaje, fecha, leida 
            FROM notificaciones 
            WHERE usuario_id = %s 
            ORDER BY fecha DESC 
            LIMIT 10
        """, [request.user.id])
        rows = cursor.fetchall()
        for row in rows:
            notificaciones_recientes.append({
                'tipo': row[0], 
                'mensaje': row[1], 
                'fecha': row[2],
                'leida': row[3]
            })

    # --- MEJORA: Conteo de Notificaciones Pendientes (Universal) ---
    notificaciones_pendientes_count = 0
    with connection.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM v_notificaciones_pendientes WHERE usuario_id = %s", [request.user.id])
        notificaciones_pendientes_count = cursor.fetchone()[0]

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
    
    usuarios_lista = Usuario.objects.all().order_by('-date_joined')
    proyectos_lista = Proyecto.objects.all().select_related('empresa').order_by('-fecha_publicacion')
    
    logs = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT l.id, u.username, l.accion, l.tabla_afectada, l.fecha_hora FROM logs_auditoria l JOIN usuarios u ON l.usuario_id = u.id ORDER BY l.fecha_hora DESC LIMIT 20")
        logs = cursor.fetchall()

    admin_ids = Usuario.objects.filter(rol='administrador').values_list('id', flat=True)
    
    # --- CONTEO DE MENSAJES NO LEÍDOS PARA EL BADGE ---
    mensajes_no_leidos_admin = Mensaje.objects.filter(receptor_id__in=admin_ids, leido=False).count()

    mensajes_soporte = Mensaje.objects.filter(Q(remitente_id__in=admin_ids) | Q(receptor_id__in=admin_ids)).values_list('remitente_id', 'receptor_id')
    u_ids = set()
    for r, s in mensajes_soporte:
        if r not in admin_ids: u_ids.add(r)
        if s not in admin_ids: u_ids.add(s)
    
    conversaciones = []
    for uid in u_ids:
        try:
            contacto = Usuario.objects.get(id=uid)
            ultimo_m = Mensaje.objects.filter((Q(remitente=contacto, receptor_id__in=admin_ids) | Q(remitente_id__in=admin_ids, receptor=contacto))).order_by('-fecha_envio').first()
            if ultimo_m: 
                # Verificar si esta conversación específica tiene mensajes pendientes para admin
                tiene_pendientes = Mensaje.objects.filter(remitente=contacto, receptor_id__in=admin_ids, leido=False).exists()
                conversaciones.append({
                    'usuario': contacto, 
                    'ultimo_mensaje': ultimo_m,
                    'pendiente': tiene_pendientes
                })
        except Usuario.DoesNotExist: continue
    conversaciones.sort(key=lambda x: x['ultimo_mensaje'].fecha_envio, reverse=True)

    # 5. Obtener Ranking de la Vista SQL v_top_desarrolladores
    ranking = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT nombre, num_proyectos_completados, calificacion_promedio FROM v_top_desarrolladores LIMIT 5")
        ranking = cursor.fetchall()

    # 6. Obtener Indicadores de Salud Global (v_estadisticas_sistema)
    salud_global = None
    with connection.cursor() as cursor:
        cursor.execute("SELECT calificacion_promedio_global, proyectos_con_retraso FROM v_estadisticas_sistema")
        salud_global = cursor.fetchone()

    # 7. Obtener Lista Detallada de Alertas (v_proyectos_alerta_inactividad)
    alertas_retraso = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT titulo, empresa_nombre, desarrollador_nombre, dias_sin_avance FROM v_proyectos_alerta_inactividad")
        alertas_retraso = cursor.fetchall()

    # 8. Obtener Ranking de Empresas (v_reputacion_empresas)
    ranking_empresas = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT nombre_usuario, nombre_empresa, promedio_reputacion, total_evaluaciones FROM v_reputacion_empresas LIMIT 5")
        ranking_empresas = cursor.fetchall()

    # 9. Obtener Reseñas Recientes para Auditoría (valoraciones directas)
    resenas_auditoria = []
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT 
                u_evaluador.nombre as evaluador,
                u_evaluado.nombre as evaluado,
                v.puntuacion,
                v.comentario,
                v.rol_evaluador,
                v.fecha
            FROM valoraciones v
            JOIN usuarios u_evaluador ON v.rol_evaluador = (CASE WHEN v.rol_evaluador = 'empresa' THEN 'empresa' ELSE 'desarrollador' END) AND u_evaluador.id = (CASE WHEN v.rol_evaluador = 'empresa' THEN v.empresa_id ELSE v.desarrollador_id END)
            JOIN usuarios u_evaluado ON u_evaluado.id = (CASE WHEN v.rol_evaluador = 'empresa' THEN v.desarrollador_id ELSE v.empresa_id END)
            ORDER BY v.fecha DESC LIMIT 10
        """)
        # Simplificando la lógica de la consulta para evitar confusiones de JOIN
        cursor.execute("""
            SELECT 
                (SELECT nombre FROM usuarios WHERE id = (CASE WHEN rol_evaluador = 'empresa' THEN empresa_id ELSE desarrollador_id END)) as de,
                (SELECT nombre FROM usuarios WHERE id = (CASE WHEN rol_evaluador = 'empresa' THEN desarrollador_id ELSE empresa_id END)) as para,
                puntuacion, comentario, rol_evaluador
            FROM valoraciones ORDER BY fecha DESC LIMIT 10
        """)
        resenas_auditoria = cursor.fetchall()

    # 10. Notificaciones para el Admin (Historial)
    notificaciones_admin = Notificacion.objects.filter(usuario=request.user).order_by('-fecha')[:10]

    # --- MEJORA: Conteo de Notificaciones Pendientes (Universal) ---
    notificaciones_pendientes_count = 0
    with connection.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM v_notificaciones_pendientes WHERE usuario_id = %s", [request.user.id])
        notificaciones_pendientes_count = cursor.fetchone()[0]

    context = {
        'total_usuarios': total_usuarios, 'total_proyectos': total_proyectos,
        'total_devs': total_devs, 'total_empresas': total_empresas,
        'p_pub': p_pub, 'p_des': p_des, 'p_fin': p_fin, 'p_pen': p_pen,
        'post_pen': post_pen, 'promedio_global': promedio_global, 'p_ret': p_ret,
        'usuarios_todos': usuarios_lista, 'proyectos_todos': proyectos_lista,
        'logs_auditoria': logs, 'conversaciones': conversaciones, 
        'mensajes_no_leidos_admin': mensajes_no_leidos_admin,
        'ranking_talento': ranking,
        'ranking_empresas': ranking_empresas,
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
    return redirect('/admin/dashboard/?section=usersSection')

@login_required
def admin_toggle_proyecto(request, proyecto_id):
    if request.user.rol != 'administrador': return redirect('inicio')
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    proyecto.estado = 'inactivo' if proyecto.estado == 'publicado' else 'publicado'
    proyecto.save()
    messages.info(request, f"Proyecto actualizado.")
    return redirect('/admin/dashboard/?section=projectsSection')

@login_required
def editar_perfil(request):
    if request.user.rol == 'empresa':
        perfil, _ = PerfilEmpresa.objects.get_or_create(usuario=request.user)
        form = PerfilEmpresaForm(request.POST or None, instance=perfil)
        redirect_to = 'dashboard_empresa'
    elif request.user.rol == 'desarrollador':
        perfil, _ = PerfilDesarrollador.objects.get_or_create(usuario=request.user)
        form = PerfilDesarrolladorForm(request.POST or None, instance=perfil)
        redirect_to = 'dashboard_desarrollador'
    else: return redirect('inicio')

    if request.method == 'POST' and form.is_valid():
        form.save()
        messages.success(request, "Perfil actualizado")
        return redirect(redirect_to)
    return render(request, 'usuarios/editar_perfil.html', {'form': form})

@csrf_exempt
def api_usuarios(request):
    usuarios = list(Usuario.objects.values('id', 'username', 'email', 'rol'))
    return JsonResponse(usuarios, safe=False)

def api_usuario_detalle(request, usuario_id):
    user = get_object_or_404(Usuario, id=usuario_id)
    return JsonResponse({'id': user.id, 'username': user.username, 'email': user.email, 'rol': user.rol})

@csrf_exempt
def api_crear_usuario(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            user = Usuario.objects.create_user(
                username=data['username'], 
                email=data['email'], 
                password=data['password'], 
                rol=data.get('rol', 'desarrollador')
            )
            return JsonResponse({'id': user.id, 'status': 'created'}, status=201)
        except (json.JSONDecodeError, KeyError) as e:
            return JsonResponse({'error': f'Invalid JSON or missing fields: {str(e)}'}, status=400)

@csrf_exempt
def api_actualizar_usuario(request, usuario_id):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            user = get_object_or_404(Usuario, id=usuario_id)
            user.email = data.get('email', user.email)
            user.save()
            return JsonResponse({'status': 'updated'})
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)

@csrf_exempt
def api_eliminar_usuario(request, usuario_id):
    if request.method == 'DELETE':
        user = get_object_or_404(Usuario, id=usuario_id)
        user.delete()
        return JsonResponse({'status': 'deleted'})
