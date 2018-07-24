FROM owasp/glue:raw-latest@sha256:eefac15b3e2b42d56f4c1146750d5a98913bfe95db592c2e72a2b5629cc6612c

LABEL maintainer="omer.levihevroni@owasp.org"

WORKDIR /app

RUN apk add --update --no-cache jq 

ENV GLUE_FILE=""

COPY . .
RUN chmod +x run_glue.sh 