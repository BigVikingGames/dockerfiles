FROM bigvikinggames/python

ARG AIRFLOW_VERSION
ENV AIRFLOW_VERSION ${AIRFLOW_VERSION:-1.8}

ENV AIRFLOW_HOME /usr/local/airflow
RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu xenial main" > /etc/apt/sources.list.d/openjdk-r-ppa-xenial.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 86F44E2A \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends \
        openjdk-8-jre \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
        gfortran \
        vim \
    && pip install "apache-airflow>=${AIRFLOW_VERSION}" \
    && pip install "apache-airflow[celery]>=${AIRFLOW_VERSION}" \
    && pip install "apache-airflow[postgres]>=${AIRFLOW_VERSION}" \
    && pip install "apache-airflow[mysql]>=${AIRFLOW_VERSION}" \
    && pip install "apache-airflow[s3]>=${AIRFLOW_VERSION}" \
    && pip install celery[redis] \
    && pip install scipy \
    && pip install scikit-learn \
    && pip install surprise \
    && pip install elasticsearch==5.5.1 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && chown -R airflow: ${AIRFLOW_HOME} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# support long running tasks that take longer than an hour
# http://docs.celeryproject.org/en/latest/getting-started/brokers/redis.html#id1
# need this until AIRFLOW-966 is fixed
RUN sed -i '/BROKER_URL/ a \ \ \ \ BROKER_TRANSPORT_OPTIONS = {"visibility_timeout": 43200}' /usr/local/lib/python2.7/dist-packages/airflow/executors/celery_executor.py

RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
    && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
    && apt-get update \
    && apt-get install -yqq --no-install-recommends \
        google-cloud-sdk

RUN mkdir extractapi \
	&& wget -q https://downloads.tableau.com/tssoftware/extractapi-py-linux-x86_64-2019-1-3.tar.gz -O extractapi.tar.gz \
	&& tar -xvf extractapi.tar.gz -C extractapi --strip 1 \
	&& rm extractapi.tar.gz \
	&& cd extractapi \
	&& python setup.py build install \
	&& cd .. && rm -r extractapi

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
