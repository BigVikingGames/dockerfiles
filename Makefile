# vim: noexpandtab filetype=make
SHELL:=/usr/bin/env bash
ORG:=bigvikinggames
DOCKER:=docker
PUSH:=false

# HAHA! I lied there is a default task!
default:
	@echo "Please read Makefile, there is no default task!"

.PHONY: ubuntu notebook nodejs postgres gitlab-runner java flyway airflow node-red ratticdb sentry php-fpm ruby cachet cachet-monitor minio confluent-platform kafka-connect

all: ubuntu python java flyway airflow nodejs node-red postgres gitlab-runner cachet cachet-monitor notebook

ubuntu notebook nodejs postgres gitlab-runner php-fpm ruby cachet-monitor minio confluent-platform kafka-connect:
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

python: ubuntu
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

java: ubuntu
	$(DOCKER) build -t $(ORG)/$(@):openjdk-7-jre ./$(@)/openjdk-7-jre/
	$(DOCKER) build -t $(ORG)/$(@):openjdk-8-jre ./$(@)/openjdk-8-jre/
	$(DOCKER) build -t $(ORG)/$(@):openjdk-7-jdk ./$(@)/openjdk-7-jdk/
	$(DOCKER) build -t $(ORG)/$(@):openjdk-8-jdk ./$(@)/openjdk-8-jdk/
	$(DOCKER) tag $(ORG)/$(@):openjdk-8-jre $(ORG)/$(@):latest
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
		$(DOCKER) push $(ORG)/$(@):openjdk-7-jre; \
		$(DOCKER) push $(ORG)/$(@):openjdk-7-jdk; \
		$(DOCKER) push $(ORG)/$(@):openjdk-8-jre; \
		$(DOCKER) push $(ORG)/$(@):openjdk-8-jdk; \
	fi;

flyway: java
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

flink: java
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;


airflow: python
	$(DOCKER) build -t $(ORG)/$(@):1.8 --build-arg AIRFLOW_VERSION='1.8,<1.9' ./$(@)/
	$(DOCKER) tag $(ORG)/$(@):1.8 $(ORG)/$(@):latest
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
		$(DOCKER) push $(ORG)/$(@):1.8; \
	fi;

ratticdb: python
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

sentry: python
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

node-red: nodejs
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;

cachet: php-fpm
	$(DOCKER) build -t $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		$(DOCKER) push $(ORG)/$(@):latest; \
	fi;
