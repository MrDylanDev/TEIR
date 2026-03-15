// =========================================================
// FUNCIONALIDAD DEL MENÚ DESPLEGABLE
// =========================================================

// Selecciona todos los botones del menú
const menuButtons = document.querySelectorAll(".menu-btn");

// Recorre cada botón para agregar el evento de clic
menuButtons.forEach((btn) => {
  btn.addEventListener("click", () => {
    // Encuentra el submenú que está justo después del botón
    const submenu = btn.nextElementSibling;

    // Alterna (mostrar/ocultar) el submenú
    submenu.classList.toggle("open");
  });
});
