#!/usr/bin/env bash

set -e

api_file="docker-compose.local.yaml"

if [[ -z $IMAGE_TAG ]];
then
    api_file="docker-compose.ci.yaml"
fi

docker-compose -f docker-compose.yml -f $api_file -f docker-compose.dast.yaml pull --parallel
docker-compose -f docker-compose.yml -f $api_file -f docker-compose.dast.yaml run glue bash +x /app/run_glue.sh http://api blackbox /output/logging-api.txt