FROM alpine:3.21

RUN apk add --no-cache mariadb mariadb-client bash && \
    mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    chmod 755 /var/lib/mysql

COPY conf/script.sh /script.sh
RUN chmod +x /script.sh

EXPOSE 3306
CMD ["/script.sh"]
