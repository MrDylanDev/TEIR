from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import make_password
from .forms import RegistroUsuarioForm, PerfilEmpresaForm, PerfilDesarrolladorForm
from .models import Usuario, PerfilEmpresa, PerfilDesarrollador
from proyectos.models import Proyecto
try:
    from postulaciones.models import Postulacion
    from contrataciones.models import Contratacion
    from notificaciones.models import Notificacion
except ImportError:
    Postulacion = None
    Contratacion = None
    Notificacion = None

import json

def inicio(request):
    casos_exito = Proyecto.objects.filter(estado='finalizado').order_by('-fecha_aprobacion')[:4]
    return render(request, 'publico/index.html', {'casos_exito': casos_exito})

def login_view(request):
    if request.user.is_authenticated:
        if request.user.rol == 'empresa': return redirect('dashboard_empresa')
        if request.user.rol == 'desarrollador': return redirect('dashboard_desarrollador')
        if request.user.rol == 'administrador': return redirect('dashboard_admin')

    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        rol_seleccionado = request.POST.get('rol_seleccionado')
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            if user.rol == rol_seleccionado:
                login(request, user)
                messages.success(request, f'Bienvenido {user.username}')
                if user.rol == 'empresa': return redirect('dashboard_empresa')
                elif user.rol == 'desarrollador': return redirect('dashboard_desarrollador')
                elif user.rol == 'administrador': return redirect('dashboard_admin')
            else:
                messages.error(request, f'El rol seleccionado no coincide con tu perfil.')
        else:
            messages.error(request, 'Usuario o contraseña incorrectos.')
    
    return render(request, 'publico/inicio_sesion.html')

def registro_view(request):
    if request.user.is_authenticated:
        return redirect('inicio')

    if request.method == 'POST':
        form = RegistroUsuarioForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            messages.success(request, '¡Registro exitoso!')
            if user.rol == 'empresa': return redirect('dashboard_empresa')
            return redirect('dashboard_desarrollador')
        else:
            for error in form.non_field_errors():
                messages.error(request, error)
    else:
        form = RegistroUsuarioForm()
    
    return render(request, 'publico/registro.html', {'form': form})

def recuperar_view(request):
    return render(request, 'publico/recuperarcon.html')

def logout_view(request):
    logout(request)
    messages.info(request, "Has cerrado sesión correctamente.")
    return redirect('inicio')

@login_required
def dashboard_empresa(request):
    if request.user.rol != 'empresa': return redirect('inicio')
    
    perfil, _ = PerfilEmpresa.objects.get_or_create(usuario=request.user)
    context = {
        'total_proyectos': Proyecto.objects.filter(empresa=request.user).count(),
        'proyectos_activos': Proyecto.objects.filter(empresa=request.user, estado='en_desarrollo').count(),
        'total_postulaciones': Postulacion.objects.filter(proyecto__empresa=request.user).count() if Postulacion else 0,
        'total_contratados': Contratacion.objects.filter(empresa=request.user, estado='activa').count() if Contratacion else 0,
        'notificaciones': Notificacion.objects.filter(usuario=request.user).order_by('-fecha')[:5] if Notificacion else [],
        'mis_proyectos': Proyecto.objects.filter(empresa=request.user).order_by('-fecha_publicacion'),
        'perfil': perfil
    }
    return render(request, 'empresa/empresa.html', context)

@login_required
def dashboard_desarrollador(request):
    if request.user.rol != 'desarrollador': return redirect('inicio')
    
    favoritos = []
    try:
        from favoritos.models import Favorito
        favoritos = Favorito.objects.filter(desarrollador=request.user).select_related('proyecto')[:5]
    except ImportError:
        pass

    perfil, _ = PerfilDesarrollador.objects.get_or_create(usuario=request.user)
    
    context = {
        'proyectos_activos_count': Contratacion.objects.filter(desarrollador=request.user, estado='activa').count() if Contratacion else 0,
        'proyectos_completados': Contratacion.objects.filter(desarrollador=request.user, estado='finalizada').count() if Contratacion else 0,
        'nuevos_proyectos': Proyecto.objects.filter(estado='publicado').count(),
        'notificaciones': Notificacion.objects.filter(usuario=request.user).order_by('-fecha')[:5] if Notificacion else [],
        'mis_proyectos_activos': Contratacion.objects.filter(desarrollador=request.user, estado='activa') if Contratacion else [],
        'perfil': perfil,
        'favoritos': favoritos
    }
    return render(request, 'Desarrollador/Desarrollador.html', context)

@login_required
def dashboard_admin(request):
    if request.user.rol != 'administrador': return redirect('inicio')
    
    context = {
        'total_usuarios': Usuario.objects.count(),
        'total_proyectos': Proyecto.objects.count(),
        'proyectos_pendientes': Proyecto.objects.filter(estado='pendiente_aprobacion').count(),
        'proyectos': Proyecto.objects.all().order_by('-fecha_publicacion')
    }
    return render(request, 'administrador/Administrador.html', context)

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
    else:
        return redirect('inicio')

    if request.method == 'POST' and form.is_valid():
        form.save()
        messages.success(request, "Perfil actualizado correctamente.")
        return redirect(redirect_to)
    
    return render(request, 'usuarios/editar_perfil.html', {'form': form})

@login_required
def api_usuarios(request):
    if request.user.rol != 'administrador': return JsonResponse({'error': 'No autorizado'}, status=403)
    usuarios = Usuario.objects.all().values('id', 'username', 'email', 'rol', 'cedula', 'date_joined')
    return JsonResponse(list(usuarios), safe=False)

@login_required
def api_usuario_detalle(request, usuario_id):
    if request.user.rol != 'administrador': return JsonResponse({'error': 'No autorizado'}, status=403)
    usuario = get_object_or_404(Usuario, id=usuario_id)
    return JsonResponse({'id': usuario.id, 'username': usuario.username, 'email': usuario.email, 'rol': usuario.rol, 'cedula': usuario.cedula})

@login_required
def api_crear_usuario(request):
    if request.user.rol != 'administrador': return JsonResponse({'error': 'No autorizado'}, status=403)
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            user = Usuario.objects.create_user(username=data['username'], email=data['email'], password=data.get('password', 'Sena1234'), cedula=data.get('cedula', ''), nombre=data.get('nombre', data['username']))
            user.rol = data['rol']
            user.save()
            return JsonResponse({'success': True, 'id': user.id})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=400)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@login_required
def api_actualizar_usuario(request, usuario_id):
    if request.user.rol != 'administrador': return JsonResponse({'error': 'No autorizado'}, status=403)
    if request.method == 'PUT':
        try:
            usuario = Usuario.objects.get(id=usuario_id)
            data = json.loads(request.body)
            usuario.username = data.get('username', usuario.username)
            usuario.nombre = data.get('nombre', data.get('username', usuario.nombre))
            usuario.email = data.get('email', usuario.email)
            usuario.rol = data.get('rol', usuario.rol)
            if 'password' in data and data['password']: usuario.password = make_password(data['password'])
            usuario.save()
            return JsonResponse({'success': True})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=400)
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@login_required
def api_eliminar_usuario(request, usuario_id):
    if request.user.rol != 'administrador': return JsonResponse({'error': 'No autorizado'}, status=403)
    if request.method == 'DELETE':
        try:
            Usuario.objects.get(id=usuario_id).delete()
            return JsonResponse({'success': True})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=400)
    return JsonResponse({'error': 'Método no permitido'}, status=405)
