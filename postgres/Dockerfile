FROM postgres:9.5
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ENV CSTORE_VERSION 1.4

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        wget \
        ca-certificates \
        build-essential \
        protobuf-c-compiler \
        libprotobuf-c0-dev \
        libpq-dev \
        postgresql-server-dev-9.5 \
    && wget -q https://github.com/citusdata/cstore_fdw/archive/v${CSTORE_VERSION}.tar.gz \
    && tar xzf v${CSTORE_VERSION}.tar.gz \
    && cd /cstore_fdw-${CSTORE_VERSION} \
    && PATH=/usr/lib/postgresql/9.5/bin:$PATH make install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base \
        /v${CSTORE_VERSION}.tar.gz \
        /cstore_fdw-${CSTORE_VERSION}

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY postgresql.conf.tmpl /postgresql.conf.tmpl
