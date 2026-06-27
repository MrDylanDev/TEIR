import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model
from datetime import date

User = get_user_model()


class TestRegistroView:
    """Tests for registro_view at /registro/"""

    def test_registro_page_loads(self, client):
        """GET /registro/ returns 200 and registration form."""
        response = client.get(reverse('registro'))
        assert response.status_code == 200

    def test_registro_desarrollador_success(self, client):
        """Valid desarrollador registration creates user and logs in."""
        response = client.post(reverse('registro'), {
            'username': 'nuevodev',
            'nombre': 'Nuevo Dev',
            'tipo_documento': 'cedula',
            'identificacion': '1234567890',
            'email': 'nuevodev@test.teir',
            'fecha_nacimiento': '2000-01-01',
            'rol': 'desarrollador',
            'password1': 'TestPass123!',
            'password2': 'TestPass123!',
        })
        assert response.status_code == 302
        assert response.url == reverse('dashboard_desarrollador')
        assert User.objects.filter(username='nuevodev').exists()
        user = User.objects.get(username='nuevodev')
        assert user.rol == 'desarrollador'
        assert user.estado == 'activo'

    def test_registro_empresa_success(self, client):
        """Valid empresa registration creates user and logs in."""
        response = client.post(reverse('registro'), {
            'username': 'nuevaempresa',
            'nombre': 'Nueva Empresa',
            'tipo_documento': 'nit',
            'identificacion': '900123456-7',
            'email': 'empresanueva@test.teir',
            'fecha_nacimiento': '1990-06-15',
            'rol': 'empresa',
            'password1': 'TestPass123!',
            'password2': 'TestPass123!',
        })
        assert response.status_code == 302
        assert response.url == reverse('dashboard_empresa')
        assert User.objects.filter(username='nuevaempresa').exists()

    def test_registro_missing_required_fields(self, client):
        """Missing required fields return form with errors."""
        response = client.post(reverse('registro'), {
            'username': '',
            'nombre': '',
            'email': '',
            'password1': 'TestPass123!',
            'password2': 'TestPass123!',
        })
        assert response.status_code == 200

    def test_registro_password_mismatch(self, client):
        """Non-matching passwords return form with error."""
        response = client.post(reverse('registro'), {
            'username': 'fallido',
            'nombre': 'Fallido',
            'tipo_documento': 'cedula',
            'identificacion': '1111111111',
            'email': 'fallido@test.teir',
            'fecha_nacimiento': '2000-01-01',
            'rol': 'desarrollador',
            'password1': 'TestPass123!',
            'password2': 'Different!',
        })
        assert response.status_code == 200

    def test_registro_underage(self, client):
        """User under 18 cannot register."""
        response = client.post(reverse('registro'), {
            'username': 'menor',
            'nombre': 'Menor Edad',
            'tipo_documento': 'cedula',
            'identificacion': '2222222222',
            'email': 'menor@test.teir',
            'fecha_nacimiento': str(date.today().year - 16) + '-01-01',
            'rol': 'desarrollador',
            'password1': 'TestPass123!',
            'password2': 'TestPass123!',
        })
        assert response.status_code == 200
        assert not User.objects.filter(username='menor').exists()

    def test_registro_dev_with_nit_rejected(self, client):
        """Developer with NIT is rejected."""
        response = client.post(reverse('registro'), {
            'username': 'devnit',
            'nombre': 'Dev con NIT',
            'tipo_documento': 'nit',
            'identificacion': '800123456-1',
            'email': 'devnit@test.teir',
            'fecha_nacimiento': '2000-01-01',
            'rol': 'desarrollador',
            'password1': 'TestPass123!',
            'password2': 'TestPass123!',
        })
        assert response.status_code == 200
        assert not User.objects.filter(username='devnit').exists()
