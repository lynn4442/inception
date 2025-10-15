#!/bin/sh
set -e

# Generate SSL certificates if they don't exist
if [ ! -f "/etc/nginx/ssl/nginx.key" ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
    chmod 600 /etc/nginx/ssl/nginx.key
    chmod 644 /etc/nginx/ssl/nginx.crt
fi

# Replace environment variables in configuration
envsubst '${DOMAIN_NAME} ${WORDPRESS_HOST} ${WORDPRESS_PORT}' < /etc/nginx/templates/default.conf.template > /etc/nginx/http.d/default.conf

exec /usr/sbin/nginx -g "daemon off;"
