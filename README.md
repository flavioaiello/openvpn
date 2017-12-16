# OpenVPN

Very lean OpenVPN gateway based on alpine linux. Adds, removes and revokes clients automatically. Just manage the `CLIENTS` environment variable and redeploy.

## Getting started

### Docker compose sample excerpts

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
      - SERVICE_URL=openvpn.vcap.me
    ports:
      - "1194:1194"
    restart: always

```

## Certificates
This one adds, removes and revokes clients automatically. Just manage the `CLIENT` environment variable and redeploy. Find the client connection profile directly on your mounted host volume.
