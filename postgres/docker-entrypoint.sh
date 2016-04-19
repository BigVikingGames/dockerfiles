#!/bin/bash
set -e

LISTEN_ADDRESSES=${LISTEN_ADDRESSES:-*}
MAX_CONNECTIONS=${MAX_CONNECTIONS:-100}
SHARED_BUFFERS=${SHARED_BUFFERS:-128MB}
EFFECTIVE_CACHE_SIZE=${EFFECTIVE_CACHE_SIZE:-1GB}
WORK_MEM=${WORK_MEM:-128MB}
MAINTENANCE_WORK_MEM=${MAINTENANCE_WORK_MEM:-1GB}
CHECKPOINT_COMPLETION_TARGET=${CHECKPOINT_COMPLETION_TARGET:-0.9}
DEFAULT_STATISTICS_TARGET=${DEFAULT_STATISTICS_TARGET:-500}
PASSWORD_ENCRYPTION=${PASSWORD_ENCRYPTION:-on}
MAX_WAL_SIZE=${MAX_WAL_SIZE:-1GB}
WAL_BUFFERS=${WAL_BUFFERS:-8MB}
LOG_MIN_DURATION_STATEMENT=${LOG_MIN_DURATION_STATEMENT:--1}
LOG_LINE_PREFIX=${LOG_LINE_PREFIX:-'%t - %u@%h/%d - '}
AUTO_EXPLAIN_LOG_ANALYZE=${AUTO_EXPLAIN_LOG_ANALYZE:-off}
AUTO_EXPLAIN_LOG_MIN_DURATION=${AUTO_EXPLAIN_LOG_MIN_DURATION:-10000}
SHARED_PRELOAD_LIBRARIES=${SHARED_PRELOAD_LIBRARIES:-'cstore_fdw, auto_explain, tablefunc'}

export LISTEN_ADDRESSES MAX_CONNECTIONS SHARED_BUFFERS EFFECTIVE_CACHE_SIZE WORK_MEM
export MAINTENANCE_WORK_MEM CHECKPOINT_COMPLETION_TARGET DEFAULT_STATISTICS_TARGET
export PASSWORD_ENCRYPTION MAX_WAL_SIZE WAL_BUFFERS LOG_MIN_DURATION_STATEMENT
export LOG_LINE_PREFIX AUTO_EXPLAIN_LOG_ANALYZE AUTO_EXPLAIN_LOG_MIN_DURATION
export SHARED_PRELOAD_LIBRARIES

if [ "$1" = 'postgres' ]; then
	mkdir -p "$PGDATA"
	chmod 700 "$PGDATA"
	chown -R postgres "$PGDATA"

	chmod g+s /run/postgresql
	chown -R postgres /run/postgresql

	# look specifically for PG_VERSION, as it is expected in the DB dir
	if [ ! -s "$PGDATA/PG_VERSION" ]; then
		gosu postgres initdb

		# check password first so we can output the warning before postgres
		# messes it up
		if [ "$POSTGRES_PASSWORD" ]; then
			pass="PASSWORD '$POSTGRES_PASSWORD'"
			authMethod=md5
		else
			# The - option suppresses leading tabs but *not* spaces. :)
			cat >&2 <<-'EOWARN'
				****************************************************
				WARNING: No password has been set for the database.
				         This will allow anyone with access to the
				         Postgres port to access your database. In
				         Docker's default configuration, this is
				         effectively any other container on the same
				         system.

				         Use "-e POSTGRES_PASSWORD=password" to set
				         it in "docker run".
				****************************************************
			EOWARN

			pass=
			authMethod=trust
		fi

		{ echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA/pg_hba.conf"

		# internal start of server in order to allow set-up using psql-client		
		# does not listen on TCP/IP and waits until start finishes
		gosu postgres pg_ctl -D "$PGDATA" \
			-o "-c listen_addresses=''" \
			-w start

		: ${POSTGRES_USER:=postgres}
		: ${POSTGRES_DB:=$POSTGRES_USER}
		export POSTGRES_USER POSTGRES_DB

		if [ "$POSTGRES_DB" != 'postgres' ]; then
			psql --username postgres <<-EOSQL
				CREATE DATABASE "$POSTGRES_DB" ;
			EOSQL
			echo
		fi

		if [ "$POSTGRES_USER" = 'postgres' ]; then
			op='ALTER'
		else
			op='CREATE'
		fi

		psql --username postgres <<-EOSQL
			$op USER "$POSTGRES_USER" WITH SUPERUSER $pass ;
		EOSQL
		echo

		echo
		for f in /docker-entrypoint-initdb.d/*; do
			case "$f" in
				*.sh)  echo "$0: running $f"; . "$f" ;;
				*.sql) 
					echo "$0: running $f"; 
					psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" < "$f"
					echo 
					;;
				*)     echo "$0: ignoring $f" ;;
			esac
			echo
		done

		gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

		# Generate postgresql.conf based on ENV
		eval "cat <<-EOF
			$(</postgresql.conf.tmpl)
			EOF" > ${PGDATA}/postgresql.conf

		echo
		echo 'PostgreSQL init process complete; ready for start up.'
		echo
	fi

	exec gosu postgres "$@"
fi

exec "$@"
