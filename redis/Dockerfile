FROM redis:3.0-alpine
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

COPY run.sh /run.sh
COPY redis.conf.tmpl /redis.conf.tmpl

ENTRYPOINT ["/run.sh"]
CMD ["redis-server", "/data/redis.conf"]
