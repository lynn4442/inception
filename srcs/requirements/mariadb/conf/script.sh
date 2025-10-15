#!/bin/bash
set -euo pipefail

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql || exit 1
    mysqld --user=mysql --datadir=/var/lib/mysql \
        --skip-networking --socket=/run/mysqld/mysqld.sock &
    pid=$!

    for i in {30..0}; do
        mysqladmin ping --socket=/run/mysqld/mysqld.sock \
            &>/dev/null && break
        [ "$i" = 0 ] && exit 1
        sleep 1
    done

    mysql --socket=/run/mysqld/mysqld.sock -e "
        ALTER USER 'root'@'localhost' \
            IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        DELETE FROM mysql.user \
            WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');
        DELETE FROM mysql.user WHERE User='';
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' \
            IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* \
            TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;"

    mysqladmin shutdown --socket=/run/mysqld/mysqld.sock
    wait $pid
fi

exec mysqld --user=mysql --console \
    --skip-networking=0 --bind-address=0.0.0.0 --port=3306