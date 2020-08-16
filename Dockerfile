# hadolint ignore=DL3007
FROM ubuntu:eoan AS add-webmin-package

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget gnupg \
 && wget --no-check-certificate http://www.webmin.com/download/deb/webmin-current.deb -O /tmp/webmin-current.deb

FROM ubuntu:eoan
LABEL maintainer="eafxx"

ENV BIND_USER=bind \
    BIND_VERSION=9.11.5 \
    WEBMIN_VERSION=1.941 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""

COPY --from=add-webmin-package /tmp/webmin-current.deb /tmp/webmin-current.deb

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      tzdata \
      perl \
      bind9=1:${BIND_VERSION}* bind9-host=1:${BIND_VERSION}* dnsutils \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get install /tmp/webmin-current.deb 

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]