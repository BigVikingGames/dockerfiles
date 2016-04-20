FROM redis:3.0-alpine
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN apk --update add bash \
    && rm -f /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
COPY redis.conf.tmpl /redis.conf.tmpl

CMD ["redis-server", "/data/redis.conf"]
