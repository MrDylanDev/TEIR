import pytest
from django.urls import reverse


class TestDashboardAccess:
    """Tests for role-based dashboard access control."""

    # --- Landing page (public) ---

    def test_inicio_accessible_anonymous(self, client):
        """Landing page accessible without login."""
        response = client.get(reverse('inicio'))
        assert response.status_code == 200

    # --- Dashboard: empresa ---

    def test_empresa_dashboard_accessible(self, auth_client):
        """Empresa user can access their dashboard."""
        response = auth_client.get(reverse('dashboard_empresa'))
        assert response.status_code == 200

    def test_empresa_dashboard_blocked_for_anon(self, client):
        """Anonymous users cannot access empresa dashboard."""
        response = client.get(reverse('dashboard_empresa'))
        assert response.status_code == 302

    def test_empresa_dashboard_blocked_for_dev(self, dev_client):
        """Dev users cannot access empresa dashboard."""
        response = dev_client.get(reverse('dashboard_empresa'))
        # Redirects to inicio because role check fails
        assert response.status_code == 302

    # --- Dashboard: desarrollador ---

    def test_dev_dashboard_accessible(self, dev_client):
        """Dev user can access their dashboard."""
        response = dev_client.get(reverse('dashboard_desarrollador'))
        assert response.status_code == 200

    def test_dev_dashboard_blocked_for_anon(self, client):
        """Anonymous users cannot access dev dashboard."""
        response = client.get(reverse('dashboard_desarrollador'))
        assert response.status_code == 302

    def test_dev_dashboard_blocked_for_empresa(self, auth_client):
        """Empresa users cannot access dev dashboard."""
        response = auth_client.get(reverse('dashboard_desarrollador'))
        assert response.status_code == 302

    # --- Dashboard: admin ---

    def test_admin_dashboard_accessible(self, admin_client):
        """Admin user can access their dashboard."""
        response = admin_client.get(reverse('dashboard_admin'))
        assert response.status_code == 200

    def test_admin_dashboard_blocked_for_anon(self, client):
        """Anonymous users cannot access admin dashboard."""
        response = client.get(reverse('dashboard_admin'))
        assert response.status_code == 302

    def test_admin_dashboard_blocked_for_empresa(self, auth_client):
        """Empresa users cannot access admin dashboard."""
        response = auth_client.get(reverse('dashboard_admin'))
        assert response.status_code == 302

    # --- Profile editing ---

    def test_editar_perfil_accessible(self, auth_client):
        """Authenticated user can access profile edit."""
        response = auth_client.get(reverse('editar_perfil'))
        assert response.status_code == 200

    def test_editar_perfil_blocked_for_anon(self, client):
        """Anonymous cannot access profile edit."""
        response = client.get(reverse('editar_perfil'))
        assert response.status_code == 302
