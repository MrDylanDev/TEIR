#!/bin/bash
# ============================================================
# TEIR - Docker Entrypoint
# Inicializacion automatica del contenedor web
# ============================================================

set -e

echo "============================================"
echo "  TEIR - Iniciando aplicacion..."
echo "============================================"

# ---- 1. Esperar a que MySQL este listo ----
echo ""
echo "Esperando conexion con MySQL..."

MAX_RETRIES=30
RETRY_COUNT=0

while ! python -c "
import pymysql
pymysql.connect(
    host='${DB_HOST:-db}',
    port=int('${DB_PORT:-3306}'),
    user='${DB_USER:-teir_user}',
    password='${DB_PASSWORD:-teir_secure_pass_2026}',
    database='${DB_NAME:-tem_dbv2}'
)
print('OK')
" 2>/dev/null; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        echo "[ERROR] No se pudo conectar a MySQL despues de $MAX_RETRIES intentos"
        exit 1
    fi
    echo "   Intento $RETRY_COUNT/$MAX_RETRIES - MySQL no esta listo, esperando 2s..."
    sleep 2
done

echo "[OK] Conexion con MySQL establecida"

# ---- 2. Aplicar migraciones ----
echo ""
echo "Aplicando migraciones de Django..."
python manage.py migrate --noinput
echo "[OK] Migraciones aplicadas correctamente"

# ---- 3. Recoger archivos estaticos ----
echo ""
echo "Recolectando archivos estaticos..."
python manage.py collectstatic --noinput
echo "[OK] Archivos estaticos recolectados"

# ---- 4. Iniciar Gunicorn ----
echo ""
echo "============================================"
echo "  TEIR listo - Iniciando Gunicorn"
echo "  Escuchando en 0.0.0.0:8000"
echo "  Workers: 3"
echo "============================================"
echo ""

exec gunicorn config.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --worker-class gthread \
    --threads 2 \
    --worker-tmp-dir /dev/shm \
    --timeout 120 \
    --graceful-timeout 30 \
    --keep-alive 5 \
    --max-requests 1000 \
    --max-requests-jitter 50 \
    --access-logfile - \
    --error-logfile - \
    --log-level info \
    --capture-output
