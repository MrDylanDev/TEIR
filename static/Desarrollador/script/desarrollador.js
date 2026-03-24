/**
 * Lógica específica para el Dashboard de Desarrollador
 * (Manejado por Django y tabs.js)
 */

document.addEventListener("DOMContentLoaded", function () {
    // Inicialización específica si fuera necesaria
});

// Función para previsualizar foto de perfil antes de subir (opcional)
function previewFoto(event) {
    const reader = new FileReader();
    reader.onload = function() {
        const output = document.getElementById('fotoPerfil');
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
}
