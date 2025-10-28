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

# #!/bin/sh

# cd /var/www/html

# # Wait for MariaDB properly
# until mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT 1" >/dev/null 2>&1; do
#     echo "Waiting for MariaDB..."
# done

# # Download WP-CLI if not exists
# if [ ! -f wp-cli.phar ]; then
#     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#     chmod +x wp-cli.phar
# fi

# # Download WordPress if not exists
# if [ ! -f wp-config.php ]; then
#     ./wp-cli.phar core download --allow-root

#     # Create wp-config.php
#     ./wp-cli.phar config create \
#         --dbname=${MYSQL_DATABASE} \
#         --dbuser=${MYSQL_USER} \
#         --dbpass=${MYSQL_PASSWORD} \
#         --dbhost=mariadb \
#         --allow-root

#     # Install WordPress
#     ./wp-cli.phar core install \
#         --url=https://${DOMAIN_NAME} \
#         --title="Inception" \
#         --admin_user=${WP_ADMIN_USER} \
#         --admin_password=${WP_ADMIN_PASSWORD} \
#         --admin_email=${WP_ADMIN_EMAIL} \
#         --allow-root

#     # Create regular user
#     ./wp-cli.phar user create \
#         ${WP_USER} \
#         ${WP_USER_EMAIL} \
#         --role=author \
#         --user_pass=${WP_USER_PASSWORD} \
#         --allow-root
# fi

# # Start PHP-FPM
# exec php-fpm83 -F

# #!/bin/sh

# cd /var/www/html

# # Wait for MariaDB properly
# until mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT 1" >/dev/null 2>&1; do
#     echo "Waiting for MariaDB..."
# done

# # Download WP-CLI if not exists
# if [ ! -f wp-cli.phar ]; then
#     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#     chmod +x wp-cli.phar
# fi

# # Download WordPress if not exists
# if [ ! -f wp-config.php ]; then
#     ./wp-cli.phar core download --allow-root

#     # Create wp-config.php
#     ./wp-cli.phar config create \
#         --dbname=${MYSQL_DATABASE} \
#         --dbuser=${MYSQL_USER} \
#         --dbpass=${MYSQL_PASSWORD} \
#         --dbhost=mariadb \
#         --allow-root

#     # Install WordPress
#     ./wp-cli.phar core install \
#         --url=https://${DOMAIN_NAME} \
#         --title="Inception" \
#         --admin_user=${WP_ADMIN_USER} \
#         --admin_password=${WP_ADMIN_PASSWORD} \
#         --admin_email=${WP_ADMIN_EMAIL} \
#         --allow-root

#     # Create regular user
#     ./wp-cli.phar user create \
#         ${WP_USER} \
#         ${WP_USER_EMAIL} \
#         --role=author \
#         --user_pass=${WP_USER_PASSWORD} \
#         --allow-root
# fi

# # Start PHP-FPM
# exec php-fpm83 -F