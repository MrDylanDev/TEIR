const form = document.querySelector(".form");

form.addEventListener("submit", e=>{
e.preventDefault();

const button = form.querySelector("button");
button.textContent = "Enviando...";
button.disabled = true;

setTimeout(()=>{
button.textContent = "Correo enviado";
button.style.background = "#ffffff";
button.style.color = "#0b0b0d";
},1500);
});
