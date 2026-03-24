from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Mensaje
from usuarios.models import Usuario
from proyectos.models import Proyecto

@login_required
def sala_chat(request, receptor_id, proyecto_id=None):
    """Vista de chat fluido unificada (Soporte Admin compartido y Chat Privado)"""
    receptor = get_object_or_404(Usuario, id=receptor_id)
    proyecto = get_object_or_404(Proyecto, id=proyecto_id) if proyecto_id else None

    from django.db.models import Q

    # Lógica de Soporte: Si uno de los dos es ADMIN, el chat es con "Soporte"
    admin_ids = Usuario.objects.filter(rol='administrador').values_list('id', flat=True)

    if request.user.rol == 'administrador' or receptor.rol == 'administrador':
        cliente_id = receptor_id if request.user.rol == 'administrador' else request.user.id
        mensajes_chat = Mensaje.objects.filter(
            (Q(remitente_id=cliente_id, receptor_id__in=admin_ids) | Q(remitente_id__in=admin_ids, receptor_id=cliente_id))
        ).order_by('fecha_envio')
    else:
        mensajes_chat = Mensaje.objects.filter(
            (Q(remitente=request.user, receptor=receptor) | Q(remitente=receptor, receptor=request.user))
        ).order_by('fecha_envio')

    if proyecto:
        mensajes_chat = mensajes_chat.filter(proyecto=proyecto)

    # Marcar leídos
    mensajes_chat.filter(receptor=request.user, leido=False).update(leido=True)

    if request.method == 'POST':
        cuerpo = request.POST.get('cuerpo')
        if cuerpo:
            try:
                Mensaje.objects.create(
                    remitente=request.user,
                    receptor=receptor,
                    asunto=f"Chat: {proyecto.titulo if proyecto else 'General'}",
                    cuerpo=cuerpo,
                    proyecto=proyecto
                )
                return redirect('sala_chat', receptor_id=receptor_id, proyecto_id=proyecto_id if proyecto_id else 0)
            except Exception as e:
                messages.error(request, f"Error al enviar: {e}")
                
    return render(request, 'mensajes/sala_chat.html', {
        'receptor': receptor,
        'proyecto': proyecto,
        'mensajes_chat': mensajes_chat
    })
