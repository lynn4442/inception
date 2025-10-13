FROM alpine:3.21

# Install nginx and openssl
RUN apk add --no-cache nginx openssl

# Create directories
RUN mkdir -p /etc/nginx/ssl

# Copy configuration files
COPY ssl/generate_ssl.sh /generate_ssl.sh
COPY conf/default /etc/nginx/http.d/default.conf
COPY conf/http-redirect.conf /etc/nginx/http.d/http-redirect.conf
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions
RUN chmod +x /generate_ssl.sh

# Create startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo '/generate_ssl.sh' >> /start.sh && \
    echo '/usr/sbin/nginx -g "daemon off;"' >> /start.sh && \
    chmod +x /start.sh

CMD ["/start.sh"]