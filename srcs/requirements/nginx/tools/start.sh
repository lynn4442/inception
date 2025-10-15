#!/bin/sh
set -e

# Generate SSL certificates if they don't exist
if [ ! -f "/etc/nginx/ssl/nginx.key" ] || [ ! -f "/etc/nginx/ssl/nginx.crt" ]; then
    echo "Generating SSL certificates for ${DOMAIN_NAME}..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"
    chmod 600 /etc/nginx/ssl/nginx.key
    chmod 644 /etc/nginx/ssl/nginx.crt
fi

# Replace environment variables in configuration templates
envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/http.d/default.conf

# Test and start NGINX
nginx -t
exec /usr/sbin/nginx -g "daemon off;"
