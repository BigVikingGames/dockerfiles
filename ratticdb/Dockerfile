FROM bigvikinggames/python
MAINTAINER Jonathon W. Marshall "jonathon@bigvikinggames.com"

ARG RATTIC_VERSION
ENV RATTIC_VERSION ${RATTIC_VERSION:-1.3.2}
ENV RATTIC_HOME /home/rattic

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        build-essential \
        wget \
        libsasl2-dev \
        libxml2-dev \
        libxslt-dev \
        libpq-dev \
        libldap2-dev \
        supervisor \
        nginx \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && groupadd rattic \
    && useradd --create-home --home-dir ${RATTIC_HOME} -g rattic rattic \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/dock-base

RUN wget https://github.com/jwmarshall/RatticWeb/archive/v${RATTIC_VERSION}.tar.gz \
    && tar -xzf /v${RATTIC_VERSION}.tar.gz -C ${RATTIC_HOME}/ \
    && rm /v${RATTIC_VERSION}.tar.gz \
    && ln -s ${RATTIC_HOME}/RatticWeb-${RATTIC_VERSION} ${RATTIC_HOME}/RatticWeb

ADD nginx-site.conf     /etc/nginx/sites-enabled/default
ADD supervisord.conf    /etc/supervisor/conf.d/

WORKDIR ${RATTIC_HOME}/RatticWeb

RUN pip install -r requirements-pgsql.txt \
    && pip install jinja2 \
    && pip install uwsgi

ADD uwsgi.ini           ${RATTIC_HOME}/
ADD generate_config.py  ${RATTIC_HOME}/
ADD config.jinja        ${RATTIC_HOME}/
ADD run.sh              /

WORKDIR /

CMD ["/run.sh"]

EXPOSE 80
