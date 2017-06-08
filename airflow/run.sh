#!/usr/bin/env bash
set -e

# Just in case you're doing it wrong
if [ "$1" == "" ]; then
    echo "Usage: ./run.sh [migrate|airflow|webserver|worker|scheduler|flower|*]"
    exit 1
fi

# Dynamic requirements target, used for local development
REQUIREMENTS=${REQUIREMENTS:-requirements.txt}

# Requirements files in $AIRFLOW_HOME are assumed to be part of local development
# for deployments these requirements should already be installed in the image
if [ -f "${AIRFLOW_HOME}/${REQUIREMENTS}" ]; then
    pip install -r ${AIRFLOW_HOME}/${REQUIREMENTS}
fi

# Generate airflow.cfg from ENV
./generate_config.py > ${AIRFLOW_HOME}/airflow.cfg

echo $GCLOUD_SERVICE_ACCOUNT_CREDS > /tmp/creds.json
gcloud auth activate-service-account $GCLOUD_SERVICE_ACCOUNT --key-file=/tmp/creds.json
rm /tmp/creds.json

case $1 in
    migrate)
        if [ "${FLYWAY_URL}" != "" ]; then
            flyway -url="${FLYWAY_URL}" migrate
        else
            echo "Skipping flyway migrations! Please set the FLYWAY_URL variable if you wish to run additional migrations."
        fi
        gosu airflow airflow initdb
        gosu airflow airflow upgradedb
        ;;
    airflow)
        exec gosu airflow $@
        ;;
    webserver)
        exec gosu airflow airflow webserver
        ;;
    worker)
        exec gosu airflow airflow worker
        ;;
    scheduler)
        exec gosu airflow airflow scheduler
        ;;
    flower)
        exec gosu airflow airflow flower
        ;;
    *)
        exec $@
        ;;
esac
