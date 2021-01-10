#!/bin/sh

LINEUP_FILE="/data/lineup.json"

if [ -n "${HDHR_IP_ADDR}" ]; then
    if [ ! -f "${LINEUP_FILE}"  ]; then
        LINEUP_URL=$(wget -q http://${HDHR_IP_ADDR}/discover.json -O - | jq -r '.LineupURL')
        if [ -n "$LINEUP_URL" ]; then
            wget -q ${LINEUP_URL} -O ${LINEUP_FILE}
            WGET_RC=$?
            if [ "$WGET_RC" -ne 0 ]; then
                echo "wget failure to get line up" >&2
            fi
            return $WGET_RC
        else
            echo "Could not find Lineup URL" >&2
        fi
    else
        echo "Lineup file already exists" >&2
        exit 0
    fi
else
    echo "HDHR IP Address not provided" >&2
fi

exit 1
