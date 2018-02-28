FROM soluto/glue:1519813692779

LABEL maintainer="omerlh@gmail.com"

WORKDIR /app

RUN apk add --update jq wget bash curl && \
    wget https://raw.githubusercontent.com/vishnubob/wait-for-it/8ed92e8cab83cfed76ff012ed4a36cef74b28096/wait-for-it.sh && \
    chmod +x wait-for-it.sh

ENV BASE_URL=""
ENV SESSON_NAME=""
ENV GLUE_FILE=""

COPY run_glue.sh .
RUN chmod +x run_glue.sh 