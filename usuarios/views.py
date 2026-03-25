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
    casos_exito = Proyecto.objects.filter(estado='finalizado').order_by('-fecha_aprobacion')[:4]
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
    if request.user.rol != 'empresa': return redirect('inicio')
    perfil, _ = PerfilEmpresa.objects.get_or_create(usuario=request.user)
    mis_ofertas = Proyecto.objects.filter(empresa=request.user, estado='publicado').order_by('-fecha_publicacion')
    en_desarrollo = Contratacion.objects.filter(empresa=request.user, estado='activa').select_related('proyecto', 'desarrollador')
    historial = Proyecto.objects.filter(empresa=request.user, estado='finalizado').order_by('-fecha_aprobacion')
    postulaciones_pendientes = Postulacion.objects.filter(proyecto__empresa=request.user, estado='pendiente')
    
    # Soporte Admin Dinámico
    admin_instancia = Usuario.objects.filter(rol='administrador').first()
    admin_id = admin_instancia.id if admin_instancia else 1

    # Reputación Corporativa: Valoraciones de desarrolladores
    from proyectos.models import Valoracion
    valoraciones_dev = Valoracion.objects.filter(empresa=request.user, rol_evaluador='desarrollador').select_related('desarrollador', 'proyecto')
    promedio_empresa = valoraciones_dev.aggregate(Avg('puntuacion'))['puntuacion__avg'] or 0

    context = {
        'total_proyectos': Proyecto.objects.filter(empresa=request.user).count(),
        'proyectos_activos': en_desarrollo.count(),
        'total_postulaciones': postulaciones_pendientes.count(),
        'mis_ofertas': mis_ofertas,
        'en_desarrollo': en_desarrollo,
        'historial': historial,
        'valoraciones_recibidas': valoraciones_dev,
        'promedio_empresa': round(promedio_empresa, 1),
        'postulaciones_pendientes': postulaciones_pendientes,
        'notificaciones': Notificacion.objects.filter(usuario=request.user).order_by('-fecha')[:5],
        'perfil': perfil,
        'mis_contrataciones': en_desarrollo,
        'admin_id': admin_id
    }
    return render(request, 'empresa/empresa.html', context)

@login_required
def dashboard_desarrollador(request):
    if request.user.rol != 'desarrollador': return redirect('inicio')
    mis_postulaciones = Postulacion.objects.filter(desarrollador=request.user).select_related('proyecto')
    mis_favoritos = Favorito.objects.filter(desarrollador=request.user).select_related('proyecto')
    mis_proyectos_activos = Contratacion.objects.filter(desarrollador=request.user, estado='activa').select_related('proyecto', 'empresa')
    # 3. Portafolio: Proyectos finalizados con sus valoraciones reales
    from proyectos.models import Valoracion
    mis_proyectos_finalizados = Contratacion.objects.filter(
        desarrollador=request.user, 
        estado='finalizada'
    ).select_related('proyecto', 'empresa')
    
    # Soporte Admin Dinámico
    admin_instancia = Usuario.objects.filter(rol='administrador').first()
    admin_id = admin_instancia.id if admin_instancia else 1

    # Enriquecer los contratos con su valoración correspondiente (la que hizo la empresa)
    for contrato in mis_proyectos_finalizados:
        contrato.valoracion = Valoracion.objects.filter(
            proyecto=contrato.proyecto, 
            desarrollador=request.user,
            rol_evaluador='empresa' 
        ).first()

    perfil, _ = PerfilDesarrollador.objects.get_or_create(usuario=request.user)
    context = {
        'proyectos_activos_count': mis_proyectos_activos.count(),
        'proyectos_completados': mis_proyectos_finalizados.count(),
        'nuevos_proyectos': Proyecto.objects.filter(estado='publicado').count(),
        'notificaciones': Notificacion.objects.filter(usuario=request.user).order_by('-fecha')[:5],
        'mis_proyectos_activos': mis_proyectos_activos,
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
    total_usuarios = Usuario.objects.count()
    total_proyectos = Proyecto.objects.count()
    total_devs = Usuario.objects.filter(rol='desarrollador').count()
    total_empresas = Usuario.objects.filter(rol='empresa').count()
    usuarios_lista = Usuario.objects.all().order_by('-date_joined')
    proyectos_lista = Proyecto.objects.all().select_related('empresa').order_by('-fecha_publicacion')
    
    logs = []
    with connection.cursor() as cursor:
        cursor.execute("SELECT l.id, u.username, l.accion, l.tabla_afectada, l.fecha_hora FROM logs_auditoria l JOIN usuarios u ON l.usuario_id = u.id ORDER BY l.fecha_hora DESC LIMIT 20")
        logs = cursor.fetchall()

    admin_ids = Usuario.objects.filter(rol='administrador').values_list('id', flat=True)
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
            if ultimo_m: conversaciones.append({'usuario': contacto, 'ultimo_mensaje': ultimo_m})
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

    context = {
        'total_usuarios': total_usuarios, 'total_proyectos': total_proyectos,
        'total_devs': total_devs, 'total_empresas': total_empresas,
        'usuarios_todos': usuarios_lista, 'proyectos_todos': proyectos_lista,
        'logs_auditoria': logs, 'conversaciones': conversaciones, 
        'ranking_talento': ranking,
        'salud_global': salud_global,
        'alertas_retraso': alertas_retraso 
    }

    return render(request, 'administrador/Administrador.html', context)

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
