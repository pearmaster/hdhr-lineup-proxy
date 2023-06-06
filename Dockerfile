FROM nginx:mainline-alpine

RUN apk add --no-cache wget
RUN apk add --no-cache jq
RUN apk add --no-cache make
RUN apk add --no-cache gcc
RUN apk add --no-cache musl-dev
RUN apk add --no-cache python3

VOLUME /data

ADD http://download.silicondust.com/hdhomerun/libhdhomerun_20210624.tgz /tmp
RUN cd /tmp && tar zxvf libhdhomerun_20210624.tgz && cd libhdhomerun && make && cp hdhomerun_config /usr/local/bin

RUN apk del musl-dev && apk del gcc && rm -rf libhdhomerun_20210624.tgz libhdhomerun

COPY ./download-data.sh /docker-entrypoint.d/30-download-data.sh
COPY ./download-discovery.sh /docker-entrypoint.d/31-download-discovery.sh
RUN chmod a+x /docker-entrypoint.d/31-download-discovery.sh
COPY ./proxy.conf /etc/nginx/conf.d/proxy.conf
COPY ./convert_lineup.py /usr/local/share/convert_lineup.py
COPY ./periodic.sh /etc/periodic/weekly/refresh_lineup.sh
RUN ln -s /docker-entrypoint.d/31-download-discovery.sh /etc/periodic/15m/refresh_discover.sh
