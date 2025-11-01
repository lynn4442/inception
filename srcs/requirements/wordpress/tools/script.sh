#!/bin/sh

cd /var/www/html

# wait a bit for maria-db to finish
sleep 10

# download wp-cli from the original repo
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

php -d memory_limit=256M ./wp-cli.phar core download --allow-root

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
