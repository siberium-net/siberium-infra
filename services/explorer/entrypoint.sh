#!/bin/sh
set -eu

FEATURE_FLAGS_PATH="${FEATURE_FLAGS_PATH:-/app/config/feature-flags.env}"

if [ -f "$FEATURE_FLAGS_PATH" ]; then
  set -a
  # shellcheck disable=SC1090
  . "$FEATURE_FLAGS_PATH"
  set +a
fi

if [ -z "${SECRET_KEY_BASE:-}" ]; then
  if command -v openssl >/dev/null 2>&1; then
    SECRET_KEY_BASE="$(openssl rand -base64 48)"
  else
    SECRET_KEY_BASE="$(head -c 48 /dev/urandom | base64)"
  fi
  export SECRET_KEY_BASE
fi

if [ "${CHAIN_TYPE:-}" = "mainnet" ]; then
  CHAIN_TYPE="default"
  export CHAIN_TYPE
fi

if [ "$#" -gt 0 ]; then
  exec "$@"
fi

exec /app/bin/blockscout start
