from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import Mensaje
from usuarios.models import Usuario
from proyectos.models import Proyecto
from contrataciones.models import Contratacion

@login_required
def sala_chat_grupal(request, proyecto_id):
    """Espacio de Trabajo: Chat grupal para todos los involucrados en un proyecto"""
    proyecto = get_object_or_404(Proyecto, id=proyecto_id)
    
    # Verificar acceso: Empresa dueña o Desarrollador vinculado (activo o finalizado)
    es_empresa = (request.user.rol == 'empresa' and proyecto.empresa == request.user)
    es_desarrollador = Contratacion.objects.filter(proyecto=proyecto, desarrollador=request.user).exists()
    
    if not (es_empresa or es_desarrollador or request.user.rol == 'administrador'):
        messages.error(request, "No tienes acceso a este espacio de trabajo.")
        return redirect('inicio')

    # Mensajes grupales: receptor es NULL y están ligados a este proyecto
    mensajes_chat = Mensaje.objects.filter(proyecto=proyecto, receptor__isnull=True).order_by('fecha_envio')

    if request.method == 'POST':
        # Bloquear envío si el proyecto está finalizado
        if proyecto and proyecto.estado == 'finalizado':
            messages.error(request, "No se pueden enviar mensajes a proyectos finalizados.")
            return redirect('sala_chat_grupal', proyecto_id=proyecto.id)

        cuerpo = request.POST.get('cuerpo')
        if cuerpo:
            try:
                Mensaje.objects.create(
                    remitente=request.user,
                    receptor=None, # Mensaje grupal
                    asunto=f"Espacio de Trabajo: {proyecto.titulo}",
                    cuerpo=cuerpo,
                    proyecto=proyecto
                )
                return redirect('sala_chat_grupal', proyecto_id=proyecto_id)
            except Exception as e:
                messages.error(request, f"Error al enviar: {e}")

    # Lista de compañeros (todos los que estuvieron en el proyecto)
    companeros = Usuario.objects.filter(
        id__in=Contratacion.objects.filter(proyecto=proyecto).values_list('desarrollador_id', flat=True)
    )

    return render(request, 'mensajes/sala_chat.html', {
        'proyecto': proyecto,
        'mensajes_chat': mensajes_chat,
        'es_grupal': True,
        'companeros': companeros
    })

@login_required
def sala_chat(request, receptor_id, proyecto_id=None):
    """Vista de chat fluido unificada (Soporte Admin compartido y Chat Privado)"""
    # Si receptor_id es 0, redirigir al chat grupal si hay proyecto
    if int(receptor_id) == 0 and proyecto_id:
        return redirect('sala_chat_grupal', proyecto_id=proyecto_id)

    receptor = get_object_or_404(Usuario, id=receptor_id)
    proyecto = get_object_or_404(Proyecto, id=proyecto_id) if proyecto_id else None

    from django.db.models import Q

    
    admin_ids = Usuario.objects.filter(rol='administrador').values_list('id', flat=True)

    if request.user.rol == 'administrador' or receptor.rol == 'administrador':
        cliente_id = receptor_id if request.user.rol == 'administrador' else request.user.id
        mensajes_chat = Mensaje.objects.filter(
            (Q(remitente_id=cliente_id, receptor_id__in=admin_ids) | Q(remitente_id__in=admin_ids, receptor_id=cliente_id))
        )
    else:
        # Filtro base de participantes
        mensajes_chat = Mensaje.objects.filter(
            (Q(remitente=request.user, receptor=receptor) | Q(remitente=receptor, receptor=request.user))
        )

    # AISLAMIENTO POR PROYECTO
    # Si estamos en el contexto de un proyecto, solo mostramos mensajes de ESE proyecto.
    # Si no hay proyecto, mostramos solo mensajes generales (sin proyecto_id).
    if proyecto:
        mensajes_chat = mensajes_chat.filter(proyecto=proyecto)
    else:
        mensajes_chat = mensajes_chat.filter(proyecto__isnull=True)

    mensajes_chat = mensajes_chat.order_by('fecha_envio')
    
    # Marcar leídos solo de este contexto
    mensajes_chat.filter(receptor=request.user, leido=False).update(leido=True)

    if request.method == 'POST':
        # Bloquear envío si el proyecto está finalizado
        if proyecto and proyecto.estado == 'finalizado':
            messages.error(request, "No se pueden enviar mensajes a proyectos finalizados.")
            return redirect('sala_chat', receptor_id=receptor_id, proyecto_id=proyecto_id if proyecto_id else 0)

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
