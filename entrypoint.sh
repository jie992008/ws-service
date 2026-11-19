#!/bin/sh
set -e
: "${PORT:=10000}"
: "${UUID:?UUID env var is required}"
: "${WS_PATH:=/ray}"
# Render config from template using env vars
sed -e "s|\${PORT}|${PORT}|g" \
    -e "s|\${UUID}|${UUID}|g" \
    -e "s|\${WS_PATH}|${WS_PATH}|g" \
    /app/config.json.template > /app/config.json
# Keepalive: Render free services spin down after ~15 min without inbound
# traffic. Ping our own public URL every 10 minutes to stay warm.
# (Single always-on service ≈ 720 h/month, inside the 750 h free pool.)
if [ -n "${RENDER_EXTERNAL_URL}" ]; then
  ( while true; do
      sleep 600
      curl -fsS --max-time 30 "${RENDER_EXTERNAL_URL}${WS_PATH}" >/dev/null 2>&1 || true
    done ) &
fi
exec /usr/local/bin/xray run -config /app/config.json
