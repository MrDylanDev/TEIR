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
      if(vista) {
          document.getElementById(vista).classList.add("activa");
      }
    });
  });

  // cargarDashboard(); // Desactivado para usar datos reales de Django
});

// ============================
// DATOS SIMULADOS (Desactivados)
// ============================

/*
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

function cargarDashboard() {
  // ...
}
*/

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
// CRUD PROYECTOS (Manejado por Django)
// ============================
