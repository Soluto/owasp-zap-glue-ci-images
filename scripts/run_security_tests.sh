#!/usr/bin/env bash

docker run --rm -v $(pwd)/glue:/input soluto/glue-ci:1524727926467 sh -x /app/run_glue.sh /input/glue.json /input/report.json