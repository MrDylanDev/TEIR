// =========================================================
// CAMBIO DE FOTO DE PERFIL
// =========================================================
const inputFoto = document.getElementById('input-foto');
const btnFoto = document.getElementById('cambiar-foto');
const imgFoto = document.getElementById('foto');

btnFoto.addEventListener('click', () => inputFoto.click());
inputFoto.addEventListener('change', (e) => {
  const file = e.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = () => imgFoto.src = reader.result;
    reader.readAsDataURL(file);
  }
});

// =========================================================
// AGREGAR NUEVO ENLACE
// =========================================================
const btnAgregar = document.getElementById('agregar-enlace');
const inputEnlace = document.getElementById('nuevo-enlace');
const listaEnlaces = document.getElementById('lista-enlaces');

btnAgregar.addEventListener('click', () => {
  const url = inputEnlace.value.trim();
  if (url) {
    const li = document.createElement('li');
    const a = document.createElement('a');
    a.href = url;
    a.textContent = url;
    a.target = "_blank";
    li.appendChild(a);
    listaEnlaces.appendChild(li);
    inputEnlace.value = "";
  }
});
