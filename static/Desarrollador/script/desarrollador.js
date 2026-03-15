// ===============================
// ESTADO GLOBAL CON LOCALSTORAGE
// ===============================

let mensajes = JSON.parse(localStorage.getItem("mensajes")) || [];
let proyectos = JSON.parse(localStorage.getItem("proyectos")) || [];
let preferencias = JSON.parse(localStorage.getItem("preferencias")) || {
    notificaciones: true
};
let usuario = JSON.parse(localStorage.getItem("usuario")) || {
    password: "1234",
    foto: ""
};

// ===============================
// NAVEGACIÓN ENTRE SECCIONES
// ===============================

function mostrarSeccion(id) {
    document.querySelectorAll(".seccion").forEach(sec => {
        sec.classList.remove("activa");
    });

    document.getElementById(id).classList.add("activa");
}

// ===============================
// GUARDAR DATOS
// ===============================

function guardarTodo() {
    localStorage.setItem("mensajes", JSON.stringify(mensajes));
    localStorage.setItem("proyectos", JSON.stringify(proyectos));
    localStorage.setItem("preferencias", JSON.stringify(preferencias));
    localStorage.setItem("usuario", JSON.stringify(usuario));
    actualizarStats();
}

// ===============================
// MENSAJES
// ===============================

function mostrarFormularioMensaje() {
    document.getElementById("form-mensaje").classList.toggle("hidden");
}

function enviarMensaje() {
    const destinatario = document.getElementById("destinatario").value;
    const contenido = document.getElementById("contenidoMensaje").value;

    if (!destinatario || !contenido) return;

    mensajes.push({
        id: Date.now(),
        destinatario,
        contenido,
        tipo: "enviado"
    });

    // Simulación de mensaje recibido automático
    mensajes.push({
        id: Date.now() + 1,
        destinatario: "Yo",
        contenido: "Respuesta automática de " + destinatario,
        tipo: "recibido"
    });

    guardarTodo();
    renderMensajes();
}

function archivarMensaje(id) {
    const msg = mensajes.find(m => m.id === id);
    if (msg) msg.tipo = "archivado";
    guardarTodo();
    renderMensajes();
}

function eliminarMensaje(id) {
    mensajes = mensajes.filter(m => m.id !== id);
    guardarTodo();
    renderMensajes();
}

function renderMensajes() {
    const bandeja = document.getElementById("lista-bandeja");
    const enviados = document.getElementById("lista-enviados");
    const archivados = document.getElementById("lista-archivados");

    bandeja.innerHTML = "";
    enviados.innerHTML = "";
    archivados.innerHTML = "";

    mensajes.forEach(msg => {
        const div = document.createElement("div");
        div.innerHTML = `
            <strong>${msg.destinatario}</strong>
            <p>${msg.contenido}</p>
            <button onclick="archivarMensaje(${msg.id})">Archivar</button>
            <button onclick="eliminarMensaje(${msg.id})">Eliminar</button>
        `;

        if (msg.tipo === "recibido") bandeja.appendChild(div);
        if (msg.tipo === "enviado") enviados.appendChild(div);
        if (msg.tipo === "archivado") archivados.appendChild(div);
    });
}

// ===============================
// PROYECTOS
// ===============================

function mostrarFormularioProyecto() {
    document.getElementById("form-proyecto").classList.toggle("hidden");
}

function crearProyecto() {
    const nombre = document.getElementById("nombreProyecto").value;
    const desc = document.getElementById("descProyecto").value;

    if (!nombre || !desc) return;

    proyectos.push({
        id: Date.now(),
        nombre,
        desc,
        estado: "nuevo",
        favorito: false
    });

    guardarTodo();
    renderProyectos();
}

function cambiarEstado(id, nuevoEstado) {
    const proyecto = proyectos.find(p => p.id === id);
    if (proyecto) proyecto.estado = nuevoEstado;
    guardarTodo();
    renderProyectos();
}

function toggleFavorito(id) {
    const proyecto = proyectos.find(p => p.id === id);
    if (proyecto) proyecto.favorito = !proyecto.favorito;
    guardarTodo();
    renderProyectos();
}

function eliminarProyecto(id) {
    proyectos = proyectos.filter(p => p.id !== id);
    guardarTodo();
    renderProyectos();
}

function renderProyectos() {
    const nuevos = document.getElementById("lista-nuevos");
    const activos = document.getElementById("lista-activos");
    const completados = document.getElementById("lista-completados");
    const favoritos = document.getElementById("lista-favoritos");

    nuevos.innerHTML = "";
    activos.innerHTML = "";
    completados.innerHTML = "";
    favoritos.innerHTML = "";

    proyectos.forEach(p => {
        const div = document.createElement("div");
        div.innerHTML = `
            <strong>${p.nombre}</strong>
            <p>${p.desc}</p>
            <button onclick="cambiarEstado(${p.id}, 'activo')">Activo</button>
            <button onclick="cambiarEstado(${p.id}, 'completado')">Completar</button>
            <button onclick="toggleFavorito(${p.id})">Favorito</button>
            <button onclick="eliminarProyecto(${p.id})">Eliminar</button>
        `;

        if (p.estado === "nuevo") nuevos.appendChild(div);
        if (p.estado === "activo") activos.appendChild(div);
        if (p.estado === "completado") completados.appendChild(div);
        if (p.favorito) favoritos.appendChild(div.cloneNode(true));
    });
}

