#!/bin/bash
set -euo pipefail

ln -sf /usr/bin/php82 /usr/bin/php
cd /var/www/html

if [ ! -f "wp-cli.phar" ]; then
    curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

[ ! -f "index.php" ] && \
    php -d memory_limit=256M wp-cli.phar core download --allow-root

while ! php -r "new mysqli('${MYSQL_HOST}','${MYSQL_USER}','${MYSQL_PASSWORD}','${MYSQL_DATABASE}');" 2>/dev/null; do
    sleep 1
done

if [ ! -f "wp-config.php" ]; then
    ./wp-cli.phar config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=${MYSQL_HOST} \
        --allow-root
fi

if ! ./wp-cli.phar core is-installed --allow-root 2>/dev/null; then
    ./wp-cli.phar core install \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
fi

exec php-fpm82 -F
