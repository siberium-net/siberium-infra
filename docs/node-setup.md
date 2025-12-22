# Node Setup Guide

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Siberium Logo" width="150"/>
</p>

## Overview

This guide provides three methods for deploying a Siberium node. Choose the method that best fits your requirements:

- **Method A: Quick Start** - Single Docker container, fastest deployment
- **Method B: Infrastructure Kit** - Full stack with explorer and services
- **Method C: From Source** - Manual Geth setup, maximum control

---

## Prerequisites

All methods require:

- **Operating System**: Linux (Ubuntu 20.04+), macOS, or Windows with WSL2
- **CPU**: 4+ cores (8+ recommended)
- **RAM**: 8GB minimum (16GB+ recommended)
- **Storage**: 200GB+ SSD (500GB+ recommended for long-term operation)
- **Network**: Stable internet connection (10+ Mbps)

### Additional Requirements by Method

**Method A & B:**
- Docker 20.10+ ([installation guide](https://docs.docker.com/engine/install/))
- Docker Compose v2+ ([installation guide](https://docs.docker.com/compose/install/))

**Method C:**
- Go 1.20+ ([installation guide](https://go.dev/doc/install))
- Git
- Build tools (gcc, make)

---

## Method A: Quick Start (Docker Image)

The fastest way to run a Siberium node using a pre-built Docker image.

### Step 1: Pull the Genesis File

```bash
# Create data directory
mkdir -p ./siberium-data

# Download genesis file for mainnet
curl -o ./genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/mainnet/genesis.json

# For testnet, use:
# curl -o ./genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/testnet/genesis.json
```

### Step 2: Run the Node

**For Mainnet:**

```bash
docker run -d \
  --name siberium-mainnet \
  -v $(pwd)/siberium-data:/root/.ethereum \
  -v $(pwd)/genesis.json:/config/genesis.json:ro \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -e NETWORK_ID=111111 \
  -e BOOTNODES="" \
  --restart unless-stopped \
  ghcr.io/siberium-net/siberium-node:latest
```

<!-- TODO: Replace with actual Docker image name when published to ghcr.io -->

**For Testnet:**

```bash
docker run -d \
  --name siberium-testnet \
  -v $(pwd)/siberium-data:/root/.ethereum \
  -v $(pwd)/genesis.json:/config/genesis.json:ro \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -e NETWORK_ID=111000 \
  -e BOOTNODES="" \
  --restart unless-stopped \
  ghcr.io/siberium-net/siberium-node:latest
```

<!-- TODO: Add actual bootnode addresses for BOOTNODES environment variable -->

### Step 3: Verify Node is Running

```bash
# Check logs
docker logs -f siberium-mainnet

# Test RPC connection
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Configuration Options

| Environment Variable | Description | Default |
|---------------------|-------------|---------|
| `NETWORK_ID` | Chain ID (111111 or 111000) | 111000 |
| `BOOTNODES` | Comma-separated bootnode enodes | (empty) |
| `STATIC_PEERS` | Comma-separated static peer enodes | (empty) |
| `DATADIR` | Data directory inside container | /root/.ethereum |

### Managing the Node

```bash
# Stop node
docker stop siberium-mainnet

# Start node
docker start siberium-mainnet

# Restart node
docker restart siberium-mainnet

# View logs
docker logs -f siberium-mainnet

# Remove node (data persists)
docker rm -f siberium-mainnet
```

---

## Method B: Infrastructure Kit (Docker Compose)

Deploy a complete infrastructure stack including node, block explorer, faucet, and gateway.

### Architecture

This method deploys:
- **Geth Node** (v1.13.14) - Full archive node
- **Blockscout** - Blockchain explorer
- **PostgreSQL** - Database for explorer
- **Nginx Gateway** - Reverse proxy with rate limiting
- **Faucet** - Token distribution service (testnet only)

### Step 1: Clone Repository

```bash
git clone https://github.com/siberium-net/siberium-infra.git
cd siberium-infra
```

<!-- TODO: Update repository URL when public -->

### Step 2: Configure Environment

**For Mainnet:**

```bash
# Copy example environment file
cp env.example networks/mainnet/.env

# Edit configuration
nano networks/mainnet/.env
```

Edit the following key parameters in `networks/mainnet/.env`:

```bash
# Network configuration
NETWORK_NAME=mainnet
NETWORK_ID=111111

# Ports on host machine
RPC_PORT=8545
WS_PORT=8546
GATEWAY_PORT=80
EXPLORER_PORT=4000

# Node connectivity
BOOTNODES=enode://[TODO: Add mainnet bootnode addresses]
STATIC_PEERS=

# Database credentials (change in production!)
POSTGRES_USER=blockscout
POSTGRES_PASSWORD=CHANGE_THIS_PASSWORD
POSTGRES_DB=blockscout

# Explorer secret (generate with: openssl rand -base64 64)
SECRET_KEY_BASE=GENERATE_AND_PASTE_SECRET_HERE
```

**For Testnet:**

```bash
# Copy example environment file
cp env.example networks/testnet/.env

# Edit configuration
nano networks/testnet/.env
```

Additional testnet-specific configuration:

```bash
# Faucet configuration
FAUCET_PRIVATE_KEY=YOUR_PRIVATE_KEY_HERE
FAUCET_RPC_URL=http://node:8545
FAUCET_AMOUNT=1
FAUCET_PORT=8000
```

### Step 3: Deploy Stack

**For Mainnet:**

```bash
./ops.sh mainnet up -d
```

**For Testnet:**

```bash
./ops.sh testnet up -d
```

### Step 4: Monitor Deployment

```bash
# Check service status
./ops.sh mainnet ps

# View logs for all services
./ops.sh mainnet logs -f

# View logs for specific service
./ops.sh mainnet logs -f node
./ops.sh mainnet logs -f blockscout
```

### Step 5: Access Services

Once deployed, services are available at:

| Service | URL | Description |
|---------|-----|-------------|
| RPC | http://localhost:8545 | JSON-RPC endpoint |
| WebSocket | ws://localhost:8546 | WebSocket endpoint |
| Explorer | http://localhost:4000 | Blockscout block explorer |
| Gateway | http://localhost:80 | Unified gateway (RPC + Explorer) |
| Faucet | http://localhost:8000 | Token faucet (testnet only) |

### Stack Management

```bash
# Stop all services
./ops.sh mainnet down

# Restart specific service
./ops.sh mainnet restart node

# View resource usage
./ops.sh mainnet stats

# Execute command in container
./ops.sh mainnet exec node geth attach /root/.ethereum/geth.ipc

# Remove all containers (data persists)
./ops.sh mainnet down

# Remove all data (WARNING: destructive)
./ops.sh mainnet down -v
rm -rf data/mainnet/
```

### Updating the Stack

```bash
# Pull latest images
./ops.sh mainnet pull

# Restart with new images
./ops.sh mainnet up -d

# Or rebuild from source
./ops.sh mainnet build --no-cache
./ops.sh mainnet up -d
```

### Production Considerations

#### 1. SSL/TLS Setup

For production, configure SSL/TLS using a reverse proxy:

```nginx
# /etc/nginx/sites-available/siberium
server {
    listen 443 ssl http2;
    server_name rpc.yourdomain.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8545;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

#### 2. Firewall Configuration

```bash
# Allow RPC and P2P ports
sudo ufw allow 8545/tcp  # RPC
sudo ufw allow 8546/tcp  # WebSocket
sudo ufw allow 30303/tcp # P2P
sudo ufw allow 30303/udp # P2P Discovery
```

#### 3. Monitoring

Set up monitoring with Prometheus and Grafana:

```bash
# Add to docker-compose.override.yml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
  
  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```

---

## Method C: From Source (Geth)

Build and run Geth manually for maximum control and customization.

### Step 1: Install Dependencies

**Ubuntu/Debian:**

```bash
sudo apt-get update
sudo apt-get install -y build-essential git golang-1.20
```

**macOS:**

```bash
brew install go git
```

### Step 2: Clone and Build Geth

```bash
# Clone go-ethereum repository
git clone https://github.com/ethereum/go-ethereum.git
cd go-ethereum

# Checkout stable version (v1.13.14)
git checkout v1.13.14

# Build Geth
make geth

# Verify installation
./build/bin/geth version
```

### Step 3: Download Genesis File

```bash
# Create directory structure
mkdir -p ~/siberium-node/data
cd ~/siberium-node

# Download mainnet genesis
curl -o genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/mainnet/genesis.json

# For testnet:
# curl -o genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/testnet/genesis.json
```

### Step 4: Initialize Node

```bash
# Initialize with genesis file
geth --datadir ./data init genesis.json
```

### Step 5: Start Node

**For Mainnet:**

```bash
geth \
  --datadir ./data \
  --networkid 111111 \
  --bootnodes "enode://[TODO: Add bootnode address]" \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.vhosts '*' \
  --http.corsdomain '*' \
  --http.api "eth,net,web3,txpool" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port 8546 \
  --ws.origins '*' \
  --ws.api "eth,net,web3,txpool" \
  --syncmode full \
  --gcmode archive \
  --maxpeers 50 \
  --cache 4096 \
  --verbosity 3
```

**For Testnet:**

```bash
geth \
  --datadir ./data \
  --networkid 111000 \
  --bootnodes "enode://[TODO: Add bootnode address]" \
  --http \
  --http.addr "0.0.0.0" \
  --http.port 8545 \
  --http.vhosts '*' \
  --http.corsdomain '*' \
  --http.api "eth,net,web3,txpool" \
  --ws \
  --ws.addr "0.0.0.0" \
  --ws.port 8546 \
  --ws.origins '*' \
  --ws.api "eth,net,web3,txpool" \
  --syncmode full \
  --gcmode archive \
  --maxpeers 50 \
  --cache 4096 \
  --verbosity 3
```

### Step 6: Run as System Service

Create a systemd service for automatic start:

```bash
sudo nano /etc/systemd/system/siberium.service
```

Add the following:

```ini
[Unit]
Description=Siberium Node
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/siberium-node
ExecStart=/usr/local/bin/geth \
  --datadir /home/YOUR_USERNAME/siberium-node/data \
  --networkid 111111 \
  --bootnodes "enode://[BOOTNODE_ADDRESS]" \
  --http \
  --http.addr 0.0.0.0 \
  --http.port 8545 \
  --http.vhosts '*' \
  --http.corsdomain '*' \
  --http.api eth,net,web3,txpool \
  --ws \
  --ws.addr 0.0.0.0 \
  --ws.port 8546 \
  --ws.origins '*' \
  --ws.api eth,net,web3,txpool \
  --syncmode full \
  --gcmode archive
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable siberium

# Start service
sudo systemctl start siberium

# Check status
sudo systemctl status siberium

# View logs
sudo journalctl -u siberium -f
```

### Geth Command Line Options

| Option | Description | Recommended Value |
|--------|-------------|-------------------|
| `--networkid` | Chain ID | 111111 (mainnet) / 111000 (testnet) |
| `--syncmode` | Sync mode | `full` or `snap` |
| `--gcmode` | Garbage collection | `full` or `archive` |
| `--cache` | Memory cache (MB) | 4096 (4GB) |
| `--maxpeers` | Max peer connections | 50 |
| `--http.api` | Enabled RPC APIs | `eth,net,web3,txpool` |
| `--verbosity` | Log level (0-5) | 3 |

---

## Node Monitoring and Diagnostics

### Check Sync Status

```bash
# Via RPC
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'

# Via Geth console
geth attach http://localhost:8545
> eth.syncing
```

### Check Peer Count

```bash
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'
```

### View Connected Peers

```bash
geth attach http://localhost:8545
> admin.peers
```

### Monitor Block Production

```bash
# Get current block
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Watch blocks in real-time
watch -n 3 'curl -s -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}" | jq'
```

### Resource Monitoring

```bash
# Disk usage
du -sh ~/siberium-node/data

# If using Docker
docker stats siberium-mainnet

# If using systemd
systemctl status siberium
```

---

## Troubleshooting

### Node Not Syncing

**Symptoms:** Block number stays at 0 or doesn't increase.

**Solutions:**
1. Check bootnode connectivity
2. Verify genesis file matches network
3. Ensure firewall allows P2P port (30303)
4. Check if time is synchronized (NTP)

```bash
# Check system time
timedatectl

# Sync time
sudo ntpdate -s time.nist.gov
```

### Out of Disk Space

**Symptoms:** Node stops, errors about disk space.

**Solutions:**
1. Increase disk space
2. Use `--gcmode full` instead of `archive`
3. Enable pruning (removes old state)

```bash
# Check disk usage
df -h

# Prune old data (stops node temporarily)
geth --datadir ./data snapshot prune-state
```

### High Memory Usage

**Symptoms:** System slowdown, OOM errors.

**Solutions:**
1. Reduce `--cache` value
2. Increase system RAM
3. Enable swap space

```bash
# Check memory usage
free -h

# Add swap space (4GB)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### RPC Not Responding

**Symptoms:** Connection refused or timeout errors.

**Solutions:**
1. Check node is running
2. Verify ports are not blocked
3. Ensure `--http` and `--http.addr` are set correctly

```bash
# Test local RPC
curl http://localhost:8545

# Check port binding
netstat -tuln | grep 8545

# Check firewall
sudo ufw status
```

---

## Performance Optimization

### Storage Optimization

- Use NVMe SSD for best performance
- Enable TRIM on SSDs
- Use XFS or EXT4 filesystem

### Network Optimization

```bash
# Increase file descriptor limits
sudo nano /etc/security/limits.conf
# Add:
* soft nofile 65536
* hard nofile 65536
```

### CPU Optimization

```bash
# Set CPU governor to performance
sudo cpupower frequency-set -g performance
```

---

## Security Best Practices

1. **Firewall Rules**: Only expose necessary ports
2. **RPC Authentication**: Use reverse proxy with authentication
3. **Rate Limiting**: Implement rate limiting on RPC endpoints
4. **Regular Updates**: Keep Geth and system packages updated
5. **Monitoring**: Set up alerting for node issues
6. **Backups**: Regular backups of critical data

---

## Next Steps

- [Connect MetaMask](metamask-guide.md) - Connect your wallet to the node
- [Network Details](network-details.md) - Learn more about Siberium networks
- [Resources](resources.md) - Additional tools and links

---

[Back to README](../README.md)




