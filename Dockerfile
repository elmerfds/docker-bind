# hadolint ignore=DL3007
FROM ubuntu:eoan
LABEL maintainer="eafxx"

ENV BIND_USER=bind \
    BIND_VERSION=9.11.5 \
    WEBMIN_VERSION=1.960 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget gnupg2 apt-transport-https ca-certificates \
 && wget https://download.webmin.com/jcameron-key.asc --ca-directory=/etc/ssl/certs/ \
 && apt-key add jcameron-key.asc \
 && echo "deb https://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list \
 && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      tzdata \
      bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* dnsutils \
      webmin=${WEBMIN_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]