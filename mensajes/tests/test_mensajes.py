import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model
from proyectos.models import Proyecto
from mensajes.models import Mensaje

User = get_user_model()


class TestMensajeModel:
    """Tests for Mensaje model."""

    def test_crear_mensaje(self, db):
        """Mensaje links sender and receiver."""
        dev1 = User.objects.create_user(
            username='msg1', email='msg1@test.teir',
            nombre='Msg1', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        dev2 = User.objects.create_user(
            username='msg2', email='msg2@test.teir',
            nombre='Msg2', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        msg = Mensaje.objects.create(
            remitente=dev1, receptor=dev2,
            titulo='Hola', contenido='Mensaje de prueba',
        )
        assert msg.id is not None
        assert msg.leido == False
        assert msg.remitente == dev1
        assert msg.receptor == dev2

    def test_mensaje_str(self, db):
        """__str__ includes sender and receiver."""
        dev1 = User.objects.create_user(
            username='m1', email='m1@test.teir',
            nombre='M1', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        dev2 = User.objects.create_user(
            username='m2', email='m2@test.teir',
            nombre='M2', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        msg = Mensaje.objects.create(
            remitente=dev1, receptor=dev2,
            contenido='Test',
        )
        assert 'm1' in str(msg)
        assert 'm2' in str(msg)

    def test_mensaje_sin_receptor(self, db):
        """Mensaje without receptor shows GRUPO."""
        dev1 = User.objects.create_user(
            username='m3', email='m3@test.teir',
            nombre='M3', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        msg = Mensaje.objects.create(
            remitente=dev1, contenido='Grupo',
        )
        assert 'GRUPO' in str(msg)


class TestInbox:
    """Tests for mensajeria_inbox view."""

    def test_inbox_accessible(self, dev_client):
        """Authenticated user can access inbox."""
        response = dev_client.get(reverse('mensajeria_inbox'))
        assert response.status_code == 200

    def test_inbox_blocked_anon(self, client):
        """Anonymous cannot access inbox."""
        response = client.get(reverse('mensajeria_inbox'))
        assert response.status_code == 302


class TestMensajeriaSent:
    """Tests for mensajeria_sent view."""

    def test_sent_accessible(self, dev_client):
        """Authenticated user can view sent messages."""
        response = dev_client.get(reverse('mensajeria_sent'))
        assert response.status_code == 200

    def test_sent_blocked_anon(self, client):
        """Anonymous cannot view sent messages."""
        response = client.get(reverse('mensajeria_sent'))
        assert response.status_code == 302


class TestRedactar:
    """Tests for mensajeria_redactar view."""

    def test_redactar_accessible(self, auth_client):
        """Authenticated user can access message composer."""
        response = auth_client.get(reverse('mensajeria_redactar'))
        assert response.status_code == 200

    def test_redactar_blocked_anon(self, client):
        """Anonymous cannot compose messages."""
        response = client.get(reverse('mensajeria_redactar'))
        assert response.status_code == 302
