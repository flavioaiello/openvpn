FROM alpine:latest
ARG TAG
LABEL TAG=${TAG}

ADD src /

ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki

RUN echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk add ca-certificates openssl easy-rsa@community openvpn curl bash && \
    rm -rf /var/cache/apk/* && \
    ln -s ${EASYRSA}/easyrsa /usr/local/bin && \
    chmod -R +x /usr/local/bin

EXPOSE 1194/udp

ENTRYPOINT ["entrypoint.sh"]
CMD ["openvpn", "--config", "/etc/openvpn/server.conf", "--crl-verify", "/etc/openvpn/pki/crl.pem"]
