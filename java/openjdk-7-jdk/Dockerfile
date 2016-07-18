FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
        openjdk-7-jdk \
    && rm -rf /var/lib/apt/lists* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ENV SBT_VERSION 0.13.8
RUN wget -qO- https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xzf - \
    && mv sbt /opt/sbt
ENV PATH ${PATH}:/opt/sbt/bin
