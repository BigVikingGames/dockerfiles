FROM jupyter/datascience-notebook:latest
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ARG LIBRDKAFKA_VERSION
ENV LIBRDKAFKA_VERSION ${LIBRDKAFKA_VERSION:-0.9.1}

USER root

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
      wget \
      build-essential \
      libpng-dev \
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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
       /tmp/* \
       /var/tmp/* \
       /usr/share/man \
       /usr/share/doc \
       /usr/share/doc-base

RUN ln -s /usr/include/freetype2/ft2build.h /usr/include/

RUN pip --no-cache-dir uninstall -y numpy # fix weird problem
RUN conda update conda \
    && conda install -y pymc3 anaconda bqplot \
    && rm -rf /tmp/* /var/tmp/*

RUN wget -qO- https://github.com/edenhill/librdkafka/archive/${LIBRDKAFKA_VERSION}.tar.gz | tar xzf - \
    && cd librdkafka-${LIBRDKAFKA_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd ../ \
    && rm -rf librdkafka-${LIBRDKAFKA_VERSION}

COPY requirements-3.txt /requirements-3.txt

RUN pip --no-cache-dir install --ignore-installed -r /requirements-3.txt

RUN mkdir extractapi \
	&& wget -q https://downloads.tableau.com/tssoftware/extractapi-py-linux-x86_64-2019-1-3.tar.gz -O extractapi.tar.gz \
	&& tar -xvf extractapi.tar.gz -C extractapi --strip 1 \
	&& rm extractapi.tar.gz \
	&& cd extractapi \
	&& python setup.py build install \
	&& cd .. && rm -r extractapi

RUN ln -s $HOME/work /notebooks


USER $NB_USER
