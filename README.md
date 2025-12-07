# Siberium Infrastructure

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Siberium Logo" width="200"/>
</p>

<p align="center">
  <strong>Enterprise-grade blockchain infrastructure for Siberium Network</strong>
</p>

<p align="center">
  <a href="#quick-start">[QUICK START]</a> •
  <a href="docs/network-details.md">[NETWORK DETAILS]</a> •
  <a href="docs/node-setup.md">[NODE SETUP]</a> •
  <a href="docs/metamask-guide.md">[METAMASK]</a> •
  <a href="docs/resources.md">[RESOURCES]</a> •
  <a href="README_RU.md">[RU]</a>
</p>

---

## Overview

Siberium is an EVM-compatible Layer 1 blockchain designed for high-performance decentralized applications. This repository contains the complete infrastructure stack for deploying and operating Siberium network nodes, block explorers, and supporting services.

### Networks

- **Mainnet** (Chain ID: 111111) - Production network
- **Testnet** (Chain ID: 111000) - Testing and development network

### Key Features

- **EVM Compatibility** - Full Ethereum Virtual Machine support
- **High Performance** - 3-second block time with optimized consensus
- **Complete Stack** - Node, explorer, faucet, and gateway services
- **Docker-based** - Containerized deployment for reliability
- **Infrastructure-ready** - Production-grade configuration

---

## Quick Start

### Prerequisites

- Docker 20.10+ and Docker Compose v2+
- 4GB+ RAM, 100GB+ storage (SSD recommended)
- Linux/macOS/Windows with WSL2

### Deploy Mainnet Node

```bash
# Clone the repository
git clone https://github.com/siberium-net/siberium-infra.git
cd siberium-infra

# Configure environment
cp env.example networks/mainnet/.env
nano networks/mainnet/.env  # Edit configuration

# Start the node
./ops.sh mainnet up -d

# Check logs
./ops.sh mainnet logs -f node
```

### Deploy Testnet Node

```bash
# Configure testnet
cp env.example networks/testnet/.env
nano networks/testnet/.env  # Edit configuration

# Start testnet
./ops.sh testnet up -d
```

Your node RPC will be available at `http://localhost:8545` (or configured port).

---

## Architecture

This infrastructure stack includes:

| Service | Description | Port |
|---------|-------------|------|
| **Node** | Geth (v1.13.14) full node | 8545 (RPC), 8546 (WS) |
| **Explorer** | Blockscout block explorer | 4000 |
| **Database** | PostgreSQL 15 for explorer | 5432 (internal) |
| **Gateway** | Nginx reverse proxy with rate limiting | 80 |
| **Faucet** | Testnet token faucet | 8000 |

### Network Configuration

- **Consensus**: Proof of Authority
- **Block Time**: 3 seconds
- **Gas Limit**: 4,700,000
- **Sync Mode**: Full (archive mode supported)

---

## Documentation

### Network Information
- [Network Details](docs/network-details.md) - Chain IDs, RPC endpoints, explorers
- [MetaMask Integration](docs/metamask-guide.md) - Connect wallets to Siberium

### Node Operations
- [Node Setup Guide](docs/node-setup.md) - Three deployment methods:
  - Quick Start (Docker Image)
  - Infrastructure Kit (Docker Compose)
  - From Source (Geth)

### Resources
- [Resources](docs/resources.md) - Faucets, bridges, community links

---

## Configuration

### Environment Variables

Key configuration options in `networks/{mainnet,testnet}/.env`:

```bash
NETWORK_NAME=mainnet          # Network identifier
NETWORK_ID=111111            # Chain ID
RPC_PORT=8545                # RPC port on host
WS_PORT=8546                 # WebSocket port
EXPLORER_PORT=4000           # Blockscout port
```

See [`env.example`](env.example) for all available options.

### Genesis Configuration

Genesis files define the network initialization:
- Mainnet: [`networks/mainnet/genesis.json`](networks/mainnet/genesis.json)
- Testnet: [`networks/testnet/genesis.json`](networks/testnet/genesis.json)

---

## Operations

### Managing Services

```bash
# Start all services
./ops.sh mainnet up -d

# Stop services
./ops.sh mainnet down

# View logs
./ops.sh mainnet logs -f node

# Restart node
./ops.sh mainnet restart node

# Check status
./ops.sh mainnet ps
```

### Data Persistence

Blockchain data is stored in `./data/{network}/`:
- `geth/` - Node blockchain data
- `pg/` - Explorer database
- `faucet/` - Faucet database (testnet)

### Backup and Recovery

```bash
# Backup node data
tar -czf backup-mainnet-$(date +%Y%m%d).tar.gz data/mainnet/geth

# Restore from backup
./ops.sh mainnet down
tar -xzf backup-mainnet-20231201.tar.gz
./ops.sh mainnet up -d
```

---

## Network Connectivity

### Bootnodes

Configure bootnodes in your `.env` file:

```bash
BOOTNODES=enode://[TODO: Add mainnet bootnode address]
```

<!-- TODO: Add actual bootnode enode addresses for mainnet and testnet -->

### Static Peers

For guaranteed connectivity to specific nodes:

```bash
STATIC_PEERS=enode://peer1@ip:port,enode://peer2@ip:port
```

---

## Security Considerations

### Production Deployment

1. **Firewall Configuration**
   - Expose only necessary ports (RPC/WS)
   - Restrict RPC access to trusted IPs
   - Use VPN for administrative access

2. **Secrets Management**
   - Change default PostgreSQL credentials
   - Generate secure `SECRET_KEY_BASE` for explorer
   - Store faucet private keys securely

3. **Rate Limiting**
   - Gateway includes nginx rate limiting (100 req/s)
   - Adjust limits in `services/gateway/nginx.conf`

4. **SSL/TLS**
   - Use reverse proxy (Cloudflare, nginx) for HTTPS
   - Never expose RPC directly to internet without encryption

---

## Hardware Requirements

### Minimum Requirements

- **CPU**: 4 cores
- **RAM**: 8GB
- **Storage**: 200GB SSD
- **Network**: 10 Mbps

### Recommended Requirements

- **CPU**: 8+ cores
- **RAM**: 16GB+
- **Storage**: 500GB+ NVMe SSD
- **Network**: 100 Mbps

---

## Troubleshooting

### Node Not Syncing

```bash
# Check peer connections
./ops.sh mainnet exec node geth attach --exec "admin.peers" /root/.ethereum/geth.ipc

# Verify bootnode connectivity
# Ensure BOOTNODES env variable is set correctly
```

### Explorer Not Loading

```bash
# Check database connection
./ops.sh mainnet logs db

# Verify RPC connectivity
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### High Disk Usage

```bash
# Check disk usage
du -sh data/mainnet/*

# Clean up logs
./ops.sh mainnet logs --tail 0
docker system prune -f
```

---

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request with clear description

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Support

- **Documentation**: [docs/](docs/)
- **Issues**: GitHub Issues
- **Community**: [Discord](#) <!-- TODO: Add Discord link -->
- **Email**: support@siberium.net <!-- TODO: Add actual support email -->

---

## Acknowledgments

Built with:
- [Go Ethereum (Geth)](https://geth.ethereum.org/) - Ethereum client
- [Blockscout](https://blockscout.com/) - Blockchain explorer
- [Docker](https://docker.com/) - Containerization platform
- [Nginx](https://nginx.org/) - Web server and reverse proxy

---

<p align="center">
  Made with infrastructure-grade standards for the Siberium Network
</p>

