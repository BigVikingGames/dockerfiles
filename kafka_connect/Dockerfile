FROM confluentinc/cp-kafka-connect
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ENV MYSQL_DRIVER_VERSION 5.1.39

RUN wget -q http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_DRIVER_VERSION}/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar -O /usr/share/java/kafka-connect-jdbc/mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar
