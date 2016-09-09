FROM bigvikinggames/java:openjdk-8-jre

ARG FLINK_VERSION=1.1.2
ARG HADOOP_VERSION=27
ARG SCALA_VERSION=2.11

ARG FLINK_INSTALL_PATH=/opt
ENV FLINK_HOME $FLINK_INSTALL_PATH/flink
ENV PATH $PATH:$FLINK_HOME/bin

RUN apt-get update \
	&& apt-get install -y --no-install-recommends build-essential \
	&& mkdir -p $FLINK_INSTALL_PATH \
	&& curl -s $(curl -s https://www.apache.org/dyn/closer.cgi\?preferred\=true)flink/flink-${FLINK_VERSION}/flink-${FLINK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala_${SCALA_VERSION}.tgz | \
		tar xvz -C $FLINK_INSTALL_PATH \
	&& ln -s $FLINK_INSTALL_PATH/flink-$FLINK_VERSION $FLINK_HOME \
	&& addgroup --system flink \
	&& adduser --system --ingroup flink --home $FLINK_HOME --no-create-home flink \
	&& chown -R flink:flink $FLINK_INSTALL_PATH/flink-$FLINK_VERSION \
	&& chown -h flink:flink $FLINK_HOME \
	&& sed -i -e "s/echo \$mypid >> \$pid/echo \$mypid >> \$pid \&\& wait/g" $FLINK_HOME/bin/flink-daemon.sh \
	&& apt-get remove -y build-essential \
	&& rm -rf /var/lib/apt/lists/*

ADD flink-conf.yaml.tmpl /flink-conf.yaml.tmpl
ADD run.sh /run.sh

USER flink

ENTRYPOINT ["./run.sh"]
