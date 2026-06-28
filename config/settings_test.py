import os
os.environ.setdefault('DJANGO_ALLOW_ASYNC_UNSAFE', 'True')

from .settings import *

# Use SQLite in-memory for fast, isolated tests
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
        'TEST': {
            'NAME': ':memory:',
        },
    }
}

# Disable password validators during tests (speed)
AUTH_PASSWORD_VALIDATORS = []

# Use fast password hasher
PASSWORD_HASHERS = [
    'django.contrib.auth.hashers.MD5PasswordHasher',
]

# Disable CSRF for API-like test client calls
TESTING = True

# Disable email sending during tests
EMAIL_BACKEND = 'django.core.mail.backends.locmem.EmailBackend'

# Use console cache for tests
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    }
}


# Migration 0005 uses SeparateDatabaseAndState with empty database_operations
# (column renamed manually in MySQL). SQLite needs the rename applied.
# We monkey-patch the migration class at import time.
import importlib
from django.db.migrations.state import ProjectState
from django.db.migrations.executor import MigrationExecutor

_original_apply = MigrationExecutor._migrate_all_forwards


def _patched_migrate_all_forwards(executor, *args, **kwargs):
    """After all migrations, rename cedula→identificacion if on SQLite."""
    result = _original_apply(executor, *args, **kwargs)
    from django.db import connection
    if connection.vendor == 'sqlite':
        with connection.cursor() as cursor:
            try:
                cursor.execute(
                    "ALTER TABLE usuarios RENAME COLUMN cedula TO identificacion"
                )
            except Exception:
                pass
    return result


MigrationExecutor._migrate_all_forwards = _patched_migrate_all_forwards
