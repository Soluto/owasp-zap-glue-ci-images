FROM owasp/zap2docker-weekly

LABEL maintainer="omer.levihevroni@owasp.org"

ENV ZAP_DIR=/home/zap/.ZAP

RUN zap.sh -cmd -addonupdate -addoninstall pscanrulesAlpha -addoninstall pscanrulesBeta -addoninstall pscanrules

COPY scripts /home/zap/scripts/

COPY config.xml $ZAP_DIR/

USER root

RUN chown zap $ZAP_DIR && chgrp zap $ZAP_DIR

USER zap

CMD zap.sh -daemon -dir $ZAP_DIR -host 0.0.0.0 -port 8090 -config api.disablekey=true -config database.recoverylog=false -config connection.timeoutInSecs=120 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true
