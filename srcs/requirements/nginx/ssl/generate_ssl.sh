#!/bin/bash

# Generate SSL certificates for the domain
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME:-lynny.42.fr}"

# Set proper permissions
chmod 600 /etc/nginx/ssl/nginx.key
chmod 644 /etc/nginx/ssl/nginx.crt
