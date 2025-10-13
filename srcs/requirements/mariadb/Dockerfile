FROM alpine:3.21

# Install packages in one layer for better caching
RUN apk add --no-cache \
    mariadb \
    mariadb-client \
    bash

# Create directories and set permissions
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    chmod 755 /var/lib/mysql

# Copy configuration files
COPY conf/50-server.cnf /etc/mysql/conf.d/50-server.cnf
COPY conf/script.sh /script.sh

# Set permissions
RUN chmod +x /script.sh

EXPOSE 3306

CMD ["/script.sh"]