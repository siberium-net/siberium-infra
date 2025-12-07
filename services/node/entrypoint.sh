#!/usr/bin/env bash
set -euo pipefail

NETWORK_ID="${NETWORK_ID:-111000}"
DATADIR="${DATADIR:-/root/.ethereum}"
CHAINDATA="${DATADIR}/geth/chaindata"
BOOTNODES="${BOOTNODES:-}"
STATIC_PEERS="${STATIC_PEERS:-}"
GENESIS_PATH="/config/genesis.json"
OVERRIDE_TTD="${OVERRIDE_TTD:-true}"
SUPPORTS_TTD_OVERRIDE=0

if geth --help 2>&1 | grep -q -- "--override.terminaltotaldifficulty"; then
  SUPPORTS_TTD_OVERRIDE=1
fi

if [ ! -f "${GENESIS_PATH}" ]; then
  echo "[ERROR] Genesis file not found at ${GENESIS_PATH}" >&2
  exit 1
fi

mkdir -p "${DATADIR}"

if [ ! -d "${CHAINDATA}" ] || [ -z "$(ls -A "${CHAINDATA}" 2>/dev/null)" ]; then
  echo "[INFO] chaindata is empty, initializing with ${GENESIS_PATH}"
  geth --datadir "${DATADIR}" init "${GENESIS_PATH}"
else
  echo "[INFO] chaindata exists, skipping init"
fi

# Configure static peers if provided
if [ -n "${STATIC_PEERS}" ]; then
  echo "[INFO] writing static peers"
  mkdir -p "${DATADIR}/geth"
  IFS=',' read -r -a peers <<< "${STATIC_PEERS}"
  printf '[\n' > "${DATADIR}/geth/static-nodes.json"
  for i in "${!peers[@]}"; do
    peer_trimmed="$(echo "${peers[$i]}" | xargs)"
    sep=$([ "$i" -lt $((${#peers[@]} - 1)) ] && echo "," || echo "")
    printf '  "%s"%s\n' "${peer_trimmed}" "${sep}" >> "${DATADIR}/geth/static-nodes.json"
  done
  printf ']\n' >> "${DATADIR}/geth/static-nodes.json"
fi

GETH_ARGS=(
  --datadir "${DATADIR}"
  --networkid "${NETWORK_ID}"
  --http --http.addr 0.0.0.0 --http.vhosts='*' --http.corsdomain='*' --http.api eth,net,web3,txpool
  --ws --ws.addr 0.0.0.0 --ws.origins='*' --ws.api eth,net,web3,txpool
  --syncmode full
  --gcmode archive
)

if [ -n "${BOOTNODES}" ]; then
  GETH_ARGS+=(--bootnodes "${BOOTNODES}")
fi

if [ "${OVERRIDE_TTD,,}" = "true" ] && [ "${SUPPORTS_TTD_OVERRIDE}" = "1" ]; then
  GETH_ARGS+=(--override.terminaltotaldifficulty 0 --override.terminaltotaldifficultypassed)
elif [ "${OVERRIDE_TTD,,}" = "true" ] && [ "${SUPPORTS_TTD_OVERRIDE}" != "1" ]; then
  echo "[WARN] OVERRIDE_TTD=true but geth does not support override flags; consider using geth v1.13.x" >&2
fi

exec geth "${GETH_ARGS[@]}" "$@"

