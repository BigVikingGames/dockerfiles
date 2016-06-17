FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        software-properties-common \
    && apt-add-repository ppa:brightbox/ruby-ng \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends \
        build-essential \
        ruby2.1 \
        ruby2.1-dev \
        libffi-dev \
        libpq-dev \
        libmysqlclient-dev \
        libssl-dev \
        zlib1g-dev \
        git \
    && gem install bundler \
    && gem install ffi \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
