FROM owasp/zap2docker-bare

LABEL maintainer="omerlh@gmail.com"

ENV ZAP_DIR=/home/zap/.ZAP

RUN zap.sh -cmd -addonupdate -addoninstall pscanrulesAlpha -addoninstall pscanrulesBeta -addoninstall pscanrules

COPY scripts /home/zap/scripts/

COPY config.xml $ZAP_DIR/

USER root

RUN chown zap $ZAP_DIR/config.xml && chgrp zap $ZAP_DIR/config.xml

USER zap

CMD zap.sh -daemon -dir $ZAP_DIR -host 0.0.0.0 -port 8090 -config api.disablekey=true -config database.recoverylog=false -config connection.timeoutInSecs=120 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true
