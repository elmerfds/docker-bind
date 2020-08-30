# hadolint ignore=DL3007
FROM ubuntu:eoan AS add-apt-repositories

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3005,DL3008,DL3008 
RUN apt-get update \
 && apt-get upgrade -y \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gnupg wget \
 && wget -qO - https://download.webmin.com/jcameron-key.asc | apt-key add - \
 && echo "deb https://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list