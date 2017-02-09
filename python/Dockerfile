FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        build-essential \
        python \
        python-dev \
        python-pip \
        libffi-dev \
        libpq-dev \
        libmysqlclient-dev \
        libssl-dev \
        zlib1g-dev \
        git \
    && pip install --upgrade pip \
    && pip install --upgrade setuptools \
    && pip install --upgrade cryptography \
    && pip install --upgrade pyOpenSSL \
    && pip install --upgrade ndg-httpsclient \
    && pip install --upgrade pyasn1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
