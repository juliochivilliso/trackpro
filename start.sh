#!/bin/sh
set -e

echo ">>> Corriendo migraciones de base de datos..."
cd /api && npx prisma migrate deploy

echo ">>> Iniciando servicios con supervisord..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
