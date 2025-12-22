# MetaMask Integration Guide

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Siberium Logo" width="150"/>
</p>

## Overview

This guide will help you connect MetaMask wallet to Siberium networks. You can add Siberium networks using either an automatic button or manual configuration.

---

## Quick Add (Automatic)

The easiest way to add Siberium networks to MetaMask is using the "Add to MetaMask" button.

### Add Mainnet to MetaMask

Click the button below to automatically add Siberium Mainnet:

<div id="add-mainnet-status"></div>

**Add to MetaMask Button (Mainnet):**

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    .add-network-btn {
      background: linear-gradient(135deg, #c5de1d 0%, #1edaff 100%);
      color: #000;
      border: none;
      padding: 12px 24px;
      font-size: 16px;
      font-weight: bold;
      border-radius: 8px;
      cursor: pointer;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .add-network-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(30, 218, 255, 0.4);
    }
    .add-network-btn:active {
      transform: translateY(0);
    }
    .status-message {
      margin-top: 10px;
      padding: 10px;
      border-radius: 4px;
      display: none;
    }
    .status-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }
    .status-error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
  </style>
</head>
<body>
  <button class="add-network-btn" onclick="addSiberiumMainnet()">
    [ADD] Add Siberium Mainnet to MetaMask
  </button>
  <div id="status-mainnet" class="status-message"></div>

  <script>
    async function addSiberiumMainnet() {
      const statusDiv = document.getElementById('status-mainnet');
      
      if (typeof window.ethereum === 'undefined') {
        showStatus(statusDiv, 'MetaMask is not installed. Please install MetaMask extension.', 'error');
        return;
      }

      const networkParams = {
        chainId: '0x1B207', // 111111 in hex
        chainName: 'Siberium Mainnet',
        nativeCurrency: {
          name: 'SIBR',
          symbol: 'SIBR',
          decimals: 18
        },
        rpcUrls: ['https://rpc.siberium.net'], // TODO: Replace with actual RPC URL
        blockExplorerUrls: ['https://explorer.siberium.net'] // TODO: Replace with actual explorer URL
      };

      try {
        await window.ethereum.request({
          method: 'wallet_addEthereumChain',
          params: [networkParams]
        });
        showStatus(statusDiv, 'Siberium Mainnet added successfully!', 'success');
      } catch (error) {
        console.error('Error adding network:', error);
        showStatus(statusDiv, `Error: ${error.message}`, 'error');
      }
    }

    function showStatus(element, message, type) {
      element.textContent = message;
      element.className = `status-message status-${type}`;
      element.style.display = 'block';
      setTimeout(() => {
        element.style.display = 'none';
      }, 5000);
    }
  </script>
</body>
</html>
```

### Add Testnet to MetaMask

Click the button below to automatically add Siberium Testnet:

**Add to MetaMask Button (Testnet):**

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    .add-network-btn {
      background: linear-gradient(135deg, #c5de1d 0%, #1edaff 100%);
      color: #000;
      border: none;
      padding: 12px 24px;
      font-size: 16px;
      font-weight: bold;
      border-radius: 8px;
      cursor: pointer;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .add-network-btn:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(30, 218, 255, 0.4);
    }
    .add-network-btn:active {
      transform: translateY(0);
    }
    .status-message {
      margin-top: 10px;
      padding: 10px;
      border-radius: 4px;
      display: none;
    }
    .status-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }
    .status-error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
  </style>
</head>
<body>
  <button class="add-network-btn" onclick="addSiberiumTestnet()">
    [ADD] Add Siberium Testnet to MetaMask
  </button>
  <div id="status-testnet" class="status-message"></div>

  <script>
    async function addSiberiumTestnet() {
      const statusDiv = document.getElementById('status-testnet');
      
      if (typeof window.ethereum === 'undefined') {
        showStatus(statusDiv, 'MetaMask is not installed. Please install MetaMask extension.', 'error');
        return;
      }

      const networkParams = {
        chainId: '0x1B178', // 111000 in hex
        chainName: 'Siberium Testnet',
        nativeCurrency: {
          name: 'Test SIBR',
          symbol: 'tSIBR',
          decimals: 18
        },
        rpcUrls: ['https://rpc.test.siberium.net'], // TODO: Replace with actual RPC URL
        blockExplorerUrls: ['https://explorer.test.siberium.net'] // TODO: Replace with actual explorer URL
      };

      try {
        await window.ethereum.request({
          method: 'wallet_addEthereumChain',
          params: [networkParams]
        });
        showStatus(statusDiv, 'Siberium Testnet added successfully!', 'success');
      } catch (error) {
        console.error('Error adding network:', error);
        showStatus(statusDiv, `Error: ${error.message}`, 'error');
      }
    }

    function showStatus(element, message, type) {
      element.textContent = message;
      element.className = `status-message status-${type}`;
      element.style.display = 'block';
      setTimeout(() => {
        element.style.display = 'none';
      }, 5000);
    }
  </script>
</body>
</html>
```

