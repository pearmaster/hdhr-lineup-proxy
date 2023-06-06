#!/bin/sh

DISCOVER_FILE=/data/discover.json
export MY_IP=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

wget http://${HDHR_IP_ADDR}/discover.json -O ${DISCOVER_FILE}.new

sed -i 's/https:/http:/g' ${DISCOVER_FILE}.new

sed -i "s/api.hdhomerun.com/${MY_IP}/g" ${DISCOVER_FILE}.new

mv ${DISCOVER_FILE}.new ${DISCOVER_FILE}

cat ${DISCOVER_FILE}

exit 0
