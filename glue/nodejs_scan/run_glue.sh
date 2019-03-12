#!/bin/sh

# Abort script on error
set -e
set -x 

GLUE_FILE=$1
REPORT_FILE=$2


jq -f nodejs_scan/jq_pattern $REPORT_FILE > output.json

ruby /glue/bin/glue -t Dynamic \
  -T output.json \
  --finding-file-path $GLUE_FILE \
  --mapping-file /app/nodejs_scan/nodejs_scan_mapping.json \
  -z 1
