#!/bin/bash

# Abort script on error
set -e
set -x

function run_tests()
{
  # Put here the code requires to run your tests (e.g. dotnet test)
}

if [ -z "$PROXY_URL" ]
then
  echo PROXY_URL is not set, not running security checks
  run_tests
else
  ls -la
  ZAP_URL=$(echo $PROXY_URL | sed -e 's/https\?:\/\///')
  ./wait-for-it.sh $ZAP_URL -t 300
  echo "Zap is ready"

  # Create new session
  curl --fail $PROXY_URL/JSON/core/action/newSession 2> /dev/null

  # Enable all scanners
  curl --fail $PROXY_URL/JSON/pscan/action/enableAllScanners 2> /dev/null

  #Clear exclude from proxy
  curl --fail $PROXY_URL/JSON/core/action/clearExcludedFromProxy 2> /dev/null

  # Optional: disbable rules by ID, add the ruls you want to disable gloablly
  # curl --fail $PROXY_URL/JSON/pscan/action/disableScanners/?ids=<> 2> /dev/null

  # Ignore all URL by regex from scan
  # curl --fail $PROXY_URL/JSON/core/action/excludeFromProxy/?regex=<> 2> /dev/null

  run_tests

  echo "waiting for zap to finish scanning"

  while [ "$(curl --fail $PROXY_URL/JSON/pscan/view/recordsToScan 2> /dev/null | jq '.recordsToScan')" != '"0"' ]; do sleep 1; done

  # Save the session so we can open it in the next phase.
  curl $PROXY_URL/JSON/core/action/saveSession/?name=blackbox\&overwrite=true 2> /dev/null
fi
