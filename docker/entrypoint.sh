#!/bin/bash
# ============================================================
# TEIR - Docker Entrypoint
# InicializaciÃ³n automÃ¡tica del contenedor web
# ============================================================

set -e

echo "============================================"
echo "  ðŸš€ TEIR - Iniciando aplicaciÃ³n..."
echo "============================================"

# ---- 1. Esperar a que MySQL estÃ© listo ----
echo ""
echo "â³ Esperando conexiÃ³n con MySQL..."

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
        echo "âŒ No se pudo conectar a MySQL despuÃ©s de $MAX_RETRIES intentos"
        exit 1
    fi
    echo "   Intento $RETRY_COUNT/$MAX_RETRIES - MySQL no estÃ¡ listo, esperando 2s..."
    sleep 2
done

echo "âœ… ConexiÃ³n con MySQL establecida"

# ---- 2. Aplicar migraciones ----
echo ""
echo "ðŸ“¦ Aplicando migraciones de Django..."
python manage.py migrate --noinput
echo "âœ… Migraciones aplicadas correctamente"

# ---- 3. Recoger archivos estÃ¡ticos ----
echo ""
echo "ðŸ“ Recolectando archivos estÃ¡ticos..."
python manage.py collectstatic --noinput
echo "âœ… Archivos estÃ¡ticos recolectados"

# ---- 4. Iniciar Gunicorn ----
echo ""
echo "============================================"
echo "  âœ… TEIR listo - Iniciando Gunicorn"
echo "  ðŸ“¡ Escuchando en 0.0.0.0:8000"
echo "  ðŸ‘· Workers: 3"
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
