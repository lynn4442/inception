FROM alpine:3.21

RUN apk update && apk upgrade && apk add nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY conf/default.conf /etc/nginx/http.d/default.conf
COPY tools/script.sh /script.sh

RUN chmod +x /script.sh

CMD ["/script.sh"]