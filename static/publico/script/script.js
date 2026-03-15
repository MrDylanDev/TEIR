// =========================================================
// SCRIPT DE ANIMACIÓN DE APARICIÓN SUAVE REPETITIVA
// =========================================================

// Espera a que el contenido esté completamente cargado
document.addEventListener('DOMContentLoaded', () => {

  const faders = document.querySelectorAll('.fade-in');

  // Configuración de activación de animación
  const appearOptions = {
    threshold: 0.2, 
    rootMargin: "0px 0px -50px 0px"
  };

  const appearOnScroll = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      } else {
        entry.target.classList.remove('visible');
      }
    });
  }, appearOptions);

  faders.forEach(fader => {
    appearOnScroll.observe(fader);
  });

  faders.forEach(fader => fader.style.opacity = "1");
});
// SCROLL SUAVE

document.querySelectorAll("nav a").forEach(link=>{
link.addEventListener("click",e=>{
e.preventDefault();
document.querySelector(link.getAttribute("href"))
.scrollIntoView({behavior:"smooth"});
});
});


// CONTADORES ANIMADOS

const counters=document.querySelectorAll("[data-num]");
let started=false;

window.addEventListener("scroll",()=>{

const section=document.querySelector(".stats");
if(!section) return;

const pos=section.getBoundingClientRect().top;

if(pos<window.innerHeight && !started){

counters.forEach(counter=>{
let target=+counter.dataset.num;
let count=0;

let update=()=>{
count+=target/60;
if(count<target){
counter.innerText=Math.floor(count);
requestAnimationFrame(update);
}else{
counter.innerText=target+"+";
}
}
update();
});

started=true;
}
});


// EFECTO PARALLAX HERO

window.addEventListener("mousemove",e=>{
document.querySelector(".mockup").style.transform=
`rotateY(${(e.clientX-window.innerWidth/2)/40}deg)
 rotateX(${-(e.clientY-window.innerHeight/2)/40}deg)`;
});