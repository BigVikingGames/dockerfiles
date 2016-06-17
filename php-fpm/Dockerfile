FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        php5 \
        php5-cli \
        php5-common \
        php5-curl \
        php5-readline \
        php5-apcu \
        php5-gd \
        php5-mysql \
        php5-pgsql \
        php5-mcrypt \
        php5-redis \
        php5-fpm \
        libpq-dev \
        libmysqlclient-dev \
        libssl-dev \
        zlib1g-dev \
        git \
    && wget -q -O/usr/local/bin/composer https://getcomposer.org/download/1.1.2/composer.phar \
    && if [ $(sha384sum /usr/local/bin/composer | awk '{ print $1 }') != "6c183a61e10026c2200dd13453018a8dd4ab987b8d28857372824ef2646f228b4e721bf0deae1f89b833e13ef06e3df7" ]; then exit 1; fi \
    && chmod +x /usr/local/bin/composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base
