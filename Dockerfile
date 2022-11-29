FROM ubuntu:22.10 AS add-apt-repositories
LABEL maintainer="eafxx"

ENV BIND_USER=bind \
    BIND_VERSION=9.18.1 \
    #WEBMIN_VERSION=1.980 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""    

RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg --no-install-recommends \
 && apt-get install -y curl wget \
 && wget https://download.webmin.com/jcameron-key.asc \
 && cat jcameron-key.asc | gpg --dearmor >/etc/apt/trusted.gpg.d/jcameron-key.gpg \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        tzdata \
        bind9 bind9utils bind9-doc dnsutils \
        webmin \
        #webmin=${WEBMIN_VERSION}* \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]
