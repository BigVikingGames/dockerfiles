FROM bigvikinggames/java
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ENV FLYWAY_VERSION 3.2.1

RUN apt-get update && apt-get install -yqq --no-install-recommends wget \
    && wget -qO- http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/3.2.1/flyway-commandline-3.2.1.tar.gz | tar xzf - \
    && mv flyway-${FLYWAY_VERSION} /opt/flyway-${FLYWAY_VERSION}

ENV PATH ${PATH}:/opt/flyway-${FLYWAY_VERSION}
