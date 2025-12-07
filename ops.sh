#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <network> <compose-args...>" >&2
  echo "Example: $0 mainnet up -d" >&2
  exit 1
fi

NETWORK="$1"
shift

ENV_FILE="networks/${NETWORK}/.env"

if [ ! -f "${ENV_FILE}" ]; then
  echo "Missing env file: ${ENV_FILE}" >&2
  exit 1
fi

if docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD=(docker-compose)
else
  echo "docker compose or docker-compose not found" >&2
  exit 1
fi

"${COMPOSE_CMD[@]}" --env-file "${ENV_FILE}" -p "siberium-${NETWORK}" -f docker-compose.yml "$@"

