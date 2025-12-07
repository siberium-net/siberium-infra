#!/usr/bin/env bash
set -euo pipefail

# Default to mainnet if not specified
NETWORK_ID="${NETWORK_ID:-111111}"
DATADIR="${DATADIR:-/root/.ethereum}"
CHAINDATA="${DATADIR}/geth/chaindata"
GENESIS_PATH="${GENESIS_PATH:-}"
OVERRIDE_TTD="${OVERRIDE_TTD:-true}"
SUPPORTS_TTD_OVERRIDE=0

# Bootnodes - defaults for mainnet and testnet
# TODO: Replace with actual production bootnode addresses
if [ -z "${BOOTNODES:-}" ]; then
  if [ "${NETWORK_ID}" = "111111" ]; then
    # Mainnet bootnodes
    BOOTNODES="${BOOTNODES_MAINNET:-}"
    echo "[INFO] Mainnet mode - using mainnet bootnodes"
  elif [ "${NETWORK_ID}" = "111000" ]; then
    # Testnet bootnodes
    BOOTNODES="${BOOTNODES_TESTNET:-}"
    echo "[INFO] Testnet mode - using testnet bootnodes"
  else
    BOOTNODES=""
    echo "[WARN] Unknown network ID ${NETWORK_ID}, no default bootnodes available"
  fi
fi

STATIC_PEERS="${STATIC_PEERS:-}"

if geth --help 2>&1 | grep -q -- "--override.terminaltotaldifficulty"; then
  SUPPORTS_TTD_OVERRIDE=1
fi

# Locate genesis file
if [ -z "${GENESIS_PATH}" ]; then
  if [ -f "/config/genesis.json" ]; then
    GENESIS_PATH="/config/genesis.json"
  elif [ -f "/root/genesis.json" ]; then
    GENESIS_PATH="/root/genesis.json"
  fi
fi

if [ -z "${GENESIS_PATH}" ] || [ ! -f "${GENESIS_PATH}" ]; then
  echo "[ERROR] Genesis file not found. Checked /config/genesis.json and /root/genesis.json" >&2
  exit 1
fi

echo "[INFO] Using genesis file: ${GENESIS_PATH}"
echo "[INFO] Network ID: ${NETWORK_ID}"
echo "[INFO] Data directory: ${DATADIR}"

# Verify genesis matches network ID
GENESIS_CHAIN_ID=$(grep -o '"chainId":[[:space:]]*[0-9]*' "${GENESIS_PATH}" | grep -o '[0-9]*' | head -1)
if [ "${GENESIS_CHAIN_ID}" != "${NETWORK_ID}" ]; then
  echo "[ERROR] Genesis chain ID (${GENESIS_CHAIN_ID}) does not match NETWORK_ID (${NETWORK_ID})" >&2
  exit 1
fi

mkdir -p "${DATADIR}"

# Initialize if needed
if [ ! -d "${CHAINDATA}" ] || [ -z "$(ls -A "${CHAINDATA}" 2>/dev/null)" ]; then
  echo "[INFO] Chaindata is empty, initializing with ${GENESIS_PATH}"
  geth --datadir "${DATADIR}" init "${GENESIS_PATH}"
else
  echo "[INFO] Chaindata exists, skipping init"
fi

# Configure static peers if provided
if [ -n "${STATIC_PEERS}" ]; then
  echo "[INFO] Writing static peers configuration"
  mkdir -p "${DATADIR}/geth"
  IFS=',' read -r -a peers <<< "${STATIC_PEERS}"
  printf '[\n' > "${DATADIR}/geth/static-nodes.json"
  for i in "${!peers[@]}"; do
    peer_trimmed="$(echo "${peers[$i]}" | xargs)"
    sep=$([ "$i" -lt $((${#peers[@]} - 1)) ] && echo "," || echo "")
    printf '  "%s"%s\n' "${peer_trimmed}" "${sep}" >> "${DATADIR}/geth/static-nodes.json"
  done
  printf ']\n' >> "${DATADIR}/geth/static-nodes.json"
  echo "[INFO] Static peers configured"
fi

# Build geth arguments
GETH_ARGS=(
  --datadir "${DATADIR}"
  --networkid "${NETWORK_ID}"
  --http --http.addr 0.0.0.0 --http.vhosts='*' --http.corsdomain='*' --http.api eth,net,web3,txpool
  --ws --ws.addr 0.0.0.0 --ws.origins='*' --ws.api eth,net,web3,txpool
  --syncmode full
  --gcmode archive
)

# Add bootnodes if configured
if [ -n "${BOOTNODES}" ]; then
  echo "[INFO] Using bootnodes: ${BOOTNODES}"
  GETH_ARGS+=(--bootnodes "${BOOTNODES}")
else
  echo "[WARN] No bootnodes configured. Node may not sync without peer discovery."
  echo "[WARN] Set BOOTNODES or STATIC_PEERS environment variable to connect to network."
fi

# TTD override for PoA chains
if [ "${OVERRIDE_TTD,,}" = "true" ] && [ "${SUPPORTS_TTD_OVERRIDE}" = "1" ]; then
  GETH_ARGS+=(--override.terminaltotaldifficulty 0 --override.terminaltotaldifficultypassed)
  echo "[INFO] TTD override enabled"
elif [ "${OVERRIDE_TTD,,}" = "true" ] && [ "${SUPPORTS_TTD_OVERRIDE}" != "1" ]; then
  echo "[WARN] OVERRIDE_TTD=true but geth does not support override flags; consider using geth v1.13.x" >&2
fi

echo "[INFO] Starting Geth with network ID ${NETWORK_ID}..."
echo "[INFO] RPC endpoint will be available at http://0.0.0.0:8545"
echo "[INFO] WebSocket endpoint will be available at ws://0.0.0.0:8546"

exec geth "${GETH_ARGS[@]}" "$@"
