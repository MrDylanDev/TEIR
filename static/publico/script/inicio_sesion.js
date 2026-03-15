// =============================
// MOSTRAR / OCULTAR CONTRASEÑA
// =============================
document.getElementById("togglePass").addEventListener("click", function() {
  const passInput = document.getElementById("contraseña");
  if (passInput.type === "password") {
    passInput.type = "text";
    this.textContent = "🙈";
  } else {
    passInput.type = "password";
    this.textContent = "👁";
  }
});

// =============================
// ANIMACIÓN DE ALERTA BONITA
// =============================
function mostrarAlerta(mensaje) {
  // Si ya existe una alerta, la eliminamos
  const existente = document.querySelector(".alerta-popup");
  if (existente) existente.remove();

  // Crear contenedor de alerta
  const alerta = document.createElement("div");
  alerta.classList.add("alerta-popup");
  alerta.innerHTML = `
    <div class="alerta-contenido">
      <h2> Bienvenido </h2>
      <p>${mensaje}</p>
    </div>
  `;
  document.body.appendChild(alerta);

  // Mostrar con animación
  setTimeout(() => alerta.classList.add("visible"), 100);

  // Ocultar después de 3 segundos
  setTimeout(() => {
    alerta.classList.remove("visible");
    setTimeout(() => alerta.remove(), 500);
  }, 3000);
}

// =============================
// VALIDACIÓN DEL FORMULARIO
// =============================
document.getElementById("loginForm").addEventListener("submit", function(e) {
  e.preventDefault();

  const usuario = document.getElementById("usuario").value.trim();
  const contraseña = document.getElementById("contraseña").value.trim();

  if (usuario === "" || contraseña === "") {
    mostrarAlerta("Por favor, completa todos los campos.");
    return;
  }

  // Aquí podrías validar contra base de datos o API
  mostrarAlerta(`¡Hola ${usuario}! Gracias por volver :)`);
});


// =============================
// SELECCIÓN DE TIPO DE USUARIO
// =============================
const typeButtons = document.querySelectorAll('.type-btn');

typeButtons.forEach(btn => {
  btn.addEventListener('click', () => {
    // Quita la clase "active" de todos los botones
    typeButtons.forEach(b => b.classList.remove('active'));
    // Agrega "active" solo al botón seleccionado
    btn.classList.add('active');
  });
});
