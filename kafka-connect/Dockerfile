FROM confluentinc/cp-kafka-connect
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ENV MYSQL_DRIVER_VERSION ${MYSQL_DRIVER_VERSION:-5.1.39}
ENV RAVEN_VERSION ${RAVEN_VERSION:-7.7.0}
ENV LOG4J_JDK14_VERSION ${LOG4J_JDK14_VERSION:-1.7.9}

RUN wget -q \
    http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar \
    -O /usr/share/java/kafka-connect-jdbc/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar \
    && wget -q \
    http://central.maven.org/maven2/com/getsentry/raven/raven-log4j/${RAVEN_VERSION}/raven-log4j-${RAVEN_VERSION}.jar \
    -O /usr/share/java/raven-log4j-${RAVEN_VERSION}.jar \
    && wget -q \
    http://repo1.maven.org/maven2/org/slf4j/slf4j-jdk14/${LOG4J_JDK14_VERSION}/slf4j-jdk14-${LOG4J_JDK14_VERSION}.jar \
    -O /usr/share/java/slf4j-jdk14-${LOG4J_JDK14_VERSION}.jar

COPY log4j.properties.template /etc/confluent/docker/log4j.properties.template
