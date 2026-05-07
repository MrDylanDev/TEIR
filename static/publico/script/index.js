document.addEventListener("DOMContentLoaded", function () {

  // Navbar Scroll Effect
  const navbar = document.getElementById('navbar');
  window.addEventListener('scroll', () => {
    navbar.classList.toggle('scrolled', window.scrollY > 20);
  });

  // Animated Counters
  const counters = document.querySelectorAll('[data-count]');
  const countObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        const target = parseInt(el.dataset.count);
        let current = 0;
        const step = Math.ceil(target / 50);
        const timer = setInterval(() => {
          current = Math.min(current + step, target);
          el.textContent = current + (target >= 100 ? '+' : '');
          if (current >= target) clearInterval(timer);
        }, 30);
        countObserver.unobserve(el);
      }
    });
  }, { threshold: 0.5 });
  counters.forEach(c => countObserver.observe(c));

  // Scroll Reveal
  const reveals = document.querySelectorAll('.reveal');
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.12 });
  reveals.forEach(r => revealObserver.observe(r));

  // Role Selector
  const roleButtons = document.querySelectorAll('.role-btn-glass');
  const rolInput = document.getElementById('rol_seleccionado');
  roleButtons.forEach(btn => {
    btn.addEventListener('click', function () {
      roleButtons.forEach(b => b.classList.remove('active'));
      this.classList.add('active');
      rolInput.value = this.dataset.role;
    });
  });

  // Toggle Password
  const togglePassBtn = document.getElementById('togglePassGlass');
  const passInput = document.getElementById('password');
  if (togglePassBtn && passInput) {
    togglePassBtn.addEventListener('click', function () {
      const isText = passInput.type === 'text';
      passInput.type = isText ? 'password' : 'text';
      this.innerHTML = isText ? '<i class="fa fa-eye"></i>' : '<i class="fa fa-eye-slash"></i>';
    });
  }

  // Auto-open Modal On Login Errors
  const djangoMessages = document.getElementById('django-messages');
  if (djangoMessages) {
    const spans = djangoMessages.querySelectorAll('span');
    let errorHtml = '';
    spans.forEach(span => {
      errorHtml += `
        <div style="background:rgba(220,38,38,0.12);border:1px solid rgba(220,38,38,0.35);border-radius:10px;padding:10px 14px;margin-bottom:14px;font-size:13px;color:#fca5a5;display:flex;align-items:center;gap:8px;">
          <i class="fa fa-circle-exclamation" style="color:#f87171;"></i>${span.textContent.trim()}
        </div>`;
    });
    if (errorHtml) {
      const form = document.querySelector('#loginModal form');
      if (form) {
        const container = document.createElement('div');
        container.innerHTML = errorHtml;
        form.insertBefore(container, form.firstChild);
      }
      new bootstrap.Modal(document.getElementById('loginModal')).show();
    }
  }

  // Auto-open Modal Via URL Parameter
  const urlParams = new URLSearchParams(window.location.search);
  if (urlParams.get('login') === '1') {
    new bootstrap.Modal(document.getElementById('loginModal')).show();
  }

  // Robot Inteligente con Spring Physics y Diálogos
  const robot = document.getElementById('scroll-robot');
  const visuals = document.getElementById('robot-visuals');
  const bubble = document.getElementById('robot-text');
  if (!robot || !visuals) return;

  let currentY = 0;
  let targetY = 0;
  let velocityY = 0;
  let lastScrollY = window.scrollY;

  const stiffness = 0.08;
  const damping = 0.82;
  const precision = 0.01;

  // Mapa de Mensajes por Sección (cacheamos Elementos para Rendimiento)
  const sections = [
    { el: document.getElementById('inicio'), msg: '¡Hola! Bienvenido a TEM 🤖' },
    { el: document.getElementById('como-funciona'), msg: 'Mira qué fácil es nuestro proceso' },
    { el: document.getElementById('funcionalidades'), msg: 'Tenemos todo para tu proyecto' },
    { el: document.getElementById('contacto'), msg: '¿Hablamos? ¡Escríbenos!' }
  ].filter(s => s.el);

  let lastMsg = "";

  function updateRobotDialog() {
    const scrollY = window.scrollY;
    let currentMsg = "Explora la plataforma 🚀";

    for (const s of sections) {
      const rect = s.el.getBoundingClientRect();
      if (rect.top < window.innerHeight / 2 && rect.bottom > window.innerHeight / 2) {
        currentMsg = s.msg;
        break;
      }
    }

    if (currentMsg !== lastMsg) {
      lastMsg = currentMsg;
      robot.classList.remove('show-bubble');
      setTimeout(() => {
        bubble.textContent = currentMsg;
        robot.classList.add('show-bubble');
      }, 300);
    }
  }

  // Sistema de Interacción Robot + Login (corregido)
  let isLoginMode = false;
  const loginModalEl = document.getElementById('loginModal');
  
  if (loginModalEl) {
    const userInput = document.getElementById('username');
    const passInput = document.getElementById('password');
    const visorLight = document.querySelector('.visor-light');
    const roleBtns = document.querySelectorAll('.role-btn-glass');
    const togglePassBtn = document.getElementById('togglePassGlass');

    const roleColors = {
      'administrador': '#ffffff',
      'empresa': '#10b981',
      'desarrollador': '#3b82f6'
    };

    loginModalEl.addEventListener('show.bs.modal', () => {
      isLoginMode = true;
      robot.classList.add('login-mode');
      robot.classList.remove('show-bubble');
      
      // Verificar Estado de Contraseña Inmediatamente al Abrir
      setTimeout(() => {
        handlePassEyes();
        bubble.textContent = "Te ayudo a entrar... 🔐";
        robot.classList.add('show-bubble');
      }, 500);
    });

    loginModalEl.addEventListener('hide.bs.modal', () => {
      isLoginMode = false;
      robot.classList.remove('login-mode');
      robot.classList.remove('covering-eyes');
      updateRobotDialog();
    });

    const handlePassEyes = () => {
      if (passInput && passInput.type === 'password') {
        robot.classList.add('covering-eyes');
        bubble.textContent = "No miraré tu clave... 👀";
      } else {
        robot.classList.remove('covering-eyes');
        bubble.textContent = "¡Te veo! 🤖";
      }
    };

    if (passInput) {
      passInput.addEventListener('focus', handlePassEyes);
      passInput.addEventListener('blur', () => robot.classList.remove('covering-eyes'));
    }

    if (togglePassBtn) {
      togglePassBtn.addEventListener('click', () => {
        setTimeout(handlePassEyes, 50);
      });
    }

    if (userInput) {
      userInput.addEventListener('focus', () => {
        bubble.textContent = "¿Quién eres hoy? 🤔";
      });
    }

    roleBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const role = btn.dataset.role;
        if (visorLight) visorLight.style.fill = roleColors[role] || '#fff';
        const msgs = {
          'administrador': "Control total iniciado.",
          'empresa': "Buscando al mejor talento...",
          'desarrollador': "¡Hola, dev! A codear."
        };
        bubble.textContent = msgs[role];
      });
    });
  }

  function animateRobot() {
    if (isLoginMode) {
      // En Modo Login, el Robot No Sigue el Scroll, Su Posición Es Controlada por CSS .login-mode
      requestAnimationFrame(animateRobot);
      return;
    }

    const scrollY = window.scrollY;
    const maxScroll = document.documentElement.scrollHeight - window.innerHeight;
    const scrollPercent = maxScroll > 0 ? scrollY / maxScroll : 0;

    const robotHeight = 130;
    const initialTop = 180;
    const safetyMargin = 40;
    const dynamicRange = window.innerHeight - initialTop - robotHeight - safetyMargin;
    const range = Math.max(0, dynamicRange);
    
    targetY = scrollPercent * range;

    const deltaScroll = scrollY - lastScrollY;
    lastScrollY = scrollY;

    // Resorte
    const force = (targetY - currentY) * stiffness;
    velocityY = (velocityY + force) * damping;
    currentY += velocityY;

    // Visuals
    if (Math.abs(velocityY) > 1.2 || Math.abs(deltaScroll) > 8) {
      robot.classList.add('falling');
      visuals.classList.remove('idle');
      const tilt = Math.max(-12, Math.min(12, velocityY * 1.2 + deltaScroll * 0.4));
      visuals.style.transform = `translateY(${currentY}px) rotate(${tilt}deg)`;
    } else {
      robot.classList.remove('falling');
      if (Math.abs(velocityY) < precision) {
        visuals.classList.add('idle');
        visuals.style.transform = `translateY(${currentY}px)`;
      } else {
        visuals.style.transform = `translateY(${currentY}px)`;
      }
    }

    updateRobotDialog();
    requestAnimationFrame(animateRobot);
  }

  // Clic en el Robot
  robot.addEventListener('click', () => {
    // Salto de Alegría y Cambio de Velocidad de los Anillos
    velocityY = -22;
    const funnyMsgs = ["Iniciando escaneo...","Analizando talento SENA","Núcleo estable.","100% Eficiencia."];
    const originalMsg = bubble.textContent;
    bubble.textContent = funnyMsgs[Math.floor(Math.random() * funnyMsgs.length)];
    setTimeout(() => { bubble.textContent = originalMsg; }, 2000);
  });

  requestAnimationFrame(animateRobot);
});
