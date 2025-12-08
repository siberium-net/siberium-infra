# Bootnode Configuration Guide

This guide explains how to configure bootnodes for Siberium network nodes.

## What are Bootnodes?

Bootnodes are special nodes that help new nodes discover and connect to peers in the network. They act as entry points for peer discovery.

## Current Status

[IMPORTANT] Bootnode addresses need to be configured before the network can operate properly.

## Bootnode Enode Format

Bootnode addresses use the enode URL scheme:

```
enode://PUBLIC_KEY@IP_ADDRESS:PORT
```

Example:
```
enode://a979fb575495b8d6db44f750317d0f4622bf4c2aa3365d6af7c284339968eef29b69ad0dce72a4d8db5ebb4968de0e3bec910127f134779fbcb0cb6d3331163c@52.16.188.185:30303
```

## Configuration Methods

### Method 1: Environment Variables (Docker)

When running Docker images, set bootnodes via environment variables:

**Mainnet:**
```bash
docker run -d \
  -e NETWORK_ID=111111 \
  -e BOOTNODES="enode://MAINNET_BOOTNODE_1@IP:PORT,enode://MAINNET_BOOTNODE_2@IP:PORT" \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-mainnet:latest
```

**Testnet:**
```bash
docker run -d \
  -e NETWORK_ID=111000 \
  -e BOOTNODES="enode://TESTNET_BOOTNODE_1@IP:PORT,enode://TESTNET_BOOTNODE_2@IP:PORT" \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-testnet:latest
```

### Method 2: Build-time Configuration

Set default bootnodes in Dockerfile:

**For Mainnet** (`services/node/Dockerfile.mainnet`):
```dockerfile
ENV BOOTNODES_MAINNET="enode://abc123...@ip1:port,enode://def456...@ip2:port"
```

**For Testnet** (`services/node/Dockerfile.testnet`):
```dockerfile
ENV BOOTNODES_TESTNET="enode://test123...@ip1:port,enode://test456...@ip2:port"
```

Then rebuild images:
```bash
./build-images.sh
```

### Method 3: Docker Compose

In `networks/{mainnet,testnet}/.env`:

```bash
# Mainnet
BOOTNODES=enode://MAINNET_BOOTNODE_1@IP:PORT,enode://MAINNET_BOOTNODE_2@IP:PORT

# Testnet  
BOOTNODES=enode://TESTNET_BOOTNODE_1@IP:PORT,enode://TESTNET_BOOTNODE_2@IP:PORT
```

### Method 4: Static Peers

Alternative to bootnodes - connect directly to specific peers:

```bash
docker run -d \
  -e STATIC_PEERS="enode://PEER_1@IP:PORT,enode://PEER_2@IP:PORT" \
  -p 8545:8545 -p 8546:8546 -p 30303:30303 \
  -v ./data:/root/.ethereum \
  ghcr.io/siberium-net/siberium-mainnet:latest
```

## How to Generate Bootnode

### Option 1: Using Existing Node

If you have a running node:

```bash
# Attach to running node
docker exec -it siberium-mainnet geth attach /root/.ethereum/geth.ipc

# Get node info
> admin.nodeInfo.enode
"enode://PUBLIC_KEY@[::]:30303"
```

Replace `[::]` with your public IP address.

### Option 2: Using Bootnode Binary

```bash
# Generate bootnode key
docker run --rm ethereum/client-go:v1.13.14 bootnode -genkey /tmp/boot.key

# Get public key
docker run --rm -v $(pwd):/data ethereum/client-go:v1.13.14 \
  bootnode -nodekey /data/boot.key -writeaddress

# Run bootnode
docker run -d -p 30301:30301 -p 30301:30301/udp \
  -v $(pwd)/boot.key:/boot.key \
  ethereum/client-go:v1.13.14 \
  bootnode -nodekey /boot.key -addr :30301
```

## Recommended Setup

### Mainnet

**Minimum:** 2 bootnodes in different geographic regions
**Recommended:** 4-6 bootnodes for redundancy

Example configuration:
```bash
BOOTNODES_MAINNET="\
enode://[bootnode1]@bootnode1.siberium.net:30303,\
enode://[bootnode2]@bootnode2.siberium.net:30303,\
enode://[bootnode3]@bootnode3.siberium.net:30303"
```

### Testnet

**Minimum:** 1 bootnode
**Recommended:** 2-3 bootnodes

Example configuration:
```bash
BOOTNODES_TESTNET="\
enode://[testnode1]@testnet1.siberium.net:30303,\
enode://[testnode2]@testnet2.siberium.net:30303"
```

## Verification

After configuring bootnodes, verify peer connections:

```bash
# Check peer count
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'

# List connected peers
docker exec siberium-mainnet geth attach --exec "admin.peers" /root/.ethereum/geth.ipc
```

Expected result: `net_peerCount` > 0 within a few minutes.

## Troubleshooting

### No Peers Connecting

1. **Check firewall:** Port 30303 (TCP and UDP) must be open
2. **Verify bootnode addresses:** Ensure enode format is correct
3. **Check network connectivity:** Ping bootnode IP addresses
4. **Verify network ID:** Must match genesis chain ID

### Bootnode Unreachable

```bash
# Test bootnode connectivity
nc -zv BOOTNODE_IP 30303

# Check if bootnode is running
telnet BOOTNODE_IP 30303
```

### Node Connects Then Disconnects

- Check that genesis files match between nodes
- Verify network IDs are identical
- Ensure system time is synchronized (use NTP)

## Security Considerations

1. **DDoS Protection:** Bootnodes should have DDoS protection
2. **Redundancy:** Run bootnodes in different availability zones
3. **Monitoring:** Monitor bootnode uptime and peer counts
4. **Updates:** Keep bootnode software updated

## TODO: Production Configuration

Before production deployment, configure actual bootnode addresses:

1. Deploy 3-6 dedicated bootnode servers
2. Generate enode addresses for each bootnode
3. Update Dockerfiles:
   - `services/node/Dockerfile.mainnet` → `ENV BOOTNODES_MAINNET`
   - `services/node/Dockerfile.testnet` → `ENV BOOTNODES_TESTNET`
4. Rebuild and push Docker images
5. Update documentation with actual bootnode addresses

---

For questions, open an issue on GitHub or contact the network operators.


