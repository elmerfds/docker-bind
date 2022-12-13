# [eafxx/bind](https://hub.docker.com/r/eafxx/bind)

A fork of [sameersbn/bind](https://github.com/sameersbn/docker-bind) repo, what's different?
- Multiarch Support: 
  * amd64
  * armv7, arm64 i.e. supports RPi 3/4
- Running on Ubuntu Hirsute
- Bind: 9.16.8
- Webmin: Always pulls latest (during image build)
- Added Timezone (TZ) support
- Image auto-builds on schedule (every Sat 00:00 BST)
- Ubuntu updates will be applied during each scheduled build
- Reverse Proxy friendly ([utkuozdemir/docker-bind](https://github.com/utkuozdemir/docker-bind/tree/webmin-reverse-proxy-config))
- Fixes to [utkuozdemir/docker-bind](https://github.com/utkuozdemir/docker-bind/tree/webmin-reverse-proxy-config)'s 'Reverse Proxy friendly' update. 
  * Cleanup of config & miniserv.conf when variables are used & then removed
  * Removing duplicate entries to config & miniserv.conf
- Allow bind log to file ([WindoC/docker-bind](https://github.com/WindoC/docker-bind/tree/patch-1))
 
## Contents
- [Introduction](#introduction)
- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)

# Introduction

Docker container image for [BIND](https://www.isc.org/downloads/bind/) DNS server bundled with the [Webmin](http://www.webmin.com/) interface.

BIND is open source software that implements the Domain Name System (DNS) protocols for the Internet. It is a reference implementation of those protocols, but it is also production-grade software, suitable for use in high-volume and high-reliability applications.

# Getting started

**Tags**

| Tag      | Description                          | Build Status                                                                                                | 
| ---------|--------------------------------------|-------------------------------------------------------------------------------------------------------------|
| latest | master/stable                 | ![Docker Build Master](https://github.com/elmerfdz/docker-bind/workflows/Docker%20Build%20Master/badge.svg)  | 
| dev | development, pre-release      | ![Docker Build Dev](https://github.com/elmerfdz/docker-bind/workflows/Docker%20Build%20Dev/badge.svg)     |
| exp | unstable, experimental        | ![Docker Build Exp](https://github.com/elmerfdz/docker-bind/workflows/Docker%20Build%20Exp/badge.svg)   | 

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/eafxx/bind) and is the recommended method of installation.

```bash
docker pull eafxx/bind
```
OR

Alternatively you can build the image yourself.

```bash
docker build -t eafxx/bind github.com/eafxx/docker-bind
```

## Quickstart

Docker Run:

```bash
docker run --name bind -d --restart=always \
  -p 53:53/tcp -p 53:53/udp -p 10000:10000/tcp \
  -v /path/to/bind/data:/data \
  eafxx/bind
```

OR

Docker Compose

```
    bind:
        container_name: bind
        hostname: bind
        network_mode: bridge
        image: eafxx/bind
        restart: unless-stopped
        ports:
            - "53:53/tcp"
            - "53:53/udp"
            - 10000:10000/tcp
        volumes:
            - /path/to/bind/data:/data
        environment:
            - WEBMIN_ENABLED=true
            - WEBMIN_INIT_SSL_ENABLED=false
            - WEBMIN_INIT_REFERERS=dns.domain.com
            - WEBMIN_INIT_REDIRECT_PORT=10000
            - ROOT_PASSWORD=password
            - TZ=Europe/London
```

When the container is started the [Webmin](http://www.webmin.com/) service is also started and is accessible from the web browser at https://serverIP:10000. Login to Webmin with the username `root` and password `password`. Specify `--env ROOT_PASSWORD=secretpassword` on the `docker run` command to set a password of your choosing. The launch of Webmin can be disabled if not required. 

### - Parameters

Container images are configured using parameters passed at runtime (such as those above). 

| Parameter | Function |
| :----: | --- |
| `-p 53:53/tcp` `-p 53:53/udp` | DNS TCP/UDP port|
| `-p 10000/tcp` | Webmin port |
| `-e WEBMIN_ENABLED=true` | Enable/Disable Webmin (true/false) |
| `-e ROOT_PASSWORD=password` | Set a password for Webmin root. Parameter has no effect when the launch of Webmin is disabled.  |
| `-e WEBMIN_INIT_SSL_ENABLED=false` | Enable/Disable Webmin SSL (true/false). If Webmin should be served via SSL or not. Defaults to `true`. |
| `-e WEBMIN_INIT_REFERERS` | Enable/Disable Webmin SSL (true/false). Sets the allowed referrers to Webmin. Set this to your domain name of the reverse proxy. Example: `mywebmin.example.com`. Defaults to empty (no referrer)|
| `-e WEBMIN_INIT_REDIRECT_PORT` | The port Webmin is served from. Set this to your reverse proxy port, such as `443`. Defaults to `10000`. |
| `-e WEBMIN_INIT_REDIRECT_SSL` | Enable/Disable Webmin SSL redirection after login (true/false). Set this to `true` if behind a SSL terminator. Defaults to `false`|
| `-e BIND_EXTRA_FLAGS` | Default set to -g |
| `-e BIND_LOG_STDERR` | Default set to false. To allow bind log to file, that makes bind not force all log to STDERR |
| `-v /data` | Mount data directory for persistent config  |
| `-e TZ=Europe/London` | Specify a timezone to use e.g. Europe/London |
