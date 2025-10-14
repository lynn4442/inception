#!/bin/sh

# Exit on error
set -e

# Generate SSL certificates
/generate_ssl.sh

# Replace environment variables in configuration templates
envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template > /etc/nginx/http.d/default.conf
envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/http-redirect.conf.template > /etc/nginx/http.d/http-redirect.conf

# Test NGINX configuration
nginx -t

# Start NGINX
exec /usr/sbin/nginx -g "daemon off;"
