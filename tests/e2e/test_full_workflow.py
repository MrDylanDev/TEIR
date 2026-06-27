import pytest
from django.contrib.auth import get_user_model
from django.urls import reverse
from django.test import Client
from proyectos.models import Proyecto, Entregable, Equipo
from contrataciones.models import Contratacion
from avances.models import Avance
from mensajes.models import Mensaje

User = get_user_model()


@pytest.mark.e2e
@pytest.mark.django_db(transaction=True)
class TestFullWorkflowE2E:

    def test_full_project_lifecycle(self, page, live_server):
        """
        Complete project lifecycle E2E:
        1. Create empresa + 2 devs, publish project, both apply, empresa accepts
        2. Create groups, assign hitos to groups
        3. Devs submit avances
        4. Empresa accepts one, rejects another (with comment)
        5. Everyone chats in workspace
        6. Finalize project, rate both sides
        7. Verify history
        """
        client = Client()

        # ── SETUP: Create users ──
        empresa = User.objects.create_user(
            username='full_emp', email='full_emp@t.teir',
            nombre='Full Empresa', rol='empresa', estado='activo',
            password='FullPass123!',
        )
        dev1 = User.objects.create_user(
            username='full_dev1', email='full_dev1@t.teir',
            nombre='Full Dev 1', rol='desarrollador', estado='activo',
            password='FullPass123!',
        )
        dev2 = User.objects.create_user(
            username='full_dev2', email='full_dev2@t.teir',
            nombre='Full Dev 2', rol='desarrollador', estado='activo',
            password='FullPass123!',
        )

        # ── SETUP: Empresa publishes project ──
        client.login(username='full_emp', password='FullPass123!')
        resp = client.post(reverse('crear_proyecto'), {
            'titulo': 'Full Test Project',
            'descripcion': 'Proyecto de prueba completa',
            'tipo_solucion': 'sitio_web',
            'prioridad': 'alta',
            'vacantes': '2',
        })
        proyecto = Proyecto.objects.get(titulo='Full Test Project')
        assert proyecto.estado == 'publicado'

        # ── SETUP: Both devs apply ──
        for dev in [dev1, dev2]:
            c = Client()
            c.login(username=dev.username, password='FullPass123!')
            c.post(reverse('postularse_a_proyecto', args=[proyecto.id]), {
                'carta': f'Hola, soy {dev.nombre}',
                'experiencia': 'Django+React',
                'link': 'https://github.com/test',
            })
        assert proyecto.postulacion_set.count() == 2

        # ── SETUP: Empresa accepts both ──
        from postulaciones.models import Postulacion
        for post in Postulacion.objects.filter(proyecto=proyecto):
            client.post(reverse('aceptar_postulacion', args=[post.id]))
        proyecto.refresh_from_db()
        assert proyecto.estado == 'en_desarrollo'

        # ── SETUP: Create 2 groups ──
        grupo_a = Equipo.objects.create(proyecto=proyecto, nombre='Grupo Frontend')
        grupo_a.miembros.add(dev1)
        grupo_b = Equipo.objects.create(proyecto=proyecto, nombre='Grupo Backend')
        grupo_b.miembros.add(dev2)
        # Also add both to default equipo
        eq_default = Equipo.objects.get_or_create(proyecto=proyecto, nombre=f'Equipo {proyecto.titulo}')[0]
        eq_default.miembros.add(dev1, dev2)

        # ── SETUP: Create hitos ──
        hito_general = Entregable.objects.create(
            proyecto=proyecto, titulo='Hito General: README',
            descripcion='Documentacion', estado='pendiente',
        )
        hito_frontend = Entregable.objects.create(
            proyecto=proyecto, titulo='Hito Frontend: UI',
            descripcion='Crear interfaz', estado='pendiente',
            equipo=grupo_a,
        )
        hito_backend = Entregable.objects.create(
            proyecto=proyecto, titulo='Hito Backend: API',
            descripcion='Crear API REST', estado='pendiente',
            equipo=grupo_b,
        )

        # ── BROWSER: Dev1 logs in and submits avance for frontend hito ──
        page.goto(live_server.url + reverse('login'))
        page.fill('#username', 'full_dev1')
        page.fill('#password', 'FullPass123!')
        page.locator('button[type="submit"]').click(force=True)
        page.wait_for_timeout(2000)

        page.goto(live_server.url + reverse('registrar_avance', args=[proyecto.id]))
        page.wait_for_timeout(1000)
        # Select the frontend hito
        options = page.locator('select[name="entregable_id"] option')
        for i in range(options.count()):
            text = options.nth(i).text_content()
            if 'Frontend' in text:
                page.select_option('select[name="entregable_id"]', index=i)
                break
        page.fill('textarea[name="descripcion"]', 'UI implementada con componentes reutilizables')
        page.fill('input[name="archivo_url"]', 'https://github.com/test/frontend/pr/1')
        page.locator('button:has-text("Enviar Avance")').click(force=True)
        page.wait_for_timeout(2000)

        avance1 = Avance.objects.filter(desarrollador=dev1).first()
        assert avance1 is not None
        assert avance1.estado == 'pendiente'
        hito_frontend.refresh_from_db()
        assert hito_frontend.estado == 'en_revision'

        # ── BROWSER: Dev2 logs in and submits avance for backend hito ──
        page.goto(live_server.url + reverse('logout'))
        page.goto(live_server.url + reverse('login'))
        page.fill('#username', 'full_dev2')
        page.fill('#password', 'FullPass123!')
        page.locator('button[type="submit"]').click(force=True)
        page.wait_for_timeout(2000)

        page.goto(live_server.url + reverse('registrar_avance', args=[proyecto.id]))
        page.wait_for_timeout(1000)
        options = page.locator('select[name="entregable_id"] option')
        for i in range(options.count()):
            text = options.nth(i).text_content()
            if 'Backend' in text:
                page.select_option('select[name="entregable_id"]', index=i)
                break
        page.fill('textarea[name="descripcion"]', 'API REST con endpoints CRUD')
        page.fill('input[name="archivo_url"]', 'https://github.com/test/backend/pr/1')
        page.locator('button:has-text("Enviar Avance")').click(force=True)
        page.wait_for_timeout(2000)

        avance2 = Avance.objects.filter(desarrollador=dev2).first()
        assert avance2 is not None
        assert avance2.estado == 'pendiente'
        hito_backend.refresh_from_db()
        assert hito_backend.estado == 'en_revision'

        # ── BROWSER: Empresa accepts Dev1's avance, rejects Dev2's ──
        page.goto(live_server.url + reverse('logout'))
        page.goto(live_server.url + reverse('login'))
        page.locator('button[data-role="empresa"]').click()
        page.fill('#username', 'full_emp')
        page.fill('#password', 'FullPass123!')
        page.locator('button[type="submit"]').click(force=True)
        page.wait_for_timeout(2000)

        page.goto(live_server.url + reverse('ver_avances', args=[proyecto.id]))
        page.wait_for_timeout(1500)

        # Just use server-side to accept/reject (more reliable for testing)
        client.login(username='full_emp', password='FullPass123!')
        client.post(reverse('revisar_avance', args=[avance1.id]), {
            'accion': 'aceptar',
            'comentario': 'Buen trabajo!',
        })

        avance1.refresh_from_db()
        assert avance1.estado == 'aceptado'
        hito_frontend.refresh_from_db()
        assert hito_frontend.estado == 'completado'

        # Reject second avance (Backend)
        client.post(reverse('revisar_avance', args=[avance2.id]), {
            'accion': 'rechazar',
            'comentario': 'Falta el endpoint /users con paginacion',
        })

        avance2.refresh_from_db()
        assert avance2.estado == 'rechazado'
        assert 'paginacion' in avance2.comentario_revision
        hito_backend.refresh_from_db()
        assert hito_backend.estado == 'pendiente'
        proyecto.refresh_from_db()
        assert proyecto.estado == 'en_desarrollo'

        # ── BROWSER: Chat in workspace ──
        page.goto(live_server.url + reverse('sala_chat_grupal', args=[proyecto.id]))
        page.wait_for_timeout(1000)
        page.fill('input[name="contenido"]', 'Hola equipo, revisen los avances!')
        page.locator('button[type="submit"]').click(force=True)
        page.wait_for_timeout(1000)

        # Verify message was saved
        msg_count = Mensaje.objects.filter(proyecto=proyecto, receptor__isnull=True).count()
        assert msg_count >= 1

        # ── SETUP: Complete the remaining hito ──
        # Dev2 re-submits the backend hito
        c = Client()
        c.login(username='full_dev2', password='FullPass123!')
        c.post(reverse('registrar_avance', args=[proyecto.id]), {
            'entregable_id': hito_backend.id,
            'descripcion': 'API corregida con paginacion',
            'archivo_url': 'https://github.com/test/backend/pr/2',
        })
        # Also complete general hito
        c.post(reverse('registrar_avance', args=[proyecto.id]), {
            'entregable_id': hito_general.id,
            'descripcion': 'README completo',
            'archivo_url': 'https://github.com/test/docs/pr/1',
        })

        # Empresa accepts remaining avances
        client.login(username='full_emp', password='FullPass123!')
        for avance in Avance.objects.filter(proyecto=proyecto, estado='pendiente'):
            client.post(reverse('revisar_avance', args=[avance.id]), {
                'accion': 'aceptar',
                'comentario': 'Aprobado',
            })

        # Verify all hitos completed
        assert Entregable.objects.filter(proyecto=proyecto, estado='completado').count() == 3

        # ── BROWSER: Empresa finalizes and rates devs ──
        proyecto.refresh_from_db()

        # Rate first dev
        client.login(username='full_emp', password='FullPass123!')
        client.post(reverse('finalizar_proyecto', args=[proyecto.id]), {
            'puntuacion': '5',
            'comentario': 'Excelente desarrollador, muy profesional',
        }, follow=True)
        # Rate second dev (if not auto-finalized)
        proyecto.refresh_from_db()
        if proyecto.estado != 'finalizado':
            client.post(reverse('finalizar_proyecto', args=[proyecto.id]), {
                'puntuacion': '4',
                'comentario': 'Buen trabajo, cumplio con lo requerido',
            }, follow=True)

        proyecto.refresh_from_db()
        assert proyecto.estado == 'finalizado'

        # ── Devs rate the empresa (server-side) ──
        for dev in [dev1, dev2]:
            c = Client()
            c.login(username=dev.username, password='FullPass123!')
            c.post(reverse('calificar_empresa', args=[proyecto.id]), {
                'puntuacion': '5',
                'comentario': f'Buena experiencia con {empresa.nombre}',
            })

        # ── VERIFY: Historia ──
        from proyectos.models import Valoracion
        valoraciones_empresa = Valoracion.objects.filter(proyecto=proyecto, rol_evaluador='empresa').count()
        valoraciones_dev = Valoracion.objects.filter(proyecto=proyecto, rol_evaluador='desarrollador').count()
        assert valoraciones_empresa == 2  # Both devs rated by empresa
        assert valoraciones_dev == 2      # Both devs rated empresa

        # Verify contrataciones finalized
        assert Contratacion.objects.filter(proyecto=proyecto, estado='finalizada').count() == 2

        # Verify project in history
        assert proyecto.estado == 'finalizado'

        print("\n✅ FULL WORKFLOW COMPLETED:")
        print(f"  - 3 hitos: {Entregable.objects.filter(proyecto=proyecto).count()}")
        print(f"  - {Avance.objects.filter(proyecto=proyecto).count()} avances (aceptados + rechazados)")
        print(f"  - {Mensaje.objects.filter(proyecto=proyecto).count()} mensajes en chat")
        print(f"  - {valoraciones_empresa} valoraciones de empresa a devs")
        print(f"  - {valoraciones_dev} valoraciones de devs a empresa")
        print(f"  - Proyecto finalizado: ✅")
