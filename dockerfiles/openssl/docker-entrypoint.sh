#!/bin/sh
# docker entrypoint script
# generate three tier certificate chain

SUBJ="/C=$COUNTY/ST=$STATE/L=$LOCATION/O=$ORGANISATION/CN=$ISSUER_CN"

echo " >>>> $CERT_DIR $ISSUER_CN <<<<"

if [ ! -f "$CERT_DIR/$ISSUER_CN.key" ]
then
  echo " ---> Generate self-signed CA certificate"
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj $SUBJ -keyout $CERT_DIR/$ISSUER_CN.key -out $CERT_DIR/$ISSUER_CN.crt

  echo " ---> Generate dhparam.pem"
#  openssl dhparam -out $CERT_DIR/dhparam.pem 2048
else
  echo "ENTRYPOINT: Certificates for $ISSUER_CN already exists"
fi