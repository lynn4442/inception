#!/bin/sh

# Exit on error
set -e

# Check if DOMAIN_NAME is set
if [ -z "${DOMAIN_NAME}" ]; then
    echo "ERROR: DOMAIN_NAME environment variable is not set"
    exit 1
fi

# Generate SSL certificates for the domain if they don't exist
if [ ! -f "/etc/nginx/ssl/nginx.key" ] || [ ! -f "/etc/nginx/ssl/nginx.crt" ]; then
    echo "Generating SSL certificates for ${DOMAIN_NAME}..."
    if ! openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"; then
        echo "ERROR: Failed to generate SSL certificates"
        exit 1
    fi

    # Set proper permissions
    chmod 600 /etc/nginx/ssl/nginx.key
    chmod 644 /etc/nginx/ssl/nginx.crt
    echo "SSL certificates generated successfully"
else
    echo "SSL certificates already exist"
fi
