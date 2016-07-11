FROM bigvikinggames/python

ARG AIRFLOW_VERSION
ENV AIRFLOW_VERSION ${AIRFLOW_VERSION:-1.7}

ENV AIRFLOW_HOME /usr/local/airflow
RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu trusty main" > /etc/apt/sources.list.d/openjdk-r-ppa-trusty.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 86F44E2A \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends \
        openjdk-8-jre \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        gfortran \
        vim \
    && pip install "airflow>=${AIRFLOW_VERSION}" \
    && pip install "airflow[celery]>=${AIRFLOW_VERSION}" \
    && pip install "airflow[postgres]>=${AIRFLOW_VERSION}" \
    && pip install "airflow[mysql]>=${AIRFLOW_VERSION}" \
    && pip install "airflow[s3]>=${AIRFLOW_VERSION}" \
    && pip install celery[redis] \
    && pip install scipy \
    && pip install scikit-learn \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && chown -R airflow: ${AIRFLOW_HOME} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

ENV FLYWAY_VERSION 3.2.1
RUN wget -qO- http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz | tar xzf - \
    && mv flyway-${FLYWAY_VERSION} /opt/flyway-${FLYWAY_VERSION}
ENV PATH ${PATH}:/opt/flyway-${FLYWAY_VERSION}

ADD run.sh ${AIRFLOW_HOME}/run.sh
ADD config.jinja ${AIRFLOW_HOME}/config.jinja
ADD generate_config.py ${AIRFLOW_HOME}/generate_config.py

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}

# improve term type for docker exec shells
ENV TERM=xterm

ENTRYPOINT ["./run.sh"]
