function showSection(id, btn) {
    document.querySelectorAll('.section-v').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.nav-item').forEach(b => b.classList.remove('active'));
    const target = document.getElementById(id);
    if (target) target.classList.add('active');
    if (btn) btn.classList.add('active');
  }

  // Crud lógica
  function getCSRFToken() {
    return document.querySelector('[name=csrfmiddlewaretoken]').value;
  }

  function closeModal(id) {
    document.getElementById(id).classList.remove('open');
  }

  function openCreateUserModal() {
    document.getElementById('createUserForm').reset();
    document.getElementById('createUserModal').classList.add('open');
  }

  document.getElementById('createUserForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const data = {
      username: document.getElementById('create-username').value,
      email: document.getElementById('create-email').value,
      password: document.getElementById('create-password').value,
      rol: document.getElementById('create-rol').value
    };

    try {
      const response = await fetch('/api/crear/', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRFToken() },
        body: JSON.stringify(data)
      });
      const result = await response.json();
      if (response.ok) { window.location.href = '?section=usersSection'; }
      else { alert(result.error); }
    } catch (e) { alert("Error de red."); }
  });

  async function openEditUserModal(id) {
    try {
      const response = await fetch(`/api/${id}/`);
      const user = await response.json();
      if (response.ok) {
        document.getElementById('edit-id').value = user.id;
        document.getElementById('edit-email').value = user.email;
        document.getElementById('edit-nombre').value = user.nombre || '';
        document.getElementById('edit-rol').value = user.rol;
        document.getElementById('editUserModal').classList.add('open');
      } else { alert(user.error || "No se pudo cargar el usuario."); }
    } catch (e) { alert("Error de conexión."); }
  }

  document.getElementById('editUserForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const id = document.getElementById('edit-id').value;
    const data = {
      email: document.getElementById('edit-email').value,
      nombre: document.getElementById('edit-nombre').value,
      rol: document.getElementById('edit-rol').value
    };

    try {
      const response = await fetch(`/api/${id}/actualizar/`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRFToken() },
        body: JSON.stringify(data)
      });
      if (response.ok) { window.location.href = '?section=usersSection'; }
      else { const result = await response.json(); alert(result.error); }
    } catch (e) { alert("Error de red."); }
  });

  async function deleteUser(id, username) {
    if (confirm(`¿Estás SEGURO de que deseas eliminar permanentemente al usuario ${username}? Esta acción no se puede deshacer.`)) {
      try {
        const response = await fetch(`/api/${id}/eliminar/`, {
          method: 'DELETE',
          headers: { 'X-CSRFToken': getCSRFToken() }
        });
        if (response.ok) { window.location.href = '?section=usersSection'; }
        else { const result = await response.json(); alert(result.error); }
      } catch (e) { alert("Error de red."); }
    }
  }

  window.onload = function() {
    const s = new URLSearchParams(window.location.search).get('section');
    if (s) showSection(s);
  };
