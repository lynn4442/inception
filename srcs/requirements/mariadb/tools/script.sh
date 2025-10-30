#!/bin/sh

mysql_install_db --user=mysql --datadir=/var/lib/mysql

# creayting the init.sql file
echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};" > /tmp/init.sql
echo "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> /tmp/init.sql
echo "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';" >> /tmp/init.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';" >> /tmp/init.sql
echo "FLUSH PRIVILEGES;" >> /tmp/init.sql

# satrting the file
exec mysqld --user=mysql --init-file=/tmp/init.sql