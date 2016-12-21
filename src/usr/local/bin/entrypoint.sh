#!/bin/sh

if [ ! -f ${OPENVPN}/server.conf ]; then

   # Remove old pki
   rm -rf ${EASYRSA_PKI}
   touch ${OPENVPN}/crl.pem

   # Init new pki
   easyrsa init-pki
   easyrsa --batch --req-cn="server" build-ca nopass
   easyrsa gen-dh

   # Create server cert
   easyrsa build-server-full server nopass

   # Write server config file
   awk '/\{\{ CA \}\}/{system("cat ${EASYRSA_PKI}/ca.crt");next};/\{\{ CERT \}\}/{system("cat ${EASYRSA_PKI}/issued/server.crt");next};/\{\{ KEY \}\}/{system("cat ${EASYRSA_PKI}/private/server.key");next};/\{\{ DH \}\}/{system("cat ${EASYRSA_PKI}/dh.pem");next}1' /tmp/server.tmpl > ${OPENVPN}/server.conf
fi

# Create clients certs
for CLIENT in ${CLIENTS}; do

   # Generate key and write file if client is not existant
   if [ ! -f ${OPENVPN}/${CLIENT}.conf ]; then

      # Generate client config
      easyrsa build-client-full ${CLIENT} nopass

      # Write config file
      awk '/\{\{ SERVICE_URL \}\}/{print $1 " '${SERVICE_URL}'";next};/\{\{ CA \}\}/{system("cat ${EASYRSA_PKI}/ca.crt");next};/\{\{ CERT \}\}/{system("cat ${EASYRSA_PKI}/issued/'${CLIENT}'.crt");next};/\{\{ KEY \}\}/{system("cat ${EASYRSA_PKI}/private/'${CLIENT}'.key");next}1' /tmp/client.tmpl > ${OPENVPN}/${CLIENT}.conf

      # Add entry to list
      echo ${CLIENT} >> ${OPENVPN}/clients.lst
   fi
done

# Revoke removed clients and cleanup client profiles
REVOKES=$(for REVOKED in ${CLIENTS} $(cat ${OPENVPN}/clients.lst); do echo "$REVOKED"; done | sort | uniq -u)
for REVOKE in ${REVOKES}; do
   echo yes | easyrsa revoke ${REVOKE}
   rm ${OPENVPN}/${REVOKE}.conf
done
easyrsa gen-crl

# Update the client list
rm ${OPENVPN}/clients.lst
for CLIENT in ${CLIENTS}; do echo ${CLIENT} >> ${OPENVPN}/clients.lst; done

echo "*** Your client keys are stored in ${OPENVPN} ***"

# Start openvpn
exec "$@"