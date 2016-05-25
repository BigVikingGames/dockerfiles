#!/usr/bin/env bash
set -e

WAIT=${WAIT:-0}
MIGRATE=${MIGRATE:-true}

# wait for postgres?
if [[ "${WAIT}" -gt 0 ]]; then
    echo "Sleep for ${WAIT}..."
    sleep $WAIT
fi

if [[ "${MIGRATE}" -eq "true" ]]; then
    # Run sentry migrations
    /usr/local/bin/sentry upgrade --noinput
fi

case "$1" in
    "")
        # start all services with supervisor
        exec /usr/bin/supervisord
        ;;
    *)
        exec $@
        ;;
esac
