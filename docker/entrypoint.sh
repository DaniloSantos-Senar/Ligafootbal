#!/usr/bin/env bash
set -e

cd /var/www || exit 1

# Ajusta permissões (ignora erros caso diretórios não existam ainda)
if [ -d storage ] && [ -d bootstrap/cache ]; then
    chown -R www-data:www-data storage bootstrap/cache || true
    chmod -R 775 storage bootstrap/cache || true
fi

# Gera chave do Laravel se necessário
if [ -f artisan ] && [ -f .env ]; then
    if grep -q "^APP_KEY=$" .env; then
        php artisan key:generate --force || true
    fi
fi

# Executa o comando padrão do container
exec "$@"
