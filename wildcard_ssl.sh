#!/bin/bash

HOST="example.com"
EMAIL="mail@me.com"
KEY_FILE_NAME="site.key"
CERTIFICATE_FILE_NAME="site.crt"
CERT_PATH="$(pwd)"/ssl

mkdir -p $CERT_PATH

# Getting WildCard certificate:
certbot certonly --manual --preferred-challenges=dns --email $EMAIL --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d $HOST -d *.$HOST

# Copy CERTIFICATE files:
cp /etc/letsencrypt/archive/$HOST/privkey1.pem $CERT_PATH/$KEY_FILE_NAME
cp /etc/letsencrypt/archive/$HOST/fullchain1.pem $CERT_PATH/$CERTIFICATE_FILE_NAME


#or
#cat /etc/letsencrypt/archive/$HOST/privkey1.pem /etc/letsencrypt/archive/$HOST/fullchain1.pem > $CERT_PATH/site.pem
