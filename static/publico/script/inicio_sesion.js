// Mapa de roles a nombres legibles
    const roleNames = {
      'administrador': 'Administrador',
      'empresa': 'Empresa',
      'desarrollador': 'Desarrollador'
    };

    // Botones de rol
    const roleButtons = document.querySelectorAll('.role-btn');
    const rolInput = document.getElementById('rol_seleccionado');
    const rolDisplay = document.getElementById('rol-display');

    roleButtons.forEach(btn => {
      btn.addEventListener('click', function() {
        roleButtons.forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        const rolValue = this.dataset.role;
        rolInput.value = rolValue;
        rolDisplay.textContent = roleNames[rolValue] || rolValue;
      });
    });

    // Animación Matrix
    const canvas = document.getElementById('matrix-canvas');
    const ctx = canvas.getContext('2d');
    function resizeCanvas() {
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;
    }
    resizeCanvas();
    const dotSize = 3;
    const spacing = 20;
    let columns = Math.floor(canvas.width / spacing);
    let drops = [];
    function initDrops() {
      columns = Math.floor(canvas.width / spacing);
      drops = [];
      for (let i = 0; i < columns; i++) {
        drops[i] = Math.random() * -100;
      }
    }
    initDrops();
    function drawMatrix() {
      ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
      ctx.fillRect(0, 0, canvas.width, canvas.height);
      for (let i = 0; i < drops.length; i++) {
        const opacity = Math.max(0.3, 1 - (drops[i] * spacing / canvas.height));
        const gradient = ctx.createRadialGradient(
          i * spacing, drops[i] * spacing, 0,
          i * spacing, drops[i] * spacing, dotSize
        );
        gradient.addColorStop(0, `rgba(100, 180, 255, ${opacity})`);
        gradient.addColorStop(0.5, `rgba(50, 140, 255, ${opacity * 0.8})`);
        gradient.addColorStop(1, `rgba(0, 100, 200, ${opacity * 0.4})`);
        ctx.fillStyle = gradient;
        ctx.beginPath();
        ctx.arc(i * spacing, drops[i] * spacing, dotSize, 0, Math.PI * 2);
        ctx.fill();
        if (drops[i] * spacing > canvas.height && Math.random() > 0.975) {
          drops[i] = 0;
        }
        drops[i]++;
      }
    }
    setInterval(drawMatrix, 50);
    window.addEventListener('resize', () => {
      resizeCanvas();
      initDrops();
    });

    // Mostrar/ocultar contraseña
    const togglePass = document.getElementById('togglePass');
    const passwordInput = document.getElementById('password');
    togglePass.addEventListener('click', function() {
      if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        togglePass.textContent = '🙈';
      } else {
        passwordInput.type = 'password';
        togglePass.textContent = '👁️';
      }
    });
