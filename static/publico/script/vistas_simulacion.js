let tipo = null;

// cuando hago clic en un botón, guardo qué tipo es
document.querySelectorAll(".type-btn").forEach(btn => {
    btn.addEventListener("click", () => {
        tipo = btn.dataset.role; // usa el data-role que NO altera estilo
    });
});

// el formulario redirige según el botón seleccionado
document.getElementById("loginForm").addEventListener("submit", (e) => {
    e.preventDefault();

    if (!tipo) {
        alert("Selecciona un tipo de usuario primero");
        return;
    }

    if (tipo === "Administrador") {
        window.location.href = "../administrador/Administrador.html";
    }
    if (tipo === "Desarrollador") {
        window.location.href = "../Desarrollador/Desarrollador.html";
    }
    if (tipo === "Empresa") {
        window.location.href = "../empresa/empresa.html";
    }
});
