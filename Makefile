# vim: noexpandtab filetype=make
SHELL:=/usr/bin/env bash
ORG:=bigvikinggames
BUILD:=docker build -t

# HAHA! I lied there is a default task!
default:
	@echo "Please read Makefile, there is no default task!"

.PHONY: ubuntu notebook nodejs postgres gitlab-runner java flyway airflow node-red

ubuntu notebook nodejs postgres gitlab-runner:
	$(BUILD) $(ORG)/$(@) ./$(@)/

python: ubuntu
	$(BUILD) $(ORG)/$(@) ./$(@)/

java: ubuntu
	$(BUILD) $(ORG)/$(@):openjdk-7 ./$(@)/openjdk-7/
	$(BUILD) $(ORG)/$(@):openjdk-8 ./$(@)/openjdk-8/
	docker tag -f $(ORG)/$(@):openjdk-7 $(ORG)/$(@):latest

flyway: java
	$(BUILD) $(ORG)/$(@) ./$(@)/

airflow: python
	$(BUILD) $(ORG)/$(@) ./$(@)/

node-red: nodejs
	$(BUILD) $(ORG)/$(@) ./$(@)/
