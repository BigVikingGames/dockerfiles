FROM gitlab/gitlab-runner
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main" > /etc/apt/sources.list.d/openjdk-r-ppa-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 86F44E2A \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends \
        docker-engine=1.9.1-0~trusty \
        openjdk-8-jre \
    && rm -rf /var/lib/apt/lists* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

RUN wget https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.12.0-1_amd64.deb -qO /chefdk.deb \
    && dpkg -i /chefdk.deb \
    && rm -rf /chefdk.deb

ENV SBT_VERSION 0.13.8
RUN wget -qO- https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar xzf - \
    && mv sbt /opt/sbt

ENV PATH ${PATH}:/opt/sbt/bin:/opt/chefdk/bin
