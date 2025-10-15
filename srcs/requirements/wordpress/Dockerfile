FROM alpine:3.21
RUN apk add --no-cache php82-fpm php82-mysqli php82-json php82-curl php82-dom php82-exif php82-fileinfo php82-mbstring php82-openssl php82-xml php82-zip php82-phar curl bash && \
    mkdir -p /var/www/html && chown -R nobody:nobody /var/www/html
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY conf/script.sh /script.sh
RUN chmod +x /script.sh
EXPOSE 9000
CMD ["/script.sh"]
