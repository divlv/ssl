#!/bin/bash
certbot certonly --manual --preferred-challenges=dns --email mail@me.com --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.example.com



# /etc/letsencrypt/archive/example.com
# Build CERTIFICATE file
cp /etc/letsencrypt/archive/example.com/privkey1.pem /root/example.com.key
cp /etc/letsencrypt/archive/example.com/fullchain1.pem /root/example.com.crt

#or
#cat /etc/letsencrypt/archive/example.com/privkey1.pem /etc/letsencrypt/archive/example.com/fullchain1.pem > /root/example.com.pem