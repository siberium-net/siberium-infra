# Siberium Infrastructure - Configuration Summary

## [COMPLETED] Docker Images Configuration

### Mainnet Image
**Image:** `ghcr.io/siberium-net/siberium-mainnet:latest`

**Built-in Configuration:**
- Network ID: `111111`
- Chain ID: `111111` (validated)
- Bootnode: `enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001`
- Genesis: Mainnet genesis file embedded

**Quick Start:**
```bash
docker run -d --name siberium-mainnet \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./siberium-data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-mainnet:latest
```

### Testnet Image
**Image:** `ghcr.io/siberium-net/siberium-testnet:latest`

**Built-in Configuration:**
- Network ID: `111000`
- Chain ID: `111000` (validated)
- Bootnode: `enode://e0c830715dd66fafd9ed6bd6cb0cae2e56b825f62e3a23fd4b6c0f5540b2d8574d8fac81823a65de1c9e5bd57d1156bc492c32c7061b92c7d4051b789bc82fb6@37.230.181.164:30003`
- Genesis: Testnet genesis file embedded

**Quick Start:**
```bash
docker run -d --name siberium-testnet \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./siberium-data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-testnet:latest
```

---

## Bootnode Details

### Mainnet Bootnode
- **Address:** `37.230.181.169:30001`
- **Enode:** `enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001`
- **Purpose:** Mainnet peer discovery

### Testnet Bootnode
- **Address:** `37.230.181.164:30003`
- **Enode:** `enode://e0c830715dd66fafd9ed6bd6cb0cae2e56b825f62e3a23fd4b6c0f5540b2d8574d8fac81823a65de1c9e5bd57d1156bc492c32c7061b92c7d4051b789bc82fb6@37.230.181.164:30003`
- **Purpose:** Testnet peer discovery

---

## Configuration Files

### Environment Templates

1. **`env.example`** - Generic template with commented examples
2. **`env.mainnet.example`** - Ready-to-use mainnet configuration
3. **`env.testnet.example`** - Ready-to-use testnet configuration

### Docker Compose Usage

```bash
# Mainnet
cp env.mainnet.example networks/mainnet/.env
./ops.sh mainnet up -d

# Testnet
cp env.testnet.example networks/testnet/.env
./ops.sh testnet up -d
```

---

## Build Instructions

### Build Docker Images

```bash
# Build both mainnet and testnet images
./build-images.sh

# With version tag
VERSION=v1.0.0 ./build-images.sh

# Build and push to registry
VERSION=v1.0.0 PUSH=true REGISTRY=ghcr.io/siberium-net ./build-images.sh
```

### Build Output

After successful build:
- `ghcr.io/siberium-net/siberium-mainnet:latest`
- `ghcr.io/siberium-net/siberium-mainnet:v1.0.0`
- `ghcr.io/siberium-net/siberium-testnet:latest`
- `ghcr.io/siberium-net/siberium-testnet:v1.0.0`

---

## Verification

### Check Node Logs

```bash
# Mainnet
docker logs -f siberium-mainnet

# Testnet
docker logs -f siberium-testnet
```

**Expected output:**
```
[INFO] Using genesis file: /root/genesis.json
[INFO] Network ID: 111111
[INFO] Mainnet mode - using mainnet bootnodes
[INFO] Using bootnodes: enode://c2517e5cf32c2be981b34d66c81a0fbf7674040f6b2789a07a68e338fd6e186c9eeeae8935d9bcb9d425e49f4089238fd446db542e223e23ce4d8a1a14f02e75@37.230.181.169:30001
[INFO] Starting Geth with network ID 111111...
INFO [12-07|23:00:00.000] Initialising Ethereum protocol           network=111,111
INFO [12-07|23:00:00.000] Chain ID:  111111 (unknown)
```

### Check Peer Connections

```bash
# Wait 1-2 minutes for peer discovery
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'
```

**Expected:** `{"jsonrpc":"2.0","id":1,"result":"0x1"}` or higher

