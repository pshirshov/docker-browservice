#!/usr/bin/env bash

set -x
set -e

#source ./version.sh
V_BROWSERVICE=0.9.7.0

docker build . --build-arg V_BROWSERVICE=$V_BROWSERVICE -t septimalmind/browservice:latest -t septimalmind/browservice:$V_BROWSERVICE

docker push septimalmind/browservice:latest
docker push septimalmind/browservice:$V_BROWSERVICE
