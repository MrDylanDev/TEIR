const proyectos = JSON.parse(localStorage.getItem("proyectos")) || [
  {
    id: 1,
    titulo: "Sistema de Inventario",
    descripcion: "Aplicación web para control de stock.",
    estado: "publicado",
    desarrollador: null,
    fechaAsignacion: null
  }
];

function guardarDatos() {
  localStorage.setItem("proyectos", JSON.stringify(proyectos));
}