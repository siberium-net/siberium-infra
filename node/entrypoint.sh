#!/usr/bin/env bash
set -euo pipefail

NETWORK_ID="${NETWORK_ID:-111000}"
DATADIR="${DATADIR:-/root/.ethereum}"
CHAINDATA="${DATADIR}/geth/chaindata"
BOOTNODES="${BOOTNODES:-}"
STATIC_PEERS="${STATIC_PEERS:-}"

case "${NETWORK_ID}" in
  111111)
    GENESIS_PATH="/config/genesis_111111.json"
    ;;
  111000)
    GENESIS_PATH="/config/genesis_111000.json"
    ;;
  *)
    echo "[ERROR] Unsupported NETWORK_ID: ${NETWORK_ID}" >&2
    exit 1
    ;;
esac

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

exec geth \
  --datadir "${DATADIR}" \
  --networkid "${NETWORK_ID}" \
  --http --http.addr 0.0.0.0 --http.vhosts='*' --http.corsdomain='*' --http.api eth,net,web3,txpool \
  --ws --ws.addr 0.0.0.0 --ws.origins='*' --ws.api eth,net,web3,txpool \
  --syncmode full \
  --gcmode archive \
  --override.terminaltotaldifficulty 0 \
  --override.terminaltotaldifficultypassed \
  ${BOOTNODES:+--bootnodes "${BOOTNODES}"} \
  "$@"