// ===============================
// SEGURIDAD
// ===============================

function cambiarPassword() {
    const actual = document.getElementById("passwordActual").value;
    const nueva = document.getElementById("passwordNueva").value;
    const confirmar = document.getElementById("passwordConfirmar").value;
    const msg = document.getElementById("seguridadMsg");

    if (actual !== usuario.password) {
        msg.textContent = "Contraseña actual incorrecta";
        return;
    }

    if (nueva !== confirmar) {
        msg.textContent = "Las contraseñas no coinciden";
        return;
    }

    usuario.password = nueva;
    guardarTodo();
    msg.textContent = "Contraseña actualizada correctamente";
}

// ===============================
// PERFIL
// ===============================

const inputFoto = document.getElementById("inputFoto");
const fotoPerfil = document.getElementById("fotoPerfil");

if (usuario.foto) fotoPerfil.src = usuario.foto;

inputFoto.addEventListener("change", function(e) {
    const file = e.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = function() {
        usuario.foto = reader.result;
        guardarTodo();
        fotoPerfil.src = reader.result;
    };
    reader.readAsDataURL(file);
});

function actualizarPerfil() {
    const completadosCount = proyectos.filter(p => p.estado === "completado").length;
    const activosCount = proyectos.filter(p => p.estado === "activo").length;

    document.getElementById("perfilStats").textContent =
        `Proyectos activos: ${activosCount} | Completados: ${completadosCount}`;
}

// ===============================
// STATS DASHBOARD
// ===============================

function actualizarStats() {
    document.getElementById("stat-recibidos").textContent =
        mensajes.filter(m => m.tipo === "recibido").length;

    document.getElementById("stat-activos").textContent =
        proyectos.filter(p => p.estado === "activo").length;

    document.getElementById("stat-completados").textContent =
        proyectos.filter(p => p.estado === "completado").length;

    document.getElementById("stat-favoritos").textContent =
        proyectos.filter(p => p.favorito).length;

    actualizarPerfil();
}

// ===============================
// INICIALIZAR
// ===============================

document.getElementById("notificacionesToggle").checked = preferencias.notificaciones;

document.getElementById("notificacionesToggle").addEventListener("change", function() {
    preferencias.notificaciones = this.checked;
    guardarTodo();
});

renderMensajes();
renderProyectos();
actualizarStats();
// ===============================
// PERFIL AVANZADO
// ===============================

usuario.habilidades = usuario.habilidades || ["HTML", "CSS", "JavaScript"];
usuario.enlaces = usuario.enlaces || [];

function renderPerfilAvanzado() {

    // Stats
    const activos = proyectos.filter(p => p.estado === "activo").length;
    const completados = proyectos.filter(p => p.estado === "completado").length;
    const favoritos = proyectos.filter(p => p.favorito).length;

    document.getElementById("statPerfilActivos").textContent = activos;
    document.getElementById("statPerfilCompletados").textContent = completados;
    document.getElementById("statPerfilFavoritos").textContent = favoritos;

    // Habilidades
    const listaHab = document.getElementById("listaHabilidades");
    listaHab.innerHTML = "";
    usuario.habilidades.forEach(hab => {
        const span = document.createElement("span");
        span.textContent = hab;
        listaHab.appendChild(span);
    });

    // Enlaces
    const listaEnlaces = document.getElementById("listaEnlacesPerfil");
    listaEnlaces.innerHTML = "";
    usuario.enlaces.forEach(link => {
        const li = document.createElement("li");
        li.innerHTML = `<a href="${link}" target="_blank">${link}</a>`;
        listaEnlaces.appendChild(li);
    });

    // Proyectos recientes
    const recientes = document.getElementById("perfilProyectosRecientes");
    recientes.innerHTML = "";

    proyectos.slice(-3).forEach(p => {
        const div = document.createElement("div");
        div.style.marginBottom = "10px";
        div.innerHTML = `<strong>${p.nombre}</strong> - ${p.estado}`;
        recientes.appendChild(div);
    });
}

function agregarHabilidad() {
    const input = document.getElementById("nuevaHabilidad");
    if (!input.value) return;

    usuario.habilidades.push(input.value);
    input.value = "";
    guardarTodo();
    renderPerfilAvanzado();
}

function agregarEnlacePerfil() {
    const input = document.getElementById("nuevoEnlacePerfil");
    if (!input.value) return;

    usuario.enlaces.push(input.value);
    input.value = "";
    guardarTodo();
    renderPerfilAvanzado();
}

// Sobrescribimos actualizarPerfil para incluir perfil premium
function actualizarPerfil() {
    renderPerfilAvanzado();
}

// Ejecutar al iniciar
renderPerfilAvanzado();