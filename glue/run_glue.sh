#!/bin/bash

# Abort script on error
set -e

BASE_URL=$1
SESSON_NAME=$2
GLUE_FILE=$3
ZAP_URL=$(echo $PROXY_URL | sed -e 's/https\?:\/\///')
./wait-for-it.sh $ZAP_URL -t 300

curl -s --fail $PROXY_URL/JSON/core/action/loadSession/?name=$SESSON_NAME

if [ "$(curl --fail "$PROXY_URL/JSON/core/view/messages/?baseurl=$BASE_URL&count=1" 2> /dev/null | jq '.messages | length')" -le "0" ];
then
  echo "No messages found for $BASE_URL in $SESSON_NAME"
  exit 1
fi

ruby /glue/bin/glue -t zap \
  --zap-host $ZAP_HOST --zap-port $ZAP_PORT --zap-passive-mode \
  -f teamcity \
  $BASE_URL \
  --finding-file-path $GLUE_FILE \
  --teamcity-min-level 1
