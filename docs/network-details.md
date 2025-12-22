# Network Details

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Siberium Logo" width="150"/>
</p>

## Overview

Siberium operates two separate networks: Mainnet for production applications and Testnet for development and testing. Both networks are fully EVM-compatible and share the same technical specifications with different chain identifiers.

---

## Mainnet

Siberium Mainnet is the production network where real-value transactions occur.

### Network Specifications

| Parameter | Value |
|-----------|-------|
| **Network Name** | Siberium Mainnet |
| **Chain ID** | 111111 |
| **Currency Symbol** | SIBR |
| **Currency Decimals** | 18 |
| **RPC Endpoint** | https://rpc.siberium.net <!-- TODO: Replace with actual mainnet RPC URL --> |
| **WebSocket Endpoint** | wss://ws.siberium.net <!-- TODO: Replace with actual mainnet WSS URL --> |
| **Block Explorer** | https://explorer.siberium.net <!-- TODO: Replace with actual mainnet explorer URL --> |
| **Block Time** | 3 seconds |
| **Gas Limit** | 4,700,000 |
| **Consensus** | Proof of Authority |

### Network Configuration

**For MetaMask and Web3 Wallets:**

```javascript
{
  chainId: '0x1B207',  // 111111 in hex
  chainName: 'Siberium Mainnet',
  nativeCurrency: {
    name: 'SIBR',
    symbol: 'SIBR',
    decimals: 18
  },
  rpcUrls: ['https://rpc.siberium.net'],
  blockExplorerUrls: ['https://explorer.siberium.net']
}
```

**For Geth Client:**

```bash
geth --networkid 111111 \
     --bootnodes "enode://[TODO: Add mainnet bootnode]" \
     --datadir ./data/mainnet \
     init networks/mainnet/genesis.json
```

### Genesis Configuration

The mainnet genesis file is located at [`networks/mainnet/genesis.json`](../networks/mainnet/genesis.json).

Key parameters:
- **Chain ID**: 111111
- **Consensus**: Clique (PoA)
- **Block Period**: 3 seconds
- **Epoch Length**: 30,000 blocks

---

## Testnet

Siberium Testnet is a testing environment where developers can deploy and test smart contracts without using real value.

### Network Specifications

| Parameter | Value |
|-----------|-------|
| **Network Name** | Siberium Testnet |
| **Chain ID** | 111000 |
| **Currency Symbol** | tSIBR |
| **Currency Decimals** | 18 |
| **RPC Endpoint** | https://rpc.test.siberium.net <!-- TODO: Replace with actual testnet RPC URL --> |
| **WebSocket Endpoint** | wss://ws.test.siberium.net <!-- TODO: Replace with actual testnet WSS URL --> |
| **Block Explorer** | https://explorer.test.siberium.net <!-- TODO: Replace with actual testnet explorer URL --> |
| **Faucet** | https://faucet.test.siberium.net <!-- TODO: Replace with actual faucet URL --> |
| **Block Time** | 3 seconds |
| **Gas Limit** | 4,700,000 |
| **Consensus** | Proof of Authority |

### Network Configuration

**For MetaMask and Web3 Wallets:**

```javascript
{
  chainId: '0x1B178',  // 111000 in hex
  chainName: 'Siberium Testnet',
  nativeCurrency: {
    name: 'Test SIBR',
    symbol: 'tSIBR',
    decimals: 18
  },
  rpcUrls: ['https://rpc.test.siberium.net'],
  blockExplorerUrls: ['https://explorer.test.siberium.net']
}
```

**For Geth Client:**

```bash
geth --networkid 111000 \
     --bootnodes "enode://[TODO: Add testnet bootnode]" \
     --datadir ./data/testnet \
     init networks/testnet/genesis.json
```

### Genesis Configuration

The testnet genesis file is located at [`networks/testnet/genesis.json`](../networks/testnet/genesis.json).

Key parameters:
- **Chain ID**: 111000
- **Consensus**: Clique (PoA)
- **Block Period**: 3 seconds
- **Epoch Length**: 30,000 blocks

---

## EVM Compatibility

Siberium is fully compatible with the Ethereum Virtual Machine (EVM), supporting:

- **Solidity Smart Contracts** - All versions up to 0.8.x
- **EVM Opcodes** - Complete instruction set support
- **JSON-RPC API** - Standard Ethereum JSON-RPC methods
- **Web3 Libraries** - web3.js, ethers.js, web3.py
- **Development Tools** - Hardhat, Truffle, Remix, Foundry

### Supported Hard Forks

Both networks include support for:
- Homestead
- Byzantium
- Constantinople
- Petersburg
- Istanbul
- Berlin
- London

---

## API Endpoints

### JSON-RPC Methods

Siberium nodes support all standard Ethereum JSON-RPC methods:

**Network Information:**
- `net_version` - Returns the network ID
- `eth_chainId` - Returns the chain ID
- `net_peerCount` - Returns number of connected peers

**Block Information:**
- `eth_blockNumber` - Returns the current block number
- `eth_getBlockByNumber` - Returns block by number
- `eth_getBlockByHash` - Returns block by hash

**Transaction Methods:**
- `eth_sendRawTransaction` - Submits a signed transaction
- `eth_getTransactionReceipt` - Returns transaction receipt
- `eth_estimateGas` - Estimates gas for transaction

**Account Methods:**
- `eth_getBalance` - Returns account balance
- `eth_getTransactionCount` - Returns nonce
- `eth_call` - Executes a call without creating transaction

**Contract Interaction:**
- `eth_getLogs` - Returns logs matching filter
- `eth_call` - Calls contract method
- `eth_getCode` - Returns contract bytecode

### Example API Calls

**Get Current Block Number:**

```bash
curl -X POST https://rpc.siberium.net \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "eth_blockNumber",
    "params": [],
    "id": 1
  }'
```

**Get Account Balance:**

```bash
curl -X POST https://rpc.siberium.net \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "eth_getBalance",
    "params": ["0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb", "latest"],
    "id": 1
  }'
```

---

## Network Comparison

| Feature | Mainnet | Testnet |
|---------|---------|---------|
| **Purpose** | Production | Development/Testing |
| **Chain ID** | 111111 | 111000 |
| **Currency** | SIBR (real value) | tSIBR (no value) |
| **Faucet** | No | Yes |
| **Stability** | High | May reset occasionally |
| **Use Case** | dApps, DeFi, NFTs | Contract testing, development |

---

## Connection Examples

### Web3.js

```javascript
const Web3 = require('web3');

// Mainnet
const web3Mainnet = new Web3('https://rpc.siberium.net');

// Testnet
const web3Testnet = new Web3('https://rpc.test.siberium.net');

// Get chain ID
const chainId = await web3Mainnet.eth.getChainId();
console.log('Chain ID:', chainId); // 111111
```

### Ethers.js

```javascript
const { ethers } = require('ethers');

// Mainnet
const providerMainnet = new ethers.JsonRpcProvider('https://rpc.siberium.net');

// Testnet
const providerTestnet = new ethers.JsonRpcProvider('https://rpc.test.siberium.net');

// Get network info
const network = await providerMainnet.getNetwork();
console.log('Network:', network.name, 'Chain ID:', network.chainId);
```

### Python (Web3.py)

```python
from web3 import Web3

# Mainnet
w3_mainnet = Web3(Web3.HTTPProvider('https://rpc.siberium.net'))

# Testnet
w3_testnet = Web3(Web3.HTTPProvider('https://rpc.test.siberium.net'))

# Check connection
print(f"Connected: {w3_mainnet.is_connected()}")
print(f"Chain ID: {w3_mainnet.eth.chain_id}")
```

---

## Rate Limits

When using public RPC endpoints, please be aware of rate limits:

<!-- TODO: Add actual rate limit specifications -->

- **Default**: 100 requests per second per IP
- **Burst**: Up to 200 requests allowed in burst
- **WebSocket**: Max 10 concurrent connections per IP

For higher limits or dedicated infrastructure, consider running your own node using this infrastructure kit.

---

## Next Steps

- [Connect MetaMask](metamask-guide.md) - Add Siberium networks to MetaMask
- [Run a Node](node-setup.md) - Deploy your own Siberium node
- [Get Testnet Tokens](resources.md#faucet) - Request tSIBR from the faucet

---

[Back to README](../README.md)




