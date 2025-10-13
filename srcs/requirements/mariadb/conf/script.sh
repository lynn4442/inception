#!/bin/bash

# Fix permissions
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 755 /var/lib/mysql

# Initialize database if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start temporary instance with socket only
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    pid="$!"
    
    # Wait for socket to be ready (max 30 seconds)
    echo "Waiting for MariaDB socket..."
    for i in {30..0}; do
        if mysqladmin ping --socket=/run/mysqld/mysqld.sock &> /dev/null; then
            break
        fi
        echo "Waiting for MariaDB to start... ($i seconds remaining)"
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "MariaDB failed to start"
        exit 1
    fi
    
    # Run init script using environment variables
    echo "Running initialization script..."
    mysql --socket=/run/mysqld/mysqld.sock << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF
    
    # Stop temporary instance
    echo "Stopping temporary instance..."
    mysqladmin shutdown --socket=/run/mysqld/mysqld.sock
    wait "$pid"
fi

# Start MariaDB normally
echo "Starting MariaDB..."
exec mysqld --user=mysql --console --skip-networking=0 --bind-address=0.0.0.0 --port=3306	