FROM ruby:2.4-alpine as build-context

WORKDIR /app

RUN apk add --update jq wget tar libffi-dev build-base ruby-dev curl curl-dev sqlite-dev bash && \
    wget https://raw.githubusercontent.com/vishnubob/wait-for-it/8ed92e8cab83cfed76ff012ed4a36cef74b28096/wait-for-it.sh && \
    chmod +x wait-for-it.sh

ARG GLUE_REPO=omerlh
ARG GLUE_BRACNH=production
ENV BASE_URL=""
ENV SESSON_NAME=""
ENV GLUE_FILE=""

RUN mkdir /glue && \
    cd /glue && \
    wget https://github.com/$GLUE_REPO/glue/archive/$GLUE_BRACNH.tar.gz && \
    tar -zxf $GLUE_BRACNH.tar.gz --strip-components=1 && \
    rm -rf $GLUE_BRACNH.tar.gz && \
    bundle install

COPY run_glue.sh .
RUN chmod +x run_glue.sh 