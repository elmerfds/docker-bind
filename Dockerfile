# hadolint ignore=DL3007
FROM ubuntu:eoan
LABEL maintainer="eafxx"

ENV BIND_USER=bind \
    BIND_VERSION=9.11.5 \
    WEBMIN_VERSION=1.970 \
    DATA_DIR=/data \
    WEBMIN_INIT_SSL_ENABLED="" \
    TZ=""

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3005,DL3008,DL3008
RUN apt-get update -qq -y \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        wget \
        gnupg2 \
        apt-transport-https \
        ca-certificates \
        software-properties-common \
        lsb_release \
 && rm -rf /var/lib/apt/lists/*


COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/sbin/named"]