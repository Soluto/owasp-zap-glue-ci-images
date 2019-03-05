#!/bin/sh

# Abort script on error
set -e

GLUE_FILE=$1
REPORT_FILE=$2


jq -f jq_pattern $REPORT_FILE > output.json

ruby /glue/bin/glue -t Dynamic \
  -T output.json \
  -f teamcity \
  --finding-file-path $GLUE_FILE \
  --teamcity-min-level 1 \
  --mapping-file /app/zaproxy_mapping.json \
  -z 1
