FROM alpine:3.21

# Install packages in one layer for better caching
RUN apk add --no-cache \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-phar \
    curl \
    bash

# Create directories and set permissions
RUN mkdir -p /var/www/html && \
    chown -R nobody:nobody /var/www/html

# Copy configuration files
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY conf/script.sh /script.sh

# Set permissions
RUN chmod +x /script.sh

EXPOSE 9000

CMD ["/script.sh"]