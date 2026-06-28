import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model
from proyectos.models import Proyecto, Entregable
from avances.models import Avance

User = get_user_model()


class TestAvanceModel:
    """Tests for Avance model."""

    def test_crear_avance(self, db):
        """Avance links to proyecto and entregable."""
        empresa = User.objects.create_user(
            username='ae', email='ae@test.teir',
            nombre='AE', rol='empresa', estado='activo',
            password='TestPass123!',
        )
        dev = User.objects.create_user(
            username='ad', email='ad@test.teir',
            nombre='AD', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        proyecto = Proyecto.objects.create(
            empresa=empresa, titulo='AP',
            descripcion='D', tipo_solucion='sitio_web',
            estado='en_desarrollo',
        )
        entregable = Entregable.objects.create(
            proyecto=proyecto, titulo='Hito 1',
            descripcion='H1',
        )
        avance = Avance.objects.create(
            proyecto=proyecto, entregable=entregable,
            desarrollador=dev, descripcion='Avance test',
        )
        assert avance.id is not None

    def test_avance_str(self, db):
        """__str__ includes proyecto and entregable."""
        empresa = User.objects.create_user(
            username='ae2', email='ae2@test.teir',
            nombre='AE2', rol='empresa', estado='activo',
            password='TestPass123!',
        )
        proyecto = Proyecto.objects.create(
            empresa=empresa, titulo='AP2',
            descripcion='D', tipo_solucion='sitio_web',
            estado='en_desarrollo',
        )
        entregable = Entregable.objects.create(
            proyecto=proyecto, titulo='H2', descripcion='H2',
        )
        dev = User.objects.create_user(
            username='ad2', email='ad2@test.teir',
            nombre='AD2', rol='desarrollador', estado='activo',
            password='TestPass123!',
        )
        avance = Avance.objects.create(
            proyecto=proyecto, entregable=entregable,
            desarrollador=dev, descripcion='Test',
        )
        assert 'AP2' in str(avance)


class TestVerAvances:
    """Tests for ver_avances view."""

    def test_ver_avances_accessible(self, auth_client, empresa_user):
        """Authenticated user can view avances for a project."""
        proyecto = Proyecto.objects.create(
            empresa=empresa_user, titulo='VA',
            descripcion='D', tipo_solucion='sitio_web',
            estado='en_desarrollo',
        )
        response = auth_client.get(
            reverse('ver_avances', args=[proyecto.id])
        )
        assert response.status_code == 200
