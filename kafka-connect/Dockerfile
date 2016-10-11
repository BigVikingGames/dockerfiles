FROM confluentinc/cp-kafka-connect:3.0.1-2
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ENV MYSQL_DRIVER_VERSION ${MYSQL_DRIVER_VERSION:-5.1.39}
ENV RAVEN_VERSION ${RAVEN_VERSION:-7.7.0}

RUN wget -q \
    http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar \
    -O /usr/share/java/kafka-connect-jdbc/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar \
    && wget -q \
    http://central.maven.org/maven2/com/getsentry/raven/raven-log4j/${RAVEN_VERSION}/raven-log4j-${RAVEN_VERSION}.jar \
    -O /usr/share/java/confluent-common/raven-log4j-${RAVEN_VERSION}.jar \
    && wget -q \
    http://central.maven.org/maven2/com/getsentry/raven/raven/${RAVEN_VERSION}/raven-${RAVEN_VERSION}.jar \
    -O /usr/share/java/confluent-common/raven-${RAVEN_VERSION}.jar

COPY log4j.properties.template /etc/confluent/docker/log4j.properties.template
