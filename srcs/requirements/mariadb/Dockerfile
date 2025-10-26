FROM alpine:3.21

RUN apk add --no-cache mariadb mariadb-client

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/script.sh /script.sh

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld && \
    chmod +x /script.sh

CMD ["/script.sh"]