FROM owasp/zap2docker-bare

ENV ZAP_DIR=/home/zap/.ZAP

RUN zap.sh -cmd -addonupdate -addoninstall pscanrulesAlpha -addoninstall pscanrulesBeta -addoninstall pscanrules

CMD zap.sh -daemon -dir $ZAP_DIR -host 0.0.0.0 -port 8090 -config api.disablekey=true -config database.recoverylog=false -config connection.timeoutInSecs=120 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true
