#!/bin/bash

# Create symlink for php command
ln -sf /usr/bin/php82 /usr/bin/php

cd /var/www/html

# Download wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Download WordPress with increased memory limit
php -d memory_limit=256M wp-cli.phar core download --allow-root

# Wait for MariaDB to be ready (max 60 seconds)
echo "Waiting for MariaDB to be ready..."
for i in {60..0}; do
    if php -r "new mysqli('${MYSQL_HOST}', '${MYSQL_USER}', '${MYSQL_PASSWORD}', '${MYSQL_DATABASE}');" 2>/dev/null; then
        echo "MariaDB is up - continuing..."
        break
    fi
    echo "MariaDB is unavailable - sleeping ($i seconds remaining)"
    sleep 1
done

if [ "$i" = 0 ]; then
    echo "MariaDB connection failed after 60 seconds"
    exit 1
fi

# Create wp-config
./wp-cli.phar config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=${MYSQL_HOST} \
    --allow-root

# Install WordPress
./wp-cli.phar core install \
    --url=${WP_URL} \
    --title="${WP_TITLE}" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --allow-root

# Start PHP-FPM
exec php-fpm82 -F