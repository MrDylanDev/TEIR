import pytest
from django.urls import reverse
from django.contrib.auth import get_user_model
from proyectos.models import Proyecto

User = get_user_model()


class TestListarProyectos:
    """Tests for listar_proyectos view."""

    def test_listar_publicados(self, auth_client, empresa_user):
        """Public listing shows only 'publicado' projects."""
        Proyecto.objects.create(
            empresa=empresa_user, titulo='Public', descripcion='P',
            tipo_solucion='sitio_web', estado='publicado',
        )
        Proyecto.objects.create(
            empresa=empresa_user, titulo='Hidden', descripcion='H',
            tipo_solucion='sitio_web', estado='en_desarrollo',
        )
        response = auth_client.get(reverse('listar_proyectos'))
        assert response.status_code == 200
        content = response.content.decode()
        assert 'Public' in content
        assert 'Hidden' not in content

    def test_filtrar_por_tipo(self, auth_client, empresa_user):
        """Filter by tipo_solucion works."""
        Proyecto.objects.create(
            empresa=empresa_user, titulo='Web App', descripcion='W',
            tipo_solucion='sitio_web', estado='publicado',
        )
        Proyecto.objects.create(
            empresa=empresa_user, titulo='Mobile App', descripcion='M',
            tipo_solucion='aplicacion_movil', estado='publicado',
        )
        response = auth_client.get(reverse('listar_proyectos') + '?tipo=sitio_web')
        content = response.content.decode()
        assert 'Web App' in content
        assert 'Mobile App' not in content
        assert response.status_code == 200


class TestCrearProyecto:
    """Tests for crear_proyecto view."""

    def test_empresa_puede_crear(self, auth_client, empresa_user):
        """Empresa user can create a project."""
        response = auth_client.post(reverse('crear_proyecto'), {
            'titulo': 'Nuevo Proyecto',
            'descripcion': 'Descripción del proyecto',
            'tipo_solucion': 'sitio_web',
            'prioridad': 'alta',
            'vacantes': '2',
        })
        assert response.status_code == 302
        assert Proyecto.objects.filter(titulo='Nuevo Proyecto').exists()

    def test_dev_no_puede_crear(self, dev_client):
        """Dev user cannot create a project."""
        response = dev_client.post(reverse('crear_proyecto'), {
            'titulo': 'Proyecto Dev',
            'descripcion': 'No debería crearse',
            'tipo_solucion': 'sitio_web',
        })
        assert response.status_code == 302
        assert not Proyecto.objects.filter(titulo='Proyecto Dev').exists()

    def test_anonimo_no_puede_crear(self, client):
        """Anonymous cannot create projects."""
        response = client.post(reverse('crear_proyecto'), {
            'titulo': 'Anon',
            'descripcion': 'Nope',
            'tipo_solucion': 'sitio_web',
        })
        assert response.status_code == 302
        assert not Proyecto.objects.filter(titulo='Anon').exists()

    def test_crear_registra_historial(self, auth_client, empresa_user):
        """Creating a project registers initial estado in historial."""
        auth_client.post(reverse('crear_proyecto'), {
            'titulo': 'Con Historial',
            'descripcion': 'Test',
            'tipo_solucion': 'sitio_web',
        })
        proyecto = Proyecto.objects.get(titulo='Con Historial')
        historial = proyecto.historial_estados.first()
        assert historial is not None
        assert historial.estado_nuevo == 'publicado'


class TestFinalizarProyecto:
    """Tests for finalizar_proyecto view."""

    def test_empresa_puede_acceder(self, auth_client, empresa_user):
        """Empresa can access finalizar page (redirects if no hitos)."""
        proyecto = Proyecto.objects.create(
            empresa=empresa_user, titulo='Para Finalizar',
            descripcion='T', tipo_solucion='sitio_web',
            estado='en_desarrollo',
        )
        response = auth_client.get(
            reverse('finalizar_proyecto', args=[proyecto.id])
        )
        # Redirects because no hitos defined — but page is accessible (not 404/403)
        assert response.status_code == 302

    def test_otra_empresa_no_puede(self, db, empresa_user):
        """Empresa cannot finalize another empresa's project."""
        otra = User.objects.create_user(
            username='otra_emp', email='otra@test.teir',
            nombre='Otra', rol='empresa', estado='activo',
            password='TestPass123!',
        )
        proyecto = Proyecto.objects.create(
            empresa=otra, titulo='Ajeno', descripcion='A',
            tipo_solucion='sitio_web', estado='en_desarrollo',
        )
        from django.test import Client
        client = Client()
        client.login(username='empresa_test', password='TestPass123!')
        response = client.get(
            reverse('finalizar_proyecto', args=[proyecto.id])
        )
        assert response.status_code == 404