### Check Block Sync

```bash
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

---

## Network Parameters

### Mainnet (Chain ID: 111111)
- **Consensus:** Clique PoA
- **Block Time:** 3 seconds
- **Gas Limit:** 4,700,000
- **Epoch:** 30,000 blocks
- **Bootnode:** 37.230.181.169:30001

### Testnet (Chain ID: 111000)
- **Consensus:** Clique PoA
- **Block Time:** 3 seconds
- **Gas Limit:** 4,700,000
- **Epoch:** 30,000 blocks
- **Bootnode:** 37.230.181.164:30003

---

## Port Configuration

### Node Ports
- **8545** - HTTP JSON-RPC
- **8546** - WebSocket
- **30303** - P2P (TCP and UDP)

### Full Stack Ports (Docker Compose)
- **8545** - Node RPC
- **8546** - Node WebSocket
- **4000** - Blockscout Explorer
- **80** - Nginx Gateway
- **8000** - Faucet (Testnet only)

---

## Security Notes

### Production Checklist

1. **Change Database Passwords**
   - Update `POSTGRES_PASSWORD` in `.env`
   - Generate secure `SECRET_KEY_BASE`

2. **Firewall Configuration**
   ```bash
   sudo ufw allow 8545/tcp  # RPC
   sudo ufw allow 8546/tcp  # WebSocket
   sudo ufw allow 30303/tcp # P2P
   sudo ufw allow 30303/udp # P2P Discovery
   ```

3. **SSL/TLS Setup**
   - Use reverse proxy (nginx/Caddy)
   - Configure HTTPS for RPC endpoints
   - Never expose RPC without authentication in production

4. **Resource Limits**
   - Set Docker memory limits
   - Configure disk space monitoring
   - Set up log rotation

---

## Troubleshooting

### Node Not Syncing

**Check bootnode connectivity:**
```bash
nc -zv 37.230.181.169 30001  # Mainnet
nc -zv 37.230.181.164 30003  # Testnet
```

**Check firewall:**
```bash
sudo ufw status
```

### No Peers

**Verify bootnode in logs:**
```bash
docker logs siberium-mainnet | grep -i bootnode
```

Should show: `[INFO] Using bootnodes: enode://...`

**Check peer count:**
```bash
curl -s -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' | jq
```

### Genesis Mismatch

**Error:** `Genesis file is not for mainnet`

**Solution:** Verify correct genesis file is being used
```bash
docker run --rm ghcr.io/siberium-net/siberium-mainnet:latest \
  cat /root/genesis.json | grep -o '"chainId":[[:space:]]*[0-9]*'
```

---

## Quick Reference Commands

### Docker Management

```bash
# Start node
docker run -d --name siberium-mainnet -p 8545:8545 -p 8546:8546 -p 30303:30303 -v ./data:/root/.ethereum ghcr.io/siberium-net/siberium-mainnet:latest

# View logs
docker logs -f siberium-mainnet

# Stop node
docker stop siberium-mainnet

# Restart node
docker restart siberium-mainnet

# Remove node (data persists in volume)
docker rm -f siberium-mainnet
```

### RPC Commands

```bash
# Get block number
curl -X POST http://localhost:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Get peer count
curl -X POST http://localhost:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'

# Get sync status
curl -X POST http://localhost:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'

# Get chain ID
curl -X POST http://localhost:8545 -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}'
```

---

## Documentation Links

- **[README.md](README.md)** - Main documentation
- **[BOOTNODE_FIX.md](BOOTNODE_FIX.md)** - Bootnode configuration fix details
- **[docs/bootnode-setup.md](docs/bootnode-setup.md)** - Complete bootnode guide
- **[docs/node-setup.md](docs/node-setup.md)** - Node deployment guide
- **[docs/network-details.md](docs/network-details.md)** - Network specifications

---

**Status:** [READY] All configurations are set and ready for deployment.

**Next Action:** Run `./build-images.sh` to build images with bootnode configuration.

