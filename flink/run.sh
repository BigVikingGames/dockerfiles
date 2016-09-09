#!/usr/bin/env bash

JOBMANAGER_RPC_ADDRESS=${JOBMANAGER_RPC_ADDRESS:-$(hostname)}
JOBMANAGER_RPC_PORT=${JOBMANAGER_RPC_PORT:-6123}
JOBMANAGER_HEAP_MB=${JOBMANAGER_HEAP_MB:-256}
JOBMANAGER_WEB_PORT=${JOBMANAGER_WEB_PORT:-8081}

TASKMANAGER_HEAP_MB=${TASKMANAGER_HEAP_MB:-512}
TASKMANAGER_SLOTS=${TASKMANAGER_SLOTS:-1}
TASKMANAGER_MEMORY_PREALLOCATE=${TASKMANAGER_MEMORY_PREALLOCATE:-false}

eval "cat <<-EOF
	$(</flink-conf.yaml.tmpl)
	EOF" > ${FLINK_HOME}/conf/flink-conf.yaml

case $1 in
	jobmanager)
		${FLINK_HOME}/bin/jobmanager.sh start cluster
		;;
	taskmanager)
		${FLINK_HOME}/bin/taskmanager.sh start
		;;
	*)
		exec $@
		;;
esac
