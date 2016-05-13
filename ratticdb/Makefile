# vim: noexpandtab filetype=make
NAME=galloplabs/ratticdb
SHELL=/usr/bin/env bash
VERSION=$(shell grep 'ENV RATTIC_VERSION' Dockerfile | cut -d' ' -f3)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
GIT_COMMIT=$(shell git rev-parse --short HEAD 2>/dev/null)
# Push to your private repo
# REGISTRY=registry:5000

build:
	docker build -t $(NAME) .
	docker tag $(NAME):latest $(NAME):$(GIT_COMMIT)
	docker tag $(NAME):latest $(NAME):$(VERSION)

push:
ifdef REGISTRY
	docker tag $(NAME):$(GIT_COMMIT) $(REGISTRY)/$(NAME):$(GIT_COMMIT)
	docker tag $(NAME):$(VERSION) $(REGISTRY)/$(NAME):$(VERSION)
	docker tag $(NAME):latest $(REGISTRY)/$(NAME):latest
	docker push $(REGISTRY)/$(NAME):$(GIT_COMMIT)
	docker push $(REGISTRY)/$(NAME):$(VERSION)
	docker push $(REGISTRY)/$(NAME):latest
else
	docker push $(NAME):$(VERSION)
	docker push $(NAME):latest
endif

clean:
	@IMAGES=$$(docker images | grep $(NAME) | awk '{ print $$3 }') && \
		for i in $$IMAGES; do \
			if `docker images | grep -q $$i`; then \
				docker rmi -f $$i; \
			fi \
		done;
