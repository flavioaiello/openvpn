#!/bin/sh

if [ ${INIT} ];then
   rm -rf ${OPENVPN}/*
   easyrsa init-pki
   easyrsa --batch --req-cn="server" build-ca nopass
   easyrsa gen-dh
   easyrsa build-server-full server nopass
   easyrsa build-client-full client nopass
fi

cat > ${OPENVPN}/server.conf <<-EOF
proto udp
port 1194
mode server
tls-server
topology subnet
push "topology subnet"
dev tun
tun-ipv6
float
comp-lzo
server 192.168.254.0 255.255.255.0
user nobody
group nobody
persist-key
persist-tun
keepalive 10 120
reneg-sec 0
ca ${EASYRSA_PKI}/ca.crt
cert ${EASYRSA_PKI}/issued/server.crt
key ${EASYRSA_PKI}/private/server.key
dh ${EASYRSA_PKI}/dh.pem
EOF

exec "$@"
