from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.db.models import Q
from .models import Mensaje
from usuarios.models import Usuario
from usuarios.utils import get_admin_ids
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

        contenido = request.POST.get('cuerpo') or request.POST.get('contenido')
        if contenido:
            try:
                Mensaje.objects.create(
                    remitente=request.user,
                    receptor=None, # Mensaje grupal
                    titulo=f"Espacio de Trabajo: {proyecto.titulo}",
                    contenido=contenido,
                    proyecto=proyecto
                )
                return redirect('sala_chat_grupal', proyecto_id=proyecto_id)
            except Exception as e:
                messages.error(request, f"Error al enviar: {e}")

    # Lista de compañeros (Optimizado con JOIN inverso)
    companeros = Usuario.objects.filter(
        contrataciones_dev__proyecto=proyecto
    ).distinct()

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
    try:
        if int(receptor_id) == 0 and proyecto_id:
            return redirect('sala_chat_grupal', proyecto_id=proyecto_id)
    except (ValueError, TypeError):
        return redirect('inicio')

    receptor = get_object_or_404(Usuario, id=receptor_id)
    proyecto = get_object_or_404(Proyecto, id=proyecto_id) if proyecto_id else None

    admin_ids = get_admin_ids()

    # Filtro de participantes: Remitente -> Receptor O Receptor -> Remitente
    mensajes_chat = Mensaje.objects.filter(
        (Q(remitente=request.user, receptor=receptor) | Q(remitente=receptor, receptor=request.user))
    )

    # Aislmiento flexible por proyecto
    # Si hay proyecto, mostramos los de ese proyecto + los generales (sin proyecto)
    if proyecto:
        mensajes_chat = mensajes_chat.filter(Q(proyecto=proyecto) | Q(proyecto__isnull=True))
    else:
        # En chat general, solo mostramos los que no tienen proyecto asignado
        mensajes_chat = mensajes_chat.filter(proyecto__isnull=True)

    mensajes_chat = mensajes_chat.order_by('fecha_envio')
    
    # Marcar leídos solo de este contexto
    mensajes_chat.filter(receptor=request.user, leido=False).update(leido=True)

    if request.method == 'POST':
        # Bloquear envío si el proyecto está finalizado
        if proyecto and proyecto.estado == 'finalizado':
            messages.error(request, "No se pueden enviar mensajes a proyectos finalizados.")
            return redirect('sala_chat', receptor_id=receptor_id, proyecto_id=proyecto_id if proyecto_id else 0)

        contenido = request.POST.get('contenido')
        if contenido:
            try:
                Mensaje.objects.create(
                    remitente=request.user,
                    receptor=receptor,
                    titulo=f"Chat: {proyecto.titulo if proyecto else 'General'}",
                    contenido=contenido,
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
