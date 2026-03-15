from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib import messages
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import make_password
from .forms import RegistroUsuarioForm
from .models import Usuario, PerfilEmpresa, PerfilDesarrollador
import json

# ===== PÁGINAS PÚBLICAS =====
def inicio(request):
    return render(request, 'publico/index.html')

def login_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        rol_seleccionado = request.POST.get('rol_seleccionado')
        
        print(f"Intentando login: {username} - Rol seleccionado: {rol_seleccionado}")
        
        user = authenticate(request, username=username, password=password)
        
        if user is not None:
            print(f"Usuario autenticado: {user.username} - Rol real: {user.rol}")
            
            if user.rol == rol_seleccionado:
                login(request, user)
                messages.success(request, f'Bienvenido {user.username}')
                
                if user.rol == 'empresa':
                    return redirect('dashboard_empresa')
                elif user.rol == 'desarrollador':
                    return redirect('dashboard_desarrollador')
                elif user.rol == 'administrador':
                    return redirect('dashboard_admin')
                else:
                    return redirect('inicio')
            else:
                messages.error(request, f'El rol seleccionado ({rol_seleccionado}) no coincide con tu rol real ({user.rol})')
        else:
            messages.error(request, 'Usuario o contraseña incorrectos')
    
    return render(request, 'publico/inicio_sesion.html')

def registro_view(request):
    if request.method == 'POST':
        form = RegistroUsuarioForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            messages.success(request, 'Registro exitoso!')
            
            if user.rol == 'empresa':
                return redirect('dashboard_empresa')
            elif user.rol == 'desarrollador':
                return redirect('dashboard_desarrollador')
            elif user.rol == 'administrador':
                return redirect('dashboard_admin')
            else:
                return redirect('inicio')
        else:
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f"{error}")
    else:
        form = RegistroUsuarioForm()
    
    return render(request, 'publico/registro.html', {'form': form})

def recuperar_view(request):
    return render(request, 'publico/recuperarcon.html')

# ===== DASHBOARDS POR ROL =====
def dashboard_empresa(request):
    return render(request, 'empresa/empresa.html')

def dashboard_desarrollador(request):
    return render(request, 'Desarrollador/Desarrollador.html')

def dashboard_admin(request):
    return render(request, 'administrador/Administrador.html')

# ===== API PARA EL CRUD DE ADMIN =====

def api_usuarios(request):
    """Listar todos los usuarios"""
    usuarios = Usuario.objects.all().values(
        'id', 'username', 'email', 'rol', 'cedula', 'date_joined'
    )
    return JsonResponse(list(usuarios), safe=False)

def api_usuario_detalle(request, usuario_id):
    """Obtener un usuario específico"""
    try:
        usuario = Usuario.objects.get(id=usuario_id)
        data = {
            'id': usuario.id,
            'username': usuario.username,
            'email': usuario.email,
            'rol': usuario.rol,
            'cedula': usuario.cedula,
        }
        return JsonResponse(data)
    except Usuario.DoesNotExist:
        return JsonResponse({'error': 'Usuario no encontrado'}, status=404)

@csrf_exempt
def api_crear_usuario(request):
    """Crear un nuevo usuario"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            
            # Crear usuario
            user = Usuario.objects.create_user(
                username=data['username'],
                email=data['email'],
                password=data.get('password', 'temporal123'),
                cedula=data.get('cedula', '')
            )
            user.rol = data['rol']
            user.save()
            
            # Crear perfil según rol
            if data['rol'] == 'empresa':
                PerfilEmpresa.objects.create(usuario=user)
            elif data['rol'] == 'desarrollador':
                PerfilDesarrollador.objects.create(usuario=user)
            
            return JsonResponse({'success': True, 'id': user.id})
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=400)
    
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@csrf_exempt
def api_actualizar_usuario(request, usuario_id):
    """Actualizar un usuario existente"""
    if request.method == 'PUT':
        try:
            usuario = Usuario.objects.get(id=usuario_id)
            data = json.loads(request.body)
            
            usuario.username = data.get('username', usuario.username)
            usuario.email = data.get('email', usuario.email)
            usuario.rol = data.get('rol', usuario.rol)
            usuario.cedula = data.get('cedula', usuario.cedula)
            
            if 'password' in data and data['password']:
                usuario.password = make_password(data['password'])
            
            usuario.save()
            return JsonResponse({'success': True})
        except Usuario.DoesNotExist:
            return JsonResponse({'error': 'Usuario no encontrado'}, status=404)
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=400)
    
    return JsonResponse({'error': 'Método no permitido'}, status=405)

@csrf_exempt
def api_eliminar_usuario(request, usuario_id):
    """Eliminar un usuario"""
    if request.method == 'DELETE':
        try:
            usuario = Usuario.objects.get(id=usuario_id)
            usuario.delete()
            return JsonResponse({'success': True})
        except Usuario.DoesNotExist:
            return JsonResponse({'error': 'Usuario no encontrado'}, status=404)
        except Exception as e:
            return JsonResponse({'success': False, 'error': str(e)}, status=400)
    
    return JsonResponse({'error': 'Método no permitido'}, status=405)