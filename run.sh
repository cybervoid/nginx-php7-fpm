#!/bin/bash

docker image remove rh
docker build -t rh .

docker run --name rh --rm \
-p 80:80 \
-v ${PWD}:/usr/share/nginx/html \
-v /usr/local/etc/httpd/certificates:/etc/ssl/certs
rh:latest
