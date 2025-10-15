FROM alpine:3.21

RUN apk add --no-cache nginx openssl gettext && \
    mkdir -p /etc/nginx/ssl /etc/nginx/templates

COPY conf/default /etc/nginx/templates/default.conf.template
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
