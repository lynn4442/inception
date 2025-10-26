#!/bin/sh

cd /var/www/html

# Wait for MariaDB
sleep 10

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# Download WordPress
./wp-cli.phar core download --allow-root

# Create wp-config.php
./wp-cli.phar config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=mariadb \
    --allow-root

# Install WordPress
./wp-cli.phar core install \
    --url=${DOMAIN_NAME} \
    --title="Inception" \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --allow-root

# Start PHP-FPM
exec php-fpm83 -F