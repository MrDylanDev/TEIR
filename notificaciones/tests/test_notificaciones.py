import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model
from notificaciones.models import Notificacion

User = get_user_model()


class TestNotificacionModel:
    """Tests for Notificacion model."""

    def test_crear_notificacion(self, db):
        """Notificacion links to usuario."""
        user = User.objects.create_user(
            username='nu', email='nu@test.teir',
            nombre='NU', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        notif = Notificacion.objects.create(
            usuario=user, tipo='alerta',
            mensaje='Mensaje test',
        )
        assert notif.id is not None
        assert notif.leida == False

    def test_notificacion_str(self, db):
        """__str__ shows usuario and titulo."""
        user = User.objects.create_user(
            username='nu2', email='nu2@test.teir',
            nombre='NU2', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        notif = Notificacion.objects.create(
            usuario=user, tipo='success',
            mensaje='Test Body',
        )
        assert 'nu2' in str(notif)


class TestListaNotificaciones:
    """Tests for lista_notificaciones view."""

    def test_lista_accessible(self, dev_client):
        """Authenticated user can view notifications."""
        response = dev_client.get(reverse('notificaciones_lista'))
        assert response.status_code == 200

    def test_lista_blocked_anon(self, client):
        """Anonymous cannot view notifications."""
        response = client.get(reverse('notificaciones_lista'))
        assert response.status_code == 302
