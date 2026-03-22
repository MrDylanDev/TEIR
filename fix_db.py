import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from django.db import connection

try:
    with connection.cursor() as cursor:
        cursor.execute("CREATE USER IF NOT EXISTS 'dylan'@'localhost' IDENTIFIED BY 'dylan123';")
        cursor.execute("GRANT ALL PRIVILEGES ON *.* TO 'dylan'@'localhost';")
        cursor.execute("FLUSH PRIVILEGES;")
    print("FIX_SUCCESS")
except Exception as e:
    print(f"FIX_ERROR: {e}")
