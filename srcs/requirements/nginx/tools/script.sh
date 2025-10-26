#!/bin/sh

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=LB/ST=Mont-Liban/L=Baabda/O=42/OU=42/CN=lynny.42.fr"

exec nginx -g "daemon off;"