const rolSelect = document.getElementById('id_rol');
    const typeDocContainer = document.getElementById('container_tipo_documento');
    const typeDocSelect = document.getElementById('id_tipo_documento');
    const labelCedula = document.getElementById('label_cedula');

    function updateDocFields() {
      const rol = rolSelect.value;
      if (rol === 'empresa') {
        typeDocContainer.style.display = 'block';
        labelCedula.innerText = 'NIT o Número de Identificación';
        if(typeDocSelect) {
            typeDocSelect.style.width = '100%';
            typeDocSelect.style.padding = '13px 16px';
            typeDocSelect.style.background = 'rgba(255,255,255,0.03)';
            typeDocSelect.style.border = '1px solid rgba(255,255,255,0.1)';
            typeDocSelect.style.borderRadius = '10px';
            typeDocSelect.style.color = '#fff';
            typeDocSelect.style.fontSize = '14.5px';
            typeDocSelect.style.fontFamily = "'Inter', sans-serif";
            // Clean up old options
            for(let option of typeDocSelect.options){ option.style.background='#111'; option.style.color='#fff'; }
        }
      } else {
        typeDocContainer.style.display = 'none';
        if (typeDocSelect) typeDocSelect.value = 'cedula'; 
        labelCedula.innerText = 'Cédula de Identidad';
      }
    }

    rolSelect.addEventListener('change', updateDocFields);
    window.addEventListener('load', updateDocFields);

    document.querySelector('form').addEventListener('submit', function(e) {
      const username = document.querySelector('input[name="username"]').value;
      const password1 = document.querySelector('input[name="password1"]').value;
      const password2 = document.querySelector('input[name="password2"]').value;
      
      if (username.trim().includes(' ')) {
        e.preventDefault();
        alert('El nombre de usuario no puede contener espacios obligatorios.');
        return;
      }
      if (password1 !== password2) {
        e.preventDefault();
        alert('Las contraseñas ingresadas no coinciden. Verifícalas y vuelve a intentar.');
        return;
      }
    });

    // Añade clase glass al select inyectado por form de Django (si existe)
    if(typeDocSelect) {
        typeDocSelect.style.width = '100%';
        typeDocSelect.style.padding = '13px 16px';
        typeDocSelect.style.background = 'rgba(255,255,255,0.03)';
        typeDocSelect.style.border = '1px solid rgba(255,255,255,0.1)';
        typeDocSelect.style.borderRadius = '10px';
        typeDocSelect.style.color = '#fff';
        typeDocSelect.style.fontSize = '14.5px';
        typeDocSelect.style.marginBottom = '8px';
    }
