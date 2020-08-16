# hadolint ignore=DL3007
FROM ubuntu:eoan AS add-apt-repositories

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget gnupg \
 && wget http://www.webmin.com/download/deb/webmin-current.deb -O /tmp/webmin-current.deb

FROM ubuntu:eoan
LABEL maintainer="eafxx"

ENV BIND_USER=bind \
    BIND_VERSION=9.11.5 \
    WEBMIN_VERSION=1.941 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""

COPY --from=add-apt-repositories /etc/apt/trusted.gpg /etc/apt/trusted.gpg
COPY --from=add-apt-repositories /tmp/webmin-current.deb /tmp/webmin-current.deb
