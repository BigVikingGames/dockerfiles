# vim: noexpandtab filetype=make
SHELL:=/usr/bin/env bash
ORG:=bigvikinggames
BUILD:=docker build -t
PUSH:=false

# HAHA! I lied there is a default task!
default:
	@echo "Please read Makefile, there is no default task!"

.PHONY: ubuntu notebook nodejs postgres gitlab-runner java flyway airflow node-red

ubuntu notebook nodejs postgres gitlab-runner:
	$(BUILD) $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		docker push $(ORG)/$(@):latest; \
	fi;

python: ubuntu
	$(BUILD) $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		docker push $(ORG)/$(@):latest; \
	fi;

java: ubuntu
	$(BUILD) $(ORG)/$(@):openjdk-7 ./$(@)/openjdk-7/
	$(BUILD) $(ORG)/$(@):openjdk-8 ./$(@)/openjdk-8/
	docker tag -f $(ORG)/$(@):openjdk-8 $(ORG)/$(@):latest
	if [ "$(PUSH)" == "true" ]; then \
		docker push $(ORG)/$(@):latest; \
		docker push $(ORG)/$(@):openjdk-7; \
		docker push $(ORG)/$(@):openjdk-8; \
	fi;

flyway: java
	$(BUILD) $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		docker push $(ORG)/$(@):latest; \
	fi;

airflow: python
	$(BUILD) $(ORG)/$(@):1.6 --build-arg AIRFLOW_VERSION='1.6,<1.7' ./$(@)/
	$(BUILD) $(ORG)/$(@):1.7 --build-arg AIRFLOW_VERSION='1.7,<1.8' ./$(@)/
	docker tag -f $(ORG)/$(@):1.7 $(ORG)/$(@):latest
	if [ "$(PUSH)" == "true" ]; then \
		docker push $(ORG)/$(@):latest; \
		docker push $(ORG)/$(@):1.6; \
		docker push $(ORG)/$(@):1.7; \
	fi;

node-red: nodejs
	$(BUILD) $(ORG)/$(@) ./$(@)/
	if [ "$(PUSH)" == "true" ]; then \
		docker push $(ORG)/$(@):latest; \
	fi;


