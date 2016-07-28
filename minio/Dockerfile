FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN wget -q -O/usr/local/bin/minio https://dl.minio.io/server/minio/release/linux-amd64/minio \
    && chmod +x /usr/local/bin/minio \
    && wget -q -O/usr/local/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc \
    && chmod +x /usr/local/bin/mc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

VOLUME /data

EXPOSE 9000

CMD ["minio", "server", "/data"]
