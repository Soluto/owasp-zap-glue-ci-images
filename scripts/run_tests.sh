#!/usr/bin/env bash

set -e

api_file="docker-compose.local.yaml"

if [[ -z $IMAGE_TAG ]];
then
    api_file="docker-compose.ci.yaml"
fi

docker-compose -f docker-compose.yml -f $api_file -f docker-compose.dast.yaml pull --parallel
docker-compose -f docker-compose.yml -f $api_file -f docker-compose.dast.yaml up --build --exit-code-from black-box