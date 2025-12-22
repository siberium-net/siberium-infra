# Resources

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Siberium Logo" width="150"/>
</p>

## Overview

This page contains links to essential Siberium network resources, tools, and community channels.

---

## Network Resources

### Mainnet

| Resource | URL | Description |
|----------|-----|-------------|
| **RPC Endpoint** | https://rpc.siberium.net | JSON-RPC API endpoint |
| **WebSocket** | wss://ws.siberium.net | WebSocket endpoint |
| **Block Explorer** | https://explorer.siberium.net | Blockscout explorer |
| **Network Status** | https://status.siberium.net | Network health dashboard |

<!-- TODO: Replace all mainnet URLs with actual production endpoints -->

### Testnet

| Resource | URL | Description |
|----------|-----|-------------|
| **RPC Endpoint** | https://rpc.test.siberium.net | JSON-RPC API endpoint |
| **WebSocket** | wss://ws.test.siberium.net | WebSocket endpoint |
| **Block Explorer** | https://explorer.test.siberium.net | Blockscout explorer |
| **Faucet** | https://faucet.test.siberium.net | Testnet token faucet |

<!-- TODO: Replace all testnet URLs with actual endpoints -->

---

## Faucet

### Testnet Faucet

Get free tSIBR tokens for testing on Siberium Testnet.

**URL:** https://faucet.test.siberium.net
<!-- TODO: Add actual faucet URL -->

**How to use:**
1. Connect your MetaMask wallet
2. Ensure you're on Siberium Testnet (Chain ID: 111000)
3. Enter your wallet address
4. Click "Request Tokens"
5. Receive 1 tSIBR per request

**Rate Limits:**
- 1 request per address per 24 hours
- Maximum 1 tSIBR per request

**Troubleshooting:**
- Ensure wallet is connected to testnet
- Check if you've already requested tokens in the last 24 hours
- Verify the faucet contract has sufficient balance

---

## Bridge

### Cross-Chain Bridge

Transfer assets between Siberium and other networks.

**Bridge URL:** https://bridge.siberium.net
<!-- TODO: Add actual bridge URL when available -->

**Supported Networks:**
- Ethereum Mainnet
- Binance Smart Chain
- Polygon
- Arbitrum
<!-- TODO: Update with actual supported networks -->

**Supported Assets:**
- SIBR (native token)
- USDT
- USDC
- ETH
<!-- TODO: Update with actual supported assets -->

**Bridge Fees:**
- Network gas fees apply
- Bridge fee: 0.1% per transaction
<!-- TODO: Update with actual bridge fees -->

---

## Block Explorers

### Official Explorers

**Mainnet Explorer:**
- URL: https://explorer.siberium.net
- Features: Transactions, blocks, contracts, tokens, analytics

**Testnet Explorer:**
- URL: https://explorer.test.siberium.net
- Features: Full development and testing support

<!-- TODO: Add actual explorer URLs -->

### Third-Party Explorers

Additional block explorers may be available through third-party providers.

<!-- TODO: Add third-party explorer links when available -->

---

## Developer Tools

### Smart Contract Development

**Remix IDE:**
- Online IDE for Solidity development
- URL: https://remix.ethereum.org
- Configure with Siberium RPC

**Hardhat:**
```bash
npm install --save-dev hardhat
npx hardhat init
```

Configure `hardhat.config.js`:
```javascript
module.exports = {
  networks: {
    siberium: {
      url: "https://rpc.siberium.net",
      chainId: 111111,
      accounts: [process.env.PRIVATE_KEY]
    }
  }
};
```

**Truffle:**
```bash
npm install -g truffle
truffle init
```

Configure `truffle-config.js`:
```javascript
module.exports = {
  networks: {
    siberium: {
      provider: () => new HDWalletProvider(
        process.env.MNEMONIC,
        'https://rpc.siberium.net'
      ),
      network_id: 111111,
      gas: 4700000
    }
  }
};
```

**Foundry:**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
forge init my-project
```

---

## Web3 Libraries

### JavaScript/TypeScript

**Web3.js:**
```bash
npm install web3
```

```javascript
const Web3 = require('web3');
const web3 = new Web3('https://rpc.siberium.net');
```

**Ethers.js:**
```bash
npm install ethers
```

```javascript
const { ethers } = require('ethers');
const provider = new ethers.JsonRpcProvider('https://rpc.siberium.net');
```

### Python

**Web3.py:**
```bash
pip install web3
```

```python
from web3 import Web3
w3 = Web3(Web3.HTTPProvider('https://rpc.siberium.net'))
```

### Go

**Go-Ethereum:**
```bash
go get github.com/ethereum/go-ethereum
```

```go
import "github.com/ethereum/go-ethereum/ethclient"

client, err := ethclient.Dial("https://rpc.siberium.net")
```

---

## APIs and SDKs

### JSON-RPC API

Full Ethereum-compatible JSON-RPC API available at:
- Mainnet: https://rpc.siberium.net
- Testnet: https://rpc.test.siberium.net

**Documentation:** [Ethereum JSON-RPC Specification](https://ethereum.org/en/developers/docs/apis/json-rpc/)

### GraphQL API

Blockscout provides a GraphQL API for advanced queries:
- Mainnet: https://explorer.siberium.net/graphiql
- Testnet: https://explorer.test.siberium.net/graphiql

<!-- TODO: Verify GraphQL endpoint paths -->

---

## Infrastructure

### Node Deployment

**This Repository:**
- GitHub: https://github.com/siberium-net/siberium-infra
- Documentation: [Node Setup Guide](node-setup.md)

<!-- TODO: Add actual GitHub repository URL -->

**Docker Images:**
- Mainnet: `ghcr.io/siberium-net/siberium-mainnet:latest`
- Testnet: `ghcr.io/siberium-net/siberium-testnet:latest`

<!-- TODO: Add actual Docker registry URLs -->

### Monitoring Tools

**Prometheus Metrics:**
```yaml
scrape_configs:
  - job_name: 'siberium-node'
    static_configs:
      - targets: ['localhost:6060']
