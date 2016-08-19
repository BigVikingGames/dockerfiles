FROM jupyter/datascience-notebook:latest
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ARG LIBRDKAFKA_VERSION
ENV LIBRDKAFKA_VERSION ${LIBRDKAFKA_VERSION:-0.9.1}

USER root

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
      wget \
      build-essential \
      libpng12-dev \
      libfreetype6-dev \
      libopenblas-dev \
      liblapack-dev \
      libffi-dev \
      libpq-dev \
      libmysqlclient-dev \
      libssl-dev \
      zlib1g-dev \
      liblz4-dev \
      libsasl2-dev \
      gfortran \
    && ln -s /usr/include/freetype2/ft2build.h /usr/include/ \
    && pip2 install --src /usr/local/src --process-dependency-links git+https://github.com/pymc-devs/pymc3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/* \
       /usr/share/man \
       /usr/share/doc \
       /usr/share/doc-base

RUN wget -qO- https://github.com/edenhill/librdkafka/archive/${LIBRDKAFKA_VERSION}.tar.gz | tar xzf - \
    && cd librdkafka-${LIBRDKAFKA_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd ../ \
    && rm -rf librdkafka-${LIBRDKAFKA_VERSION}

COPY requirements-2.txt /requirements-2.txt
COPY requirements-3.txt /requirements-3.txt

RUN pip2 --no-cache-dir install -r /requirements-2.txt \
    && pip3 --no-cache-dir install -r /requirements-3.txt

USER $NB_USER
