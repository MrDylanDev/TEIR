/**
 * Sistema Maestro de Pestañas TEIR
 * Maneja la navegación y persistencia de secciones para todos los dashboards.
 */

function switchTab(sectionId, clickedElement) {
    // 1. Ocultar todas las secciones del contenedor actual
    const sections = document.querySelectorAll('.seccion-v, .seccion, .vista, .section-v');
    sections.forEach(s => s.classList.remove('activa', 'active'));
    sections.forEach(s => s.style.display = 'none');

    // 2. Mostrar la sección objetivo
    const target = document.getElementById(sectionId);
    if (target) {
        target.classList.add('activa');
        target.style.display = 'block';
    }

    // 3. Actualizar estados de botones en el sidebar
    const navButtons = document.querySelectorAll('.btn-nav, .sidebar li, .menu-btn');
    navButtons.forEach(b => b.classList.remove('active', 'activo'));

    if (clickedElement) {
        clickedElement.classList.add('active');
    } else {
        // Intentar encontrar el botón por su atributo onclick o data-vista
        navButtons.forEach(btn => {
            const clickAttr = btn.getAttribute('onclick') || "";
            const dataVista = btn.getAttribute('data-vista') || "";
            if (clickAttr.includes(sectionId) || dataVista === sectionId) {
                btn.classList.add('active');
            }
        });
    }

    // 4. Persistencia en la URL (sin recargar página)
    const url = new URL(window.location);
    url.searchParams.set('section', sectionId);
    window.history.pushState({}, '', url);
}

// Inicialización al cargar la página
document.addEventListener("DOMContentLoaded", function() {
    const urlParams = new URLSearchParams(window.location.search);
    const section = urlParams.get('section');
    
    if (section) {
        switchTab(section);
    }
});
