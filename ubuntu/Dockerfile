FROM ubuntu:14.04
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse" > /etc/apt/sources.list \
    && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get upgrade -yqq --no-install-recommends \
    && apt-get install -yqq --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        openssl \
        wget \
        curl \
        unzip \
        dnsutils \
    && wget -q https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 -O /usr/local/bin/gosu \
    && chmod +x /usr/local/bin/gosu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
