# QUICK FIX: Bootnode Configuration Issue

## Problem Identified

The Docker images `siberium-mainnet` and `siberium-testnet` had the following issues:

1. **Wrong default Network ID**: Defaulted to 111000 (testnet) instead of 111111 (mainnet)
2. **Missing bootnodes**: No default bootnode addresses configured
3. **No network validation**: Genesis chain ID mismatch wasn't detected

## What Was Fixed

### 1. Separate Dockerfiles Created

- `services/node/Dockerfile.mainnet` - Mainnet-specific image with ENV NETWORK_ID=111111
- `services/node/Dockerfile.testnet` - Testnet-specific image with ENV NETWORK_ID=111000
- Both include genesis validation at build time

### 2. Enhanced Entrypoint Script

`services/node/entrypoint.sh` now:
- Defaults to mainnet (NETWORK_ID=111111) if not specified
- Validates genesis chain ID matches NETWORK_ID
- Provides clear logging for debugging
- Warns when bootnodes are missing
- Automatically selects bootnodes based on network ID

### 3. Build Script Added

`build-images.sh` - Builds both mainnet and testnet images with proper tags

## How to Build Fixed Images

```bash
cd /home/user/src/siberium-infra

# Build both images
./build-images.sh

# Or with specific version
VERSION=v1.0.1 ./build-images.sh

# Build and push to registry
VERSION=v1.0.1 PUSH=true REGISTRY=ghcr.io/siberium-net ./build-images.sh
```

## Configure Bootnodes (COMPLETED!)

### Configured Bootnodes

**Mainnet bootnode:**
```
enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001
```

**Testnet bootnode:**
```
enode://e0c830715dd66fafd9ed6bd6cb0cae2e56b825f62e3a23fd4b6c0f5540b2d8574d8fac81823a65de1c9e5bd57d1156bc492c32c7061b92c7d4051b789bc82fb6@37.230.181.164:30003
```

These bootnodes are now configured in:
- `services/node/Dockerfile.mainnet` → `ENV BOOTNODES_MAINNET`
- `services/node/Dockerfile.testnet` → `ENV BOOTNODES_TESTNET`

### Build Images with Bootnodes

```bash
./build-images.sh
```

### Test Locally

```bash
# Run mainnet
docker run -d --name test-mainnet \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./test-data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-mainnet:latest

# Check logs
docker logs -f test-mainnet

# Should see:
# [INFO] Mainnet mode - using mainnet bootnodes
# [INFO] Using bootnodes: enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001
# [INFO] Starting Geth with network ID 111111...
```

### Verify Peer Connections

```bash
# Wait 1-2 minutes, then check peers
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'

# Should return: {"jsonrpc":"2.0","id":1,"result":"0x1"} or higher
```

## Alternative: Runtime Configuration (if not rebuilding)

If you don't want to rebuild images, pass bootnodes at runtime:

**Mainnet:**
```bash
docker run -d --name siberium-mainnet \
  -e NETWORK_ID=111111 \
  -e BOOTNODES="enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001" \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-mainnet:latest
```

**Testnet:**
```bash
docker run -d --name siberium-testnet \
  -e NETWORK_ID=111000 \
  -e BOOTNODES="enode://e0c830715dd66fafd9ed6bd6cb0cae2e56b825f62e3a23fd4b6c0f5540b2d8574d8fac81823a65de1c9e5bd57d1156bc492c32c7061b92c7d4051b789bc82fb6@37.230.181.164:30003" \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-testnet:latest
```

## Expected Output After Fix

```
[INFO] Using genesis file: /root/genesis.json
[INFO] Network ID: 111111
[INFO] Data directory: /root/.ethereum
[INFO] Chaindata is empty, initializing with /root/genesis.json
[INFO] Mainnet mode - using mainnet bootnodes
[INFO] Using bootnodes: enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001
[INFO] Starting Geth with network ID 111111...
[INFO] RPC endpoint will be available at http://0.0.0.0:8545
[INFO] WebSocket endpoint will be available at ws://0.0.0.0:8546

INFO [12-07|23:00:00.000] Initialising Ethereum protocol           network=111,111 dbversion=8
INFO [12-07|23:00:00.000] Chain ID:  111111 (unknown)
INFO [12-07|23:00:01.000] Looking for peers                        peercount=0 tried=1 static=0
```

## Documentation

Full details in:
- [docs/bootnode-setup.md](docs/bootnode-setup.md) - Complete bootnode configuration guide
- [docs/node-setup.md](docs/node-setup.md) - General node setup documentation

## Next Steps

1. **Build images with bootnodes**:
```bash
./build-images.sh
```

2. **Test locally** - Verify node starts and connects to peers

3. **Push to registry** (when ready):
```bash
VERSION=v1.0.0 PUSH=true REGISTRY=ghcr.io/siberium-net ./build-images.sh
```

4. **Update documentation** - Bootnodes are now documented in:
   - `env.mainnet.example`
   - `env.testnet.example`
   - `env.example` (with commented examples)

## Questions?

Open an issue or check the full documentation in `docs/`.

