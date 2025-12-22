#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

VERSION="${VERSION:-latest}"
REGISTRY="${REGISTRY:-ghcr.io/siberium-net}"
PUSH="${PUSH:-false}"

echo "[INFO] Building Siberium node Docker images"
echo "[INFO] Version: ${VERSION}"
echo "[INFO] Registry: ${REGISTRY}"

# Build mainnet image
echo ""
echo "[INFO] Building mainnet image..."
docker build \
  -f services/node/Dockerfile.mainnet \
  -t "${REGISTRY}/siberium-mainnet:${VERSION}" \
  -t "${REGISTRY}/siberium-mainnet:latest" \
  .

if [ $? -eq 0 ]; then
  echo "[OK] Mainnet image built successfully"
else
  echo "[ERROR] Failed to build mainnet image"
  exit 1
fi

# Build testnet image
echo ""
echo "[INFO] Building testnet image..."
docker build \
  -f services/node/Dockerfile.testnet \
  -t "${REGISTRY}/siberium-testnet:${VERSION}" \
  -t "${REGISTRY}/siberium-testnet:latest" \
  .

if [ $? -eq 0 ]; then
  echo "[OK] Testnet image built successfully"
else
  echo "[ERROR] Failed to build testnet image"
  exit 1
fi

# List built images
echo ""
echo "[INFO] Built images:"
docker images | grep -E "(siberium-mainnet|siberium-testnet)" | head -4

# Push if requested
if [ "${PUSH}" = "true" ]; then
  echo ""
  echo "[INFO] Pushing images to registry..."
  
  docker push "${REGISTRY}/siberium-mainnet:${VERSION}"
  docker push "${REGISTRY}/siberium-mainnet:latest"
  echo "[OK] Pushed mainnet images"
  
  docker push "${REGISTRY}/siberium-testnet:${VERSION}"
  docker push "${REGISTRY}/siberium-testnet:latest"
  echo "[OK] Pushed testnet images"
fi

echo ""
echo "[OK] Build completed successfully"
echo ""
echo "To run mainnet node:"
echo "  docker run -d -p 8545:8545 -p 8546:8546 -v ./data:/root/.ethereum ${REGISTRY}/siberium-mainnet:latest"
echo ""
echo "To run testnet node:"
echo "  docker run -d -p 8545:8545 -p 8546:8546 -v ./data:/root/.ethereum ${REGISTRY}/siberium-testnet:latest"
echo ""




