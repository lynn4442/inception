FROM alpine:3.21

RUN apk update && apk upgrade && apk add \
    php83-fpm \
    php83-mysqli \
    php83-phar \
    curl && \
    ln -sf /usr/bin/php83 /usr/bin/php
# php83-mysqli -->  MySQL/MariaDB extension for PHP
# curl --> tool for transferring data with URLs

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/script.sh /script.sh

RUN chmod +x /script.sh

CMD ["./script.sh"]




# FROM alpine:3.21

# RUN apk update && apk upgrade && apk add \
#     php83-fpm \
#     php83-mysqli \
#     php83-json \
#     php83-curl \
#     php83-dom \
#     php83-exif \
#     php83-fileinfo \
#     php83-mbstring \
#     php83-openssl \
#     php83-xml \
#     php83-zip \
#     php83-phar \
#     mysql-client \
#     curl && \
#     ln -sf /usr/bin/php83 /usr/bin/php

# COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
# COPY tools/script.sh /script.sh

# RUN chmod +x /script.sh

# CMD ["./script.sh"]