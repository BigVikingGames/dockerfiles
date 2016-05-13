#!/usr/bin/env bash
set -ex

if [ ! -z $POSTGRES_PORT_5432_TCP_ADDR ]; then
  export DATABASE_HOST="${POSTGRES_PORT_5432_TCP_ADDR}"
fi

if [ ! -z $POSTGRES_PORT_5432_TCP_PORT ]; then
  export DATABASE_PORT="${POSTGRES_PORT_5432_TCP_PORT}"
fi

cd $RATTIC_HOME
./generate_config.py > ./RatticWeb/conf/local.cfg

cd RatticWeb
./manage.py syncdb --noinput
./manage.py migrate --all
./manage.py collectstatic --noinput

exec /usr/bin/supervisord
