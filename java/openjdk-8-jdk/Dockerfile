FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main" > /etc/apt/sources.list.d/openjdk-r-ppa-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 86F44E2A \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends \
        openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

ENV SBT_VERSION 0.13.8
RUN wget -qO- https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xzf - \
    && mv sbt /opt/sbt
ENV PATH ${PATH}:/opt/sbt/bin
