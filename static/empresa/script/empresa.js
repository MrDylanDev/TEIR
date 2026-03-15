// ============================
// NAVEGACIÓN ENTRE VISTAS
// ============================

document.addEventListener("DOMContentLoaded", function () {

  const botones = document.querySelectorAll(".sidebar li");
  const vistas = document.querySelectorAll(".vista");

  botones.forEach(boton => {
    boton.addEventListener("click", () => {

      botones.forEach(b => b.classList.remove("activo"));
      vistas.forEach(v => v.classList.remove("activa"));

      boton.classList.add("activo");

      const vista = boton.getAttribute("data-vista");
      document.getElementById(vista).classList.add("activa");
    });
  });

  cargarDashboard();
});

// ============================
// DATOS SIMULADOS
// ============================

let proyectos = [];
let postulaciones = [
  { id: 1 },
  { id: 2 },
  { id: 3 },
  { id: 4 }
];

let contratados = [
  { id: 1 },
  { id: 2 }
];

// ============================
// DASHBOARD
// ============================

function cargarDashboard() {

  document.getElementById("totalProyectos").textContent = proyectos.length;

  const activos = proyectos.filter(p => p.estado === "activo").length;
  document.getElementById("proyectosActivos").textContent = activos;

  document.getElementById("totalPostulaciones").textContent = postulaciones.length;
  document.getElementById("totalContratados").textContent = contratados.length;

  document.getElementById("listaActividad").innerHTML = `
    <li>Nuevo proyecto publicado</li>
    <li>2 postulaciones recibidas</li>
  `;

  document.getElementById("listaNotificaciones").innerHTML = `
    <li>Tienes ${postulaciones.length} postulaciones pendientes</li>
  `;
}

// ============================
// MODAL
// ============================

function abrirModal() {
  document.getElementById("modalProyecto").style.display = "flex";
}

function cerrarModal() {
  document.getElementById("modalProyecto").style.display = "none";
}

// ============================
// CRUD PROYECTOS
// ============================

function guardarProyecto() {

  const titulo = document.getElementById("tituloProyecto").value;
  const descripcion = document.getElementById("descripcionProyecto").value;
  const estado = document.getElementById("estadoProyecto").value;

  if (!titulo || !descripcion) {
    alert("Completa todos los campos");
    return;
  }

  const nuevoProyecto = {
    id: Date.now(),
    titulo,
    descripcion,
    estado
  };

  proyectos.push(nuevoProyecto);

  renderProyectos();
  cargarDashboard();
  cerrarModal();

  document.getElementById("tituloProyecto").value = "";
  document.getElementById("descripcionProyecto").value = "";
}

function eliminarProyecto(id) {
  proyectos = proyectos.filter(p => p.id !== id);
  renderProyectos();
  cargarDashboard();
}

function renderProyectos() {

  const contenedor = document.getElementById("listaProyectos");

  if (proyectos.length === 0) {
    contenedor.innerHTML = `<p>No hay proyectos publicados.</p>`;
    return;
  }

  contenedor.innerHTML = proyectos.map(p => `
    <div class="card-proyecto">
      <h3>${p.titulo}</h3>
      <p>${p.descripcion}</p>
      <span class="estado ${p.estado}">
        ${p.estado.toUpperCase()}
      </span>
      <br><br>
      <button class="btn-secundario"
        onclick="eliminarProyecto(${p.id})">
        Eliminar
      </button>
    </div>
  `).join("");
}