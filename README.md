# OpenVPN

Very lean OpenVPN gateway based on alpine linux. Adds, removes and revokes clients automatically. Just manage the `CLIENTS` environment variable and redeploy.

## Getting started

## Docker compose sample excerpts

```
version: '2'

services:
  ...

  openvpn:
    build: openvpn/.
    network_mode: "host"
    privileged: true
    volumes:
      - /etc/openvpn:/etc/openvpn
    environment:
      - CLIENTS=max hans stefan michi
      - SERVICE_URL=openvpn.yourone.you
    ports:
      - "1194:1194"
    restart: always

```

## Certificates
This one adds, removes and revokes clients automatically. Just manage the `CLIENT` environment variable and redeploy. Find the client connection profile directly on your mounted host volume.

## Versioning
Versioning is an issue when deploying the latest release. For this purpose an additional label will be provided during build time. 
The Dockerfile must be extended with an according label argument as shown below:
```
ARG TAG
LABEL TAG=${TAG}
```
Arguments must be passed to the build process using `--build-arg TAG="${TAG}"`.

## Reporting
```
docker inspect --format \
&quot;{{ index .Config.Labels \&quot;com.docker.compose.project\&quot;}},\
 {{ index .Config.Labels \&quot;com.docker.compose.service\&quot;}},\
 {{ index .Config.Labels \&quot;TAG\&quot;}},\
 {{ index .State.Status }},\
 {{ printf \&quot;%.16s\&quot; .Created }},\
 {{ printf \&quot;%.16s\&quot; .State.StartedAt }},\
 {{ index .RestartCount }}&quot; $(docker ps -f name=${STAGE} -q) &gt;&gt; reports/${SHORTNAME}.report
```
