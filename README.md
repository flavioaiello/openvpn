# OpenVPN

Very lean OpenVPN gateway based on alpine linux. Adds, removes and revokes clients automatically. Just manage the `CLIENTS` environment variable and redeploy.

## Getting started

### Docker compose sample excerpt

```
version: '2'

services:
  ...

  openvpn:
    image: flavioaiello/openvpn
    network_mode: "host"
    privileged: true
    volumes:
      - /etc/openvpn:/etc/openvpn
    environment:
      - CLIENTS=max hans stefan michi
      - SERVICE_URL=openvpn.yourone.you
    restart: always

```

## Certificates
This one adds, removes and revokes clients automatically. Just manage the `CLIENT` environment variable and redeploy. Find the client connection profile directly on your mounted host volume.

## Contribute
If you want to further customize this image, please feel free to contribute.
