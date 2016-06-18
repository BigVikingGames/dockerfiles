#!/usr/bin/env bash

APP_ENV=${APP_ENV:-development}
APP_DEBUG=${APP_DEBUG:-true}
APP_URL=${APP_URL:-http://localhost}
APP_KEY=${APP_KEY:-null}

DB_DRIVER=${DB_DRIVER:-pgsql}
DB_HOST=${DB_HOST:-postgres}
DB_DATABASE=${DB_DATABASE:-cachet}
DB_USERNAME=${DB_USERNAME:-postgres}
DB_PASSWORD=${DB_PASSWORD:-postgres}
DB_PORT=${DB_PORT:-5432}

CACHE_DRIVER=${CACHE_DRIVER:-apc}
SESSION_DRIVER=${SESSION_DRIVER:-apc}
QUEUE_DRIVER=${QUEUE_DRIVER:-database}

MAIL_DRIVER=${MAIL_DRIVER:-smtp}
MAIL_HOST=${MAIL_HOST:-smtp.gmail.com}
MAIL_PORT=${MAIL_PORT:-587}
MAIL_USERNAME=${MAIL_USERNAME:-null}
MAIL_PASSWORD=${MAIL_PASSWORD:-null}
MAIL_ADDRESS=${MAIL_ADDRESS:-null}
MAIL_NAME=${MAIL_NAME:-null}

REDIS_HOST=${REDIS_HOST:-null}
REDIS_DATABASE=${REDIS_DATABASE:-null}
REDIS_PORT=${REDIS_PORT:-null}

if [ "$APP_KEY" == "null" ] || [ ${#APP_KEY} -lt 32 ]; then
	echo "You must specify an APP_KEY of at least 32 characters!"
    echo ${#APP_KEY}
	exit 1
fi

eval "cat <<-EOF
	$(</srv/app/env.tmpl)
	EOF" > /srv/app/.env
chown www-data:www-data /srv/app/.env

if [ ! -f /srv/app/.migrated ]; then
	sleep 5 # wait for db
	cd /srv/app
	/usr/bin/php artisan migrate && touch .migrated
fi

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
