// Script de Animación de Aparición Suave Repetitiva

// Espera a que el Contenido Esté Completamente Cargado
document.addEventListener('DOMContentLoaded', () => {

  const faders = document.querySelectorAll('.fade-in');

  // Configuración de Activación de Animación
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
// Scroll Suave

document.querySelectorAll("nav a").forEach(link=>{
link.addEventListener("click",e=>{
e.preventDefault();
document.querySelector(link.getAttribute("href"))
.scrollIntoView({behavior:"smooth"});
});
});


// Contadores Animados

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


// Efecto Parallax Hero

window.addEventListener("mousemove",e=>{
document.querySelector(".mockup").style.transform=
`rotateY(${(e.clientX-window.innerWidth/2)/40}deg)
 rotateX(${-(e.clientY-window.innerHeight/2)/40}deg)`;
});