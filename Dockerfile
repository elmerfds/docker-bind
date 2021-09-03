FROM ubuntu:focal AS add-apt-repositories

RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg --no-install-recommends \
 && apt-get install -y curl \
 && apt-key adv --fetch-keys https://www.webmin.com/jcameron-key.asc \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM ubuntu:focal
LABEL maintainer="eafxx"

ENV DEBIAN_FRONTEND noninteractive \
    BIND_USER=bind \
    BIND_VERSION=9.11.3 \
    WEBMIN_VERSION=1.980 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""    

RUN  apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY --from=add-apt-repositories /etc/apt/trusted.gpg /etc/apt/trusted.gpg
COPY --from=add-apt-repositories /etc/apt/sources.list /etc/apt/sources.list    

RUN apt-get -qqqy update
RUN apt-get -qqqy install apt-utils software-properties-common dctrl-tools

#RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes 

ARG DEB_VERSION=1:9.16.20-2+ubuntu20.04.1+isc+1
RUN add-apt-repository -y ppa:isc/bind
RUN apt-get -qqqy update && apt-get -qqqy dist-upgrade && apt-get -qqqy install bind9=$DEB_VERSION bind9-utils=$DEB_VERSION && apt-get install webmin tzdata

RUN mkdir -p /etc/bind && chown root:bind /etc/bind/ && chmod 755 /etc/bind
RUN mkdir -p /var/cache/bind && chown bind:bind /var/cache/bind && chmod 755 /var/cache/bind
RUN mkdir -p /var/lib/bind && chown bind:bind /var/lib/bind && chmod 755 /var/lib/bind
RUN mkdir -p /var/log/bind && chown bind:bind /var/log/bind && chmod 755 /var/log/bind
RUN mkdir -p /run/named && chown bind:bind /run/named && chmod 755 /run/named    

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]