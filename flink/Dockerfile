FROM java:8-jre-alpine

# Install requirements
RUN apk add --no-cache bash snappy

# Configure Flink version
ARG FLINK_VERSION=1.2.1
ARG HADOOP_VERSION=27
ARG SCALA_VERSION=2.11

# Flink environment variables
ARG FLINK_INSTALL_PATH=/opt
ENV FLINK_HOME $FLINK_INSTALL_PATH/flink
ENV PATH $PATH:$FLINK_HOME/bin

# Install build dependencies and flink
RUN set -x && \
  mkdir -p $FLINK_INSTALL_PATH && \
  apk --update add --virtual build-dependencies curl && \
  curl -s $(curl -s https://www.apache.org/dyn/closer.cgi\?preferred\=true)flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala_${SCALA_VERSION}.tgz | \
  tar xvz -C $FLINK_INSTALL_PATH && \
  ln -s $FLINK_INSTALL_PATH/flink-$FLINK_VERSION $FLINK_HOME && \
  addgroup -S flink && adduser -D -S -H -G flink -h $FLINK_HOME flink && \
  chown -R flink:flink $FLINK_INSTALL_PATH/flink-$FLINK_VERSION && \
  chown -h flink:flink $FLINK_HOME && \
  sed -i -e "s/echo \$mypid >> \$pid/echo \$mypid >> \$pid \&\& wait/g" $FLINK_HOME/bin/flink-daemon.sh && \
  apk del build-dependencies && \
  rm -rf /var/cache/apk/*

# Configure container
USER flink
ADD docker-entrypoint.sh $FLINK_HOME/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh", "-c"]