```

**Grafana Dashboards:**
- Ethereum Node Dashboard
- Blockscout Dashboard
<!-- TODO: Add links to Grafana dashboard JSONs -->

---

## Community

### Official Channels

**Website:**
- URL: https://siberium.net
<!-- TODO: Add actual website URL -->

**Documentation:**
- URL: https://docs.siberium.net
<!-- TODO: Add actual docs URL -->

**GitHub:**
- Organization: https://github.com/siberium-net
<!-- TODO: Add actual GitHub organization URL -->

### Social Media

**Twitter:**
- Handle: @SiberiumNet
- URL: https://twitter.com/SiberiumNet
<!-- TODO: Add actual Twitter handle and URL -->

**Discord:**
- Server: Siberium Community
- URL: https://discord.gg/siberium
<!-- TODO: Add actual Discord invite link -->

**Telegram:**
- Channel: @SiberiumOfficial
- URL: https://t.me/SiberiumOfficial
<!-- TODO: Add actual Telegram channel -->

**Medium:**
- Blog: https://medium.com/@siberium
<!-- TODO: Add actual Medium blog URL -->

---

## Support

### Technical Support

**GitHub Issues:**
- Report bugs and issues
- URL: https://github.com/siberium-net/siberium-infra/issues
<!-- TODO: Add actual issues URL -->

**Developer Forum:**
- Ask questions and discuss
- URL: https://forum.siberium.net
<!-- TODO: Add actual forum URL if available -->

**Email Support:**
- Technical: support@siberium.net
- Security: security@siberium.net
- Business: business@siberium.net
<!-- TODO: Add actual support email addresses -->

---

## Grants and Programs

### Developer Grants

Support for developers building on Siberium.

**Grant Program:**
- URL: https://grants.siberium.net
- Funding: Up to $50,000 per project
- Focus: DeFi, Gaming, Infrastructure, Tooling
<!-- TODO: Add actual grants program URL and details -->

### Bug Bounty Program

Responsible disclosure program for security researchers.

**Bounty Program:**
- URL: https://bounty.siberium.net
- Rewards: $100 - $100,000 depending on severity
- Scope: Node software, smart contracts, infrastructure
<!-- TODO: Add actual bug bounty URL and details -->

---

## Learning Resources

### Documentation

- [Network Details](network-details.md) - Complete network specifications
- [MetaMask Guide](metamask-guide.md) - Connect wallets to Siberium
- [Node Setup](node-setup.md) - Deploy and operate nodes

### Tutorials

**Coming Soon:**
- Deploy Your First Smart Contract
- Build a DApp on Siberium
- Set Up a Validator Node
- Create an NFT Collection
<!-- TODO: Add tutorial links when available -->

### Example Projects

**GitHub Repositories:**
- Siberium DApp Template
- Token Contract Examples
- NFT Marketplace Template
<!-- TODO: Add example repository links -->

---

## Network Statistics

### Live Stats

**Network Dashboard:**
- URL: https://stats.siberium.net
<!-- TODO: Add actual network stats dashboard URL -->

**Key Metrics:**
- Current Block Height
- Average Block Time
- Total Transactions
- Active Addresses
- Network Hash Rate
- Gas Price Statistics

---

## Media Kit

### Brand Assets

**Logo Downloads:**
- SVG: https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg
- PNG (High-res): [Download](#)
- Brand Guidelines: [Download](#)
<!-- TODO: Add actual media kit download links -->

**Brand Colors:**
- Primary: `#c5de1d` (Lime Green)
- Secondary: `#1edaff` (Cyan)
- Gradient: `linear-gradient(135deg, #c5de1d 0%, #1edaff 100%)`

---

## Partners and Integrations

### Wallet Support

- MetaMask
- Trust Wallet
- Coinbase Wallet
- WalletConnect
<!-- TODO: Update with confirmed wallet integrations -->

### DEX Integrations

- Uniswap V3
- SushiSwap
- PancakeSwap
<!-- TODO: Update with actual DEX integrations -->

### Infrastructure Partners

- Alchemy
- Infura
- QuickNode
<!-- TODO: Update with actual infrastructure partners -->

---

## Compliance and Legal

### Terms of Service

- URL: https://siberium.net/terms
<!-- TODO: Add actual ToS URL -->

### Privacy Policy

- URL: https://siberium.net/privacy
<!-- TODO: Add actual privacy policy URL -->

### Regulatory Compliance

Siberium operates in compliance with applicable regulations. For specific inquiries, contact: legal@siberium.net
<!-- TODO: Add actual legal contact -->

---

## Changelog

### Latest Updates

**2024-12-07:**
- Documentation repository published
- Mainnet genesis configuration released
- Infrastructure deployment tools available

<!-- TODO: Keep changelog updated with actual releases -->

---

## Quick Links

| Category | Link |
|----------|------|
| Add Mainnet to MetaMask | [Guide](metamask-guide.md#quick-add-automatic) |
| Add Testnet to MetaMask | [Guide](metamask-guide.md#add-testnet-to-metamask) |
| Get Testnet Tokens | [Faucet](#faucet) |
| Deploy a Node | [Setup Guide](node-setup.md) |
| Network Specifications | [Details](network-details.md) |
| GitHub Repository | https://github.com/siberium-net |

---

[Back to README](../README.md)




