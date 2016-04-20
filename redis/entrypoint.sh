#!/bin/bash
set -e

# This is a modified version of the official redis docker-entrypoint.sh
# such that we can customize the config to our needs, including setting
# the `requirepass` attribute. Below are our defaults.

REDIS_MAXCLIENTS=${REDIS_MAXCLIENTS:-100}
REDIS_MAXMEMORY=${REDIS_MAXMEMORY:-32M}
REDIS_MAXMEMORY_POLICY=${REDIS_MAXMEMORY_POLICY:-noeviction}
REDIS_REQUIREPASS=${REDIS_REQUIREPASS:-redis}

export REDIS_MAXCLIENTS REDIS_MAXMEMORY REDIS_MAXMEMORY_POLICY REDIS_REQUIREPASS

eval "cat <<-EOF
	$(</redis.conf.tmpl)
	EOF" > /data/redis.conf

# allow the container to be started with `--user`
if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
	chown -R redis .
	exec gosu redis "$0" "$@"
fi

exec "$@"
