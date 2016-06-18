FROM bigvikinggames/php-fpm
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ARG CACHET_VERSION
ENV CACHET_VERSION ${CACHET_VERSION:-2.2.4}

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        nginx \
        supervisor \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && wget -q -O/cachet.tar.gz https://github.com/CachetHQ/Cachet/archive/v${CACHET_VERSION}.tar.gz \
    && tar -xzf /cachet.tar.gz -C /srv \
    && mv /srv/Cachet-${CACHET_VERSION} /srv/app \
    && rm -f /cachet.tar.gz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

WORKDIR /srv/app

RUN composer install --no-ansi --no-dev --optimize-autoloader \
    && rm -rf bootstrap/cache/* \
    && chown -R www-data:www-data storage

WORKDIR /

ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD nginx-site.conf  /etc/nginx/sites-enabled/default
ADD php-fpm.conf     /etc/php5/fpm/php-fpm.conf
ADD env.tmpl         /srv/app/env.tmpl
ADD crontab          /etc/cron.d/cachet
ADD run.sh           /run.sh

CMD ["/run.sh"]

EXPOSE 80
