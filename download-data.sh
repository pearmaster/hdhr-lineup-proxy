#!/bin/sh

LINEUP_FILE="/data/lineup.json"

function make_file() {
    TUNER=$1
    DEVICE_ID=$2
    hdhomerun_config scan ${HDHR_IP_ADDR} ${TUNER} /tmp/scanresults.txt
    /usr/bin/python3 /usr/local/share/convert_lineup.py ${DEVICE_ID} /tmp/scanresults.txt ${LINEUP_FILE}
    return $?
}

if [ -n "${HDHR_IP_ADDR}" ]; then
    if [ ! -f "${LINEUP_FILE}"  ]; then
        DEVICE_ID=$(wget -q http://${HDHR_IP_ADDR}/discover.json -O - | jq -r '.DeviceId')
        if [ -n "$DEVICE_ID" ]; then
            hdhomerun_config ${HDHR_IP_ADDR} get /tuner0/status | grep 'ch=none' > /dev/null
            if [ $? -eq 0 ]; then
                make_file 0 $DEVICE_ID
                exit $?
            else
                hdhomerun_config ${HDHR_IP_ADDR} get /tuner1/status | grep 'ch=none' > /dev/null
                if [ $? -eq 0 ]; then
                    make_file 1 $DEVICE_ID
                    exit $?
                else
                    echo "Tuner not available" >&2
                    exit 1
                fi
            fi
        else
            echo "Could not find DeviceId" >&2
        fi
    else
        echo "Lineup file already exists" >&2
        exit 0
    fi
else
    echo "HDHR IP Address not provided" >&2
fi

exit 1