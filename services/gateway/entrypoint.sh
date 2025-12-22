#!/bin/sh
set -eu

: "${RPC_HOSTS:=_}"
: "${EXPLORER_HOSTS:=_}"
: "${MAIN_DOMAIN:=_}"

envsubst '${RPC_HOSTS} ${EXPLORER_HOSTS} ${MAIN_DOMAIN}' \
  < /etc/nginx/templates/nginx.conf.template \
  > /etc/nginx/nginx.conf

exec "$@"