---

## Manual Configuration

If you prefer to add the network manually or the automatic method doesn't work, follow these step-by-step instructions.

### Step 1: Open MetaMask

Click on the MetaMask extension icon in your browser.

<!-- [PLACEHOLDER: Screenshot of MetaMask icon in browser toolbar] -->

### Step 2: Access Network Settings

1. Click on the network dropdown at the top of MetaMask
2. Click "Add Network" or "Custom RPC"

<!-- [PLACEHOLDER: Screenshot of MetaMask network dropdown menu] -->

### Step 3: Enter Network Details

#### For Mainnet:

Fill in the following information:

| Field | Value |
|-------|-------|
| **Network Name** | Siberium Mainnet |
| **New RPC URL** | https://rpc.siberium.net <!-- TODO: Replace with actual RPC --> |
| **Chain ID** | 111111 |
| **Currency Symbol** | SIBR |
| **Block Explorer URL** | https://explorer.siberium.net <!-- TODO: Replace with actual explorer --> |

<!-- [PLACEHOLDER: Screenshot of MetaMask add network form filled with mainnet details] -->

#### For Testnet:

Fill in the following information:

| Field | Value |
|-------|-------|
| **Network Name** | Siberium Testnet |
| **New RPC URL** | https://rpc.test.siberium.net <!-- TODO: Replace with actual RPC --> |
| **Chain ID** | 111000 |
| **Currency Symbol** | tSIBR |
| **Block Explorer URL** | https://explorer.test.siberium.net <!-- TODO: Replace with actual explorer --> |

<!-- [PLACEHOLDER: Screenshot of MetaMask add network form filled with testnet details] -->

### Step 4: Save and Connect

1. Click "Save" or "Add"
2. MetaMask will automatically switch to the new network
3. You should see the network name at the top of MetaMask

<!-- [PLACEHOLDER: Screenshot of MetaMask successfully connected to Siberium network] -->

---

## Switching Networks

To switch between networks after adding them:

1. Click the network dropdown at the top of MetaMask
2. Select "Siberium Mainnet" or "Siberium Testnet"

<!-- [PLACEHOLDER: Screenshot showing network selection in MetaMask] -->

---

## Verify Connection

After adding the network, verify the connection is working:

### Method 1: Check Chain ID

Open MetaMask console in browser developer tools:

```javascript
// Open browser console (F12)
await window.ethereum.request({ method: 'eth_chainId' })
// Should return: "0x1B207" (Mainnet) or "0x1B178" (Testnet)
```

### Method 2: Check Balance

1. Go to the block explorer
2. Copy your wallet address from MetaMask
3. Search for your address in the explorer

### Method 3: Send Test Transaction

