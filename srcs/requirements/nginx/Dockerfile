FROM alpine:3.21

# Install nginx, openssl, and gettext (for envsubst)
RUN apk add --no-cache nginx openssl gettext

# Create directories
RUN mkdir -p /etc/nginx/ssl /etc/nginx/templates

# Copy configuration templates
COPY ssl/generate_ssl.sh /generate_ssl.sh
COPY conf/default /etc/nginx/templates/default.conf.template
COPY conf/http-redirect.conf /etc/nginx/templates/http-redirect.conf.template
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions
RUN chmod +x /generate_ssl.sh

# Copy startup script
COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]