FROM bigvikinggames/python
MAINTAINER Jonathon W. Marshall "jmarshall@bigvikinggames.com"

ARG SENTRY_VERSION
ENV SENTRY_VERSION ${SENTRY_VERSION:-8.8.0}
ENV SENTRY_HOME /home/sentry

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        libtiff5-dev \
        libjpeg8-dev \
        zlib1g-dev \
        libfreetype6-dev \
        liblcms2-dev \
        libwebp-dev \
        tcl8.6-dev \
        tk8.6-dev \
        python-tk \
        libsasl2-dev \
        libxml2-dev \
        libxslt-dev \
        libpq-dev \
        libldap2-dev \
        supervisor \
    && groupadd sentry \
    && useradd --create-home --home-dir ${SENTRY_HOME} -g sentry sentry \
    && pip install \
        psycopg2 \
        redis \
        hiredis \
        nydus \
        sentry==${SENTRY_VERSION}

ADD supervisord.conf /etc/supervisor/conf.d/

WORKDIR ${SENTRY_HOME}

ADD requirements.txt ${SENTRY_HOME}/requirements.txt
ADD sentry.conf.py ${SENTRY_HOME}/.sentry/

RUN pip install -r ${SENTRY_HOME}/requirements.txt
RUN chown -R sentry:sentry ${SENTRY_HOME}/.sentry
RUN chown -R sentry:sentry /var/log/supervisor

ADD run.sh /run.sh

USER sentry
EXPOSE 9000
CMD ["/run.sh"]
