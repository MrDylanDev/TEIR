# TEIR

**Plataforma de vinculación entre empresas y talento SENA.**

[![Tests](https://img.shields.io/badge/tests-117%20passed-brightgreen)](https://github.com/MrDylanDev/TEIR)
[![Python](https://img.shields.io/badge/python-3.14-blue)](https://python.org)
[![Django](https://img.shields.io/badge/django-5.0-092e20)](https://djangoproject.com)
[![MySQL](https://img.shields.io/badge/mysql-8.0-orange)](https://mysql.com)
[![Docker](https://img.shields.io/badge/docker-ready-2496ed)](https://docker.com)

---

## ¿Qué es TEIR?

TEIR conecta empresas con aprendices y egresados del SENA para desarrollar proyectos reales. Las empresas publican requerimientos, los desarrolladores se postulan, y la plataforma gestiona todo el ciclo: contratación, hitos, avances, revisión, finalización y calificación mutua.

|---

## Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                      USUARIOS                           │
│   Desarrollador           Empresa        Administrador  │
│   (postula, avanza)    (publica, revisa)  (gestiona)    │
└────────┬──────────────────────┬──────────────────┬──────┘
         │                      │                  │
         ▼                      ▼                  ▼
┌─────────────────────────────────────────────────────────┐
│                    DJANGO (MTV)                         │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐  │
│  │ usuarios │  │proyectos │  │ mensajes │  │  logs  │  │
│  ├──────────┤  ├──────────┤  ├──────────┤  ├────────┤  │
│  │avances   │  │postulac. │  │notificac.│  │favoritos│  │
│  ├──────────┤  ├──────────┤  └──────────┘  └────────┘  │
│  │contratac.│  │valoracion │                              │
│  └──────────┘  └──────────┘  9 apps modulares           │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────────────────┐
│                  INFRAESTRUCTURA                         │
│                                                         │
│   Nginx :80  ──▶  Gunicorn :8000  ──▶  MySQL :3306     │
│   (estáticos)     (3 workers)          (triggers SQL)    │
│                                                         │
│   Docker Compose  |  Health checks  |  Volúmenes        │
└─────────────────────────────────────────────────────────┘
```

**Flujo principal:**
```
Empresa publica proyecto → Dev se postula → Empresa acepta
→ Se crea contrato → Dev sube avances por hitos
→ Empresa revisa (acepta/rechaza) → Al completar todo
→ Empresa finaliza y califica → Dev califica a la empresa
```

---

## Stack

| Capa | Tecnología |
|------|-----------|
| Backend | Django 5.0, Python 3.14 |
| Base de datos | MySQL 8.0 (triggers de integridad y auditoría) |
| Frontend | Django Templates, Bootstrap 5, Vanilla JS |
| Testing | pytest, pytest-django, Playwright |
| Contenedores | Docker, docker-compose, Gunicorn, Nginx |

---

## Funcionalidades principales

- **Registro dual** — Desarrollador (DEV) y Empresa (CORP) con perfiles independientes
- **Publicación de proyectos** — Empresas crean proyectos con vacantes, tipo de solución y prioridad
- **Postulación y contratación** — Desarrolladores aplican, empresas aceptan/rechazan
- **Sistema de hitos** — La empresa define entregables, asigna a equipos o al proyecto general
- **Avances con evidencias** — El desarrollador registra avances con URL de evidencia obligatoria
- **Flujo de revisión** — La empresa acepta o rechaza avances con comentario obligatorio
- **Chat por proyecto** — Espacio de trabajo grupal y chat privado 1-a-1
- **Calificación mutua** — Al finalizar, empresa califica al desarrollador y viceversa
- **Dashboard administrativo** — Panel maestro con búsqueda, filtros, acciones en lote, estadísticas y ranking de talento
- **API REST administrativa** — Endpoints para gestión de usuarios (CRUD, activación/suspensión en lote)
- **Recuperación de contraseña** — Token criptográfico por email con expiración de 1 hora
- **Auditoría completa** — Log de cambios de estado, triggers de integridad en MySQL, historial de estados

---

## Inicio rápido (Docker)

```bash
git clone https://github.com/MrDylanDev/TEIR.git
cd TEIR

# Configurar variables de entorno (obligatorio)
cp docker/.env.docker.example .env
# Editar .env con tus claves secretas

# Importante: database/init.sql contiene el schema DDL.
# Los datos de prueba se borran en el primer deploy productivo.
docker compose up -d
```

La aplicación estará disponible en `http://localhost`.

Para crear el primer administrador:

```bash
docker exec teir_web python manage.py createsuperuser
```

---

## Desarrollo local

### Requisitos

- Python 3.14+
- MySQL 8.0+

### Instalación

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Configurar base de datos
cp docker/.env.docker.example .env
# Editar .env con tus credenciales de MySQL

python manage.py migrate
python manage.py runserver
```

### Variables de entorno

| Variable | Descripción | Default |
|----------|------------|---------|
| `DB_NAME` | Nombre de la base de datos | `tem_dbv2` |
| `DB_USER` | Usuario MySQL | `root` |
| `DB_PASSWORD` | Contraseña MySQL | — |
| `DB_HOST` | Host MySQL | `127.0.0.1` |
| `DJANGO_SECRET_KEY` | Clave secreta de Django | — |
| `DJANGO_DEBUG` | Modo debug | `False` |

---

## Estructura del proyecto

```
TEIR/
├── avances/           # Registro y revisión de avances
├── config/            # Configuración de Django (settings, urls, wsgi)
├── contrataciones/    # Gestión de contratos
├── database/          # Schema DDL y triggers MySQL
├── docker/            # Configuración de contenedores
│   ├── entrypoint.sh
│   ├── .env.docker.example
│   └── nginx/
├── docs/              # Documentación
│   ├── GUIA_USUARIO.md
│   ├── MANUAL_TECNICO.md
│   ├── API.md
│   └── DOCKER_README.md
├── favoritos/         # Proyectos guardados por el desarrollador
├── logs/              # Auditoría y reportes
├── mensajes/          # Chat y mensajería
├── notificaciones/    # Sistema de notificaciones
├── postulaciones/     # Postulaciones a proyectos
├── proyectos/         # Proyectos, hitos, equipos, valoraciones
├── static/            # CSS, JS, imágenes
├── templates/         # Templates Django por módulo
├── tests/             # Tests E2E con Playwright
├── usuarios/          # Autenticación, perfiles, dashboard admin
├── docker-compose.yml
├── Dockerfile
├── manage.py
├── requirements.txt
├── conftest.py        # Fixtures de pytest
├── pytest.ini         # Configuración de tests
├── README.md
└── LICENSE
```

---

## Tests

```bash
# Tests de backend
pytest . --ignore=tests/e2e -v

# Tests E2E (requiere Playwright)
pytest tests/e2e/ -v -m e2e

# Todos los tests
pytest -v
```

**117 tests** cubriendo todas las apps: usuarios, proyectos, postulaciones, contrataciones, avances, mensajes, favoritos, logs, notificaciones y tests end-to-end con navegador real.

---

## Documentación

- [Guía de Usuario](docs/GUIA_USUARIO.md) — Manual para los 3 roles (Desarrollador, Empresa, Administrador)
- [Manual Técnico](docs/MANUAL_TECNICO.md) — Arquitectura, modelos, API, testing, despliegue
- [API Reference](docs/API.md) — Endpoints REST del panel de administración
- [Docker Guide](docs/DOCKER_README.md) — Configuración detallada de contenedores

## Licencia

MIT License. Ver [LICENSE](LICENSE) para el texto completo.
