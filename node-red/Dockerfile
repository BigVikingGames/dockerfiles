FROM bigvikinggames/nodejs
MAINTAINER Jonathon W. Marshall "jmarshall@bigvikinggames.com"

RUN apk --update add git python build-base \
    && rm -f /var/cache/apk/* \
    && npm install -g node-red \
       node-red-node-mongodb \
       node-red-node-mysql \
       node-red-node-redis \
       node-red-contrib-postgres \
    && mkdir -p /data

COPY settings.js /settings.js
COPY run.sh /run.sh

VOLUME /data

EXPOSE 1880

CMD ["/run.sh"]
