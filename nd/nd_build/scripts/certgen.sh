#!/bin/sh

EMAIL=${2:-'east_woo@163.com'}
OU=${3:-'oap'}
echo -n 'Enter hostname: '
read CNAME
echo -n 'Enter a password: '
read -s PASS

KEYFILE="${CNAME}.key"
CSRFILE="${CNAME}.csr"
CRTFILE="${CNAME}.crt"
KEYCOPY="${KEYFILE}.org"

SUBJECT="/C=CN/ST=Fujian/L=Fuzhou/O=nd/OU=${OU}/CN=${CNAME}/emailAddress=${EMAIL}"

echo 'Generation of RSA Private Key:'
echo '------------------------------------------------------------------------'
openssl genrsa -des3 -out ${KEYFILE} -passout pass:${PASS} 1024

echo 'X.509 Certificate Signing Request (CSR) Management. '
echo '------------------------------------------------------------------------'
if [ -f ${KEYFILE} ]; then
openssl req -new -key ${KEYFILE} -out ${CSRFILE} -subj ${SUBJECT} -passin pass:${PASS}
cp ${KEYFILE} ${KEYCOPY}
fi

echo 'RSA Data Management.'
echo '------------------------------------------------------------------------'
if [ -f ${KEYCOPY} ]; then
openssl rsa -in ${KEYCOPY} -out ${KEYFILE} -passin pass:${PASS}
fi

echo 'X.509 Certificate Data Management.'
echo '------------------------------------------------------------------------'
if [ -f ${KEYFILE} ]; then
openssl x509 -req -days 365 -in ${CSRFILE} -signkey ${KEYFILE} -out ${CRTFILE}
fi

