FROM bigvikinggames/ubuntu
MAINTAINER Jonathon W. Marshall <jmarshall@bigvikinggames.com>

ARG CACHET_MONITOR_VERSION
ENV CACHET_MONITOR_VERSION=${CACHET_MONITOR_VERSION:-2.0}

RUN wget -q -O/usr/bin/cachet-monitor https://github.com/CastawayLabs/cachet-monitor/releases/download/v${CACHET_MONITOR_VERSION}/cachet-monitor_linux_amd64 \
    && chmod +x /usr/bin/cachet-monitor

CMD ["/usr/bin/cachet-monitor", "-c", "/config.json"]
