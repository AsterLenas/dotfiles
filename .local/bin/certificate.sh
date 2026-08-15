#!/usr/bin/env bash

ext_file="$1.ext"
wildcard="*.kai.ni"

echo "authorityKeyIdentifier=keyid,issuer" | tee $ext_file
echo "basicConstraints=CA:FALSE" | tee -a $ext_file
echo "keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment" | tee -a $ext_file
echo "subjectAltName = @alt_names" | tee -a $ext_file
echo "" | tee -a $ext_file
echo "[alt_names]" | tee -a $ext_file
echo "DNS.1 = $wildcard" | tee -a $ext_file

[ ! -f "$1.key" ] && openssl genrsa -out $1.key 2048
openssl req -new -key $1.key -out $1.csr
openssl x509 -req -in $1.csr -CA internalCA.pem -CAkey internalCA.key -CAcreateserial -out $1.crt -days 825 -sha256 -extfile $ext_file