On testnet, you can verify by:
1. Get test tokens from the [faucet](resources.md#faucet)
2. Send a small amount to another address
3. Check the transaction in the explorer

---

## Using Web3 Libraries

### Web3.js Integration

```javascript
const Web3 = require('web3');

// Mainnet
const web3 = new Web3('https://rpc.siberium.net');

// Or use MetaMask provider
if (window.ethereum) {
  const web3 = new Web3(window.ethereum);
  await window.ethereum.request({ method: 'eth_requestAccounts' });
  
  const chainId = await web3.eth.getChainId();
  console.log('Connected to chain:', chainId); // 111111 or 111000
}
```

### Ethers.js Integration

```javascript
const { ethers } = require('ethers');

// Connect to MetaMask
const provider = new ethers.BrowserProvider(window.ethereum);
await provider.send("eth_requestAccounts", []);

const signer = await provider.getSigner();
const address = await signer.getAddress();
console.log('Connected address:', address);

// Get network info
const network = await provider.getNetwork();
console.log('Network:', network.name, 'Chain ID:', network.chainId);
```

---

## Troubleshooting

### MetaMask Not Detecting Network

**Problem:** Network added but not appearing in MetaMask.

**Solution:**
1. Restart browser
2. Re-add the network
3. Check Chain ID is correct (111111 for Mainnet, 111000 for Testnet)

### Cannot Connect to RPC

**Problem:** "Error connecting to RPC" message.

**Solution:**
1. Verify RPC URL is correct
2. Check internet connection
3. Try alternative RPC endpoint (if available)
4. Wait a moment and try again

### Wrong Network Selected

**Problem:** Transactions failing because of wrong network.

**Solution:**
1. Check MetaMask network dropdown
2. Switch to correct network (Mainnet or Testnet)
3. Verify Chain ID in developer console

### Nonce Too Low Error

**Problem:** Transaction fails with "nonce too low" error.

**Solution:**
1. Go to MetaMask Settings → Advanced
2. Click "Reset Account"
3. This will clear transaction history without affecting your funds

### Pending Transactions

**Problem:** Transaction stuck in pending state.

**Solution:**
1. Wait 5-10 minutes (network might be congested)
2. Check gas price is sufficient
3. Try speeding up transaction in MetaMask
4. As last resort, reset account (see above)

---

## Security Best Practices

### Keep Your Seed Phrase Safe

- **Never share** your seed phrase with anyone
- **Never enter** seed phrase on suspicious websites
- **Store securely** offline in multiple locations
- MetaMask will **never** ask for your seed phrase

### Verify Transactions

Before confirming any transaction:
1. Check the recipient address carefully
2. Verify the amount being sent
3. Ensure correct network is selected
4. Review gas fees

### Phishing Protection

- Always verify you're on the correct website
- Use bookmarks for frequently visited sites
- Be suspicious of urgent requests
- Double-check contract addresses before interacting

### Use Hardware Wallets

For large amounts, consider using a hardware wallet:
- Ledger
- Trezor

Connect them to MetaMask for enhanced security.

---

## Advanced Configuration

### Custom RPC Endpoints

If you're running your own node:

```
http://localhost:8545
```

Or using a remote node:

```
http://your-node-ip:8545
```

### Multiple RPC Endpoints

You can add multiple RPC URLs for redundancy:

1. Add network with first RPC URL
2. If connection fails, edit network
3. Change to backup RPC URL

---

## Mobile MetaMask

The same networks can be added to MetaMask mobile app:

### iOS/Android

1. Open MetaMask app
2. Tap hamburger menu (☰)
3. Tap "Settings"
4. Tap "Networks"
5. Tap "Add Network"
6. Enter network details (same as desktop)
7. Tap "Add"

<!-- [PLACEHOLDER: Screenshots of mobile MetaMask network configuration] -->

---

## Next Steps

- [Get Testnet Tokens](resources.md#faucet) - Request tSIBR from faucet
- [Deploy Smart Contracts](node-setup.md) - Start building on Siberium
- [View Network Details](network-details.md) - Full network specifications

---

[Back to README](../README.md)




