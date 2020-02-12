#!/bin/bash

docker image remove rh
docker build -t rh .

docker run --name rh --rm \
-p 80:80 \
-p 443:443 \
-v ${PWD}:/usr/share/nginx/html \
-v /Users/rafag/Documents/temp/cert:/etc/ssl/certs \
rh:latest
