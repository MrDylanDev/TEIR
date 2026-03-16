from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Mensaje
from usuarios.models import Usuario
from proyectos.models import Proyecto
from notificaciones.models import Notificacion

@login_required
def mensajeria_inbox(request):
    """Ver bandeja de entrada"""
    mensajes_recibidos = Mensaje.objects.filter(receptor=request.user, archivado=False).order_by('-fecha_envio')
    return render(request, 'mensajes/inbox.html', {'mensajes': mensajes_recibidos})

@login_required
def mensajeria_sent(request):
    mensajes_enviados = Mensaje.objects.filter(remitente=request.user).order_by('-fecha_envio')
    return render(request, 'mensajes/sent.html', {'mensajes': mensajes_enviados})

@login_required
def ver_mensaje(request, mensaje_id):
    """Ver el detalle de un mensaje y marcarlo como leído"""
    mensaje = get_object_or_404(Mensaje, id=mensaje_id)
    
    # Solo el remitente o el receptor pueden ver el mensaje
    if mensaje.remitente != request.user and mensaje.receptor != request.user:
        messages.error(request, "Acceso denegado.")
        return redirect('mensajeria_inbox')
    
    if mensaje.receptor == request.user and not mensaje.leido:
        mensaje.leido = True
        mensaje.save()
        
    return render(request, 'mensajes/detalle.html', {'mensaje': mensaje})

@login_required
def enviar_mensaje(request):
    """Redactar y enviar un mensaje"""
    # Para el formulario, necesitamos saber a quién podemos escribir
    # Por ahora permitiremos escribir a cualquier usuario, pero se podría filtrar por proyectos
    usuarios = Usuario.objects.exclude(id=request.user.id)
    proyectos = Proyecto.objects.all()
    
    if request.method == 'POST':
        receptor_id = request.POST.get('receptor')
        asunto = request.POST.get('asunto')
        cuerpo = request.POST.get('cuerpo')
        proyecto_id = request.POST.get('proyecto')
        
        receptor = get_object_or_404(Usuario, id=receptor_id)
        proyecto = get_object_or_404(Proyecto, id=proyecto_id) if proyecto_id else None
        
        try:
            Mensaje.objects.create(
                remitente=request.user,
                receptor=receptor,
                asunto=asunto,
                cuerpo=cuerpo,
                proyecto=proyecto
            )
            
            # Notificación al receptor
            Notificacion.objects.create(
                usuario=receptor,
                tipo='mensaje',
                mensaje=f"Has recibido un nuevo mensaje de {request.user.username}: {asunto}"
            )
            
            messages.success(request, "Mensaje enviado correctamente.")
            return redirect('mensajeria_sent')
        except Exception as e:
            messages.error(request, f"Error al enviar mensaje: {e}")
            
    # Si viene con un 'para' en la URL (ej: responder)
    para_id = request.GET.get('para')
    proyecto_pre = request.GET.get('proyecto')
    
    return render(request, 'mensajes/redactar.html', {
        'usuarios': usuarios, 
        'proyectos': proyectos,
        'para_id': int(para_id) if para_id else None,
        'proyecto_pre': int(proyecto_pre) if proyecto_pre else None
    })
