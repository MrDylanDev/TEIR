// ===== VARIABLES GLOBALES =====
let usuarioEditandoId = null;

// ===== CARGAR USUARIOS AL INICIAR =====
document.addEventListener('DOMContentLoaded', function() {
    cargarUsuarios();
    
    // Cerrar modal si se hace clic fuera
    window.onclick = function(event) {
        const modal = document.getElementById('userModal');
        if (event.target === modal) {
            closeModal();
        }
    };
});

// ===== CARGAR USUARIOS DESDE LA BD =====
function cargarUsuarios() {
    fetch('/api/usuarios/')
        .then(response => response.json())
        .then(usuarios => {
            const tbody = document.getElementById('userTable');
            tbody.innerHTML = '';
            
            usuarios.forEach(u => {
                const fecha = new Date(u.date_joined).toLocaleDateString();
                let rolTexto = u.rol;
                if (u.rol === 'empresa') rolTexto = 'Empresa';
                if (u.rol === 'desarrollador') rolTexto = 'Desarrollador';
                if (u.rol === 'administrador') rolTexto = 'Administrador';
                
                tbody.innerHTML += `
                    <tr>
                        <td>${u.username}</td>
                        <td>${u.cedula || '-'}</td>
                        <td>${u.email}</td>
                        <td>${rolTexto}</td>
                        <td>${fecha}</td>
                        <td>
                            <button onclick="editarUsuario(${u.id})" class="btn-edit">✏️ Editar</button>
                            <button onclick="eliminarUsuario(${u.id})" class="btn-delete">🗑️ Eliminar</button>
                        </td>
                    </tr>
                `;
            });
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al cargar los usuarios');
        });
}

// ===== FILTRO DE USUARIOS =====
function filterUsers() {
    const searchText = document.getElementById('searchInput').value.toLowerCase();
    const rows = document.querySelectorAll('#userTable tr');
    
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(searchText) ? '' : 'none';
    });
}

// ===== MODAL =====
function openModal(usuario = null) {
    const modal = document.getElementById('userModal');
    modal.style.display = 'block';
    
    // Limpiar/establecer campo de contraseña
    document.getElementById('password').value = 'temporal123';
    
    if (usuario) {
        // Modo edición
        usuarioEditandoId = usuario.id;
        document.getElementById('name').value = usuario.username;
        document.getElementById('cedula').value = usuario.cedula || '';
        document.getElementById('email').value = usuario.email;
        document.getElementById('role').value = usuario.rol;
        document.querySelector('.modal h2').textContent = 'Editar Usuario';
        
        // Cambiar la función del botón Guardar
        document.querySelector('.modal-buttons button:first-child').onclick = actualizarUsuario;
    } else {
        // Modo creación
        usuarioEditandoId = null;
        document.getElementById('name').value = '';
        document.getElementById('cedula').value = '';
        document.getElementById('email').value = '';
        document.getElementById('role').value = 'empresa';
        document.querySelector('.modal h2').textContent = 'Nuevo Usuario';
        
        // Restaurar función de guardar
        document.querySelector('.modal-buttons button:first-child').onclick = addUser;
    }
}

function closeModal() {
    document.getElementById('userModal').style.display = 'none';
}

// ===== GUARDAR USUARIO (CREAR) =====
function addUser() {
    // Validar campos
    const username = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const rol = document.getElementById('role').value;
    
    if (!username || !email) {
        alert('Nombre y Email son obligatorios');
        return;
    }
    
    const usuarioData = {
        username: username,
        cedula: document.getElementById('cedula').value.trim(),
        email: email,
        rol: rol,
        password: document.getElementById('password').value.trim() || 'temporal123'
    };
    
    fetch('/api/usuarios/crear/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken')
        },
        body: JSON.stringify(usuarioData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            closeModal();
            cargarUsuarios();
            alert('Usuario creado correctamente. Contraseña: ' + usuarioData.password);
        } else {
            alert('Error: ' + (data.error || 'Error desconocido'));
        }
    })
    .catch(error => {
        alert('Error de conexión');
        console.error(error);
    });
}

// ===== ACTUALIZAR USUARIO (EDITAR) =====
function actualizarUsuario() {
    if (!usuarioEditandoId) return;
    
    const usuarioData = {
        username: document.getElementById('name').value.trim(),
        cedula: document.getElementById('cedula').value.trim(),
        email: document.getElementById('email').value.trim(),
        rol: document.getElementById('role').value
    };
    
    // Si se ingresó una nueva contraseña, enviarla
    const nuevaPassword = document.getElementById('password').value.trim();
    if (nuevaPassword && nuevaPassword !== 'temporal123') {
        usuarioData.password = nuevaPassword;
    }
    
    fetch(`/api/usuarios/${usuarioEditandoId}/actualizar/`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCookie('csrftoken')
        },
        body: JSON.stringify(usuarioData)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            closeModal();
            cargarUsuarios();
            alert('Usuario actualizado correctamente');
        } else {
            alert('Error: ' + (data.error || 'Error desconocido'));
        }
    })
    .catch(error => {
        alert('Error de conexión');
        console.error(error);
    });
}

// ===== EDITAR USUARIO =====
function editarUsuario(id) {
    fetch(`/api/usuarios/${id}/`)
        .then(response => response.json())
        .then(usuario => {
            openModal(usuario);
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al cargar el usuario');
        });
}

// ===== ELIMINAR USUARIO =====
function eliminarUsuario(id) {
    if (confirm('¿Estás seguro de eliminar este usuario?')) {
        fetch(`/api/usuarios/${id}/eliminar/`, {
            method: 'DELETE',
            headers: {
                'X-CSRFToken': getCookie('csrftoken')
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                cargarUsuarios();
                alert('Usuario eliminado correctamente');
            } else {
                alert('Error: ' + data.error);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error al eliminar');
        });
    }
}

// ===== FUNCIÓN PARA OBTENER CSRF TOKEN =====
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// ===== CAMBIAR ENTRE SECCIONES =====
function showSection(sectionId, element) {
    document.querySelectorAll('.section').forEach(s => {
        s.classList.remove('active');
    });
    document.getElementById(sectionId).classList.add('active');
    
    document.querySelectorAll('.sidebar li').forEach(li => {
        li.classList.remove('active');
    });
    element.classList.add('active');
}