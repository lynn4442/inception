#!/bin/sh

# Initialize database
mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Start MariaDB in background
mysqld --user=mysql --datadir=/var/lib/mysql &

# Wait for MariaDB to start
sleep 5

# Create database and user using environment variables
mysql -u root <<-EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop background MariaDB
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MariaDB in foreground
exec mysqld --user=mysql --datadir=/var/lib/mysql



# #!/bin/sh

# # Initialize database if not exists
# if [ ! -d "/var/lib/mysql/mysql" ]; then
#     mysql_install_db --user=mysql --datadir=/var/lib/mysql
# fi

# # Create init SQL file
# cat << EOF > /tmp/init.sql
# CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
# CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
# GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
# ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
# FLUSH PRIVILEGES;
# EOF

# # Start MariaDB with init script
# exec mysqld --user=mysql --datadir=/var/lib/mysql --init-file=/tmp/init.sql