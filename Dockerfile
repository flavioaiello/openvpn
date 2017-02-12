FROM alpine:latest

COPY files /

ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki

RUN set -ex && \
    echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add --no-cache ca-certificates openssl easy-rsa@community openvpn curl bash && \
    ln -s ${EASYRSA}/easyrsa /usr/local/bin && \
    chmod -R +x /usr/local/bin

VOLUME ["/etc/openvpn"]

EXPOSE 1194/udp

ENTRYPOINT ["entrypoint.sh"]
CMD ["openvpn", "--config", "/etc/openvpn/server.conf", "--crl-verify", "/etc/openvpn/crl.pem"]
