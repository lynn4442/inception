#!/bin/sh
mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/CN=lyoussef.42.fr"

exec nginx -g "daemon off;"