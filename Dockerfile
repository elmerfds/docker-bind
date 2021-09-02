FROM ubuntu:bionic AS add-apt-repositories

RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg --no-install-recommends \
 && apt-get install -y curl \
 && apt-key adv --fetch-keys https://www.webmin.com/jcameron-key.asc \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list

FROM ubuntu:bionic
LABEL maintainer="eafxx"

ENV BIND_USER=bind \
    BIND_VERSION=9.11.3 \
    #WEBMIN_VERSION=1.980 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""    

RUN  apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates \
 && rm -rf /var/lib/apt/lists/*

COPY --from=add-apt-repositories /etc/apt/trusted.gpg /etc/apt/trusted.gpg
COPY --from=add-apt-repositories /etc/apt/sources.list /etc/apt/sources.list    

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && apt-get update \
 && apt-get upgrade -y \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
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