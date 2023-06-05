#!/bin/sh

/docker-entrypoint.d/30-download-data.sh

exit $?
