#!/usr/bin/env bash

set -e

api_file="docker-compose.ci.yaml"

if [[ -z $IMAGE_TAG ]];
then
    api_file="docker-compose.local.yaml"
fi

docker-compose -f docker-compose.yaml -f $api_file -f docker-compose.security.yaml pull --parallel
docker-compose -f docker-compose.yaml -f $api_file -f docker-compose.security.yaml up --build --exit-code-from black-box