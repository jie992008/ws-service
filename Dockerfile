FROM alpine:3.20
RUN apk add --no-cache ca-certificates curl unzip && \
    curl -fsSL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v25.6.8/Xray-linux-64.zip && \
    unzip -o /tmp/xray.zip xray -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/xray && rm /tmp/xray.zip
COPY config.json.template /app/config.json.template
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
