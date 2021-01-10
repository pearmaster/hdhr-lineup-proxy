FROM nginx:mainline-alpine

RUN apk add --no-cache wget
RUN apk add --no-cache jq

COPY ./download-data.sh /docker-entrypoint.d/30-download-data.sh
COPY ./proxy.conf /etc/nginx/conf.d/proxy.conf

VOLUME /data
