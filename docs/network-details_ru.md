# Детали сети

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Логотип Siberium" width="150"/>
</p>

## Обзор

Siberium управляет двумя отдельными сетями: Mainnet для продакшн приложений и Testnet для разработки и тестирования. Обе сети полностью EVM-совместимы и имеют одинаковые технические характеристики с разными идентификаторами цепи.

---

## Mainnet

Siberium Mainnet — это продакшн сеть, где происходят транзакции с реальной стоимостью.

### Спецификация сети

| Параметр | Значение |
|----------|----------|
| **Название сети** | Siberium Mainnet |
| **Chain ID** | 111111 |
| **Символ валюты** | SIBR |
| **Decimals валюты** | 18 |
| **RPC эндпоинт** | https://rpc.siberium.net <!-- TODO: Заменить на актуальный mainnet RPC URL --> |
| **WebSocket эндпоинт** | wss://ws.siberium.net <!-- TODO: Заменить на актуальный mainnet WSS URL --> |
| **Обозреватель блоков** | https://explorer.siberium.net <!-- TODO: Заменить на актуальный mainnet explorer URL --> |
| **Время блока** | 3 секунды |
| **Лимит газа** | 4,700,000 |
| **Консенсус** | Proof of Authority |

### Конфигурация сети

**Для MetaMask и Web3 кошельков:**

```javascript
{
  chainId: '0x1B207',  // 111111 в hex
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

**Для Geth клиента:**

```bash
geth --networkid 111111 \
     --bootnodes "enode://[TODO: Добавить mainnet bootnode]" \
     --datadir ./data/mainnet \
     init networks/mainnet/genesis.json
```

### Конфигурация Genesis

Файл genesis для mainnet находится в [`networks/mainnet/genesis.json`](../networks/mainnet/genesis.json).

Ключевые параметры:
- **Chain ID**: 111111
- **Консенсус**: Clique (PoA)
- **Период блока**: 3 секунды
- **Длина эпохи**: 30,000 блоков

---

## Testnet

Siberium Testnet — это тестовая среда, где разработчики могут развертывать и тестировать смарт-контракты без использования реальной стоимости.

### Спецификация сети

| Параметр | Значение |
|----------|----------|
| **Название сети** | Siberium Testnet |
| **Chain ID** | 111000 |
| **Символ валюты** | tSIBR |
| **Decimals валюты** | 18 |
| **RPC эндпоинт** | https://rpc.test.siberium.net <!-- TODO: Заменить на актуальный testnet RPC URL --> |
| **WebSocket эндпоинт** | wss://ws.test.siberium.net <!-- TODO: Заменить на актуальный testnet WSS URL --> |
| **Обозреватель блоков** | https://explorer.test.siberium.net <!-- TODO: Заменить на актуальный testnet explorer URL --> |
| **Кран токенов** | https://faucet.test.siberium.net <!-- TODO: Заменить на актуальный faucet URL --> |
| **Время блока** | 3 секунды |
| **Лимит газа** | 4,700,000 |
| **Консенсус** | Proof of Authority |

### Конфигурация сети

**Для MetaMask и Web3 кошельков:**

```javascript
{
  chainId: '0x1B178',  // 111000 в hex
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

**Для Geth клиента:**

```bash
geth --networkid 111000 \
     --bootnodes "enode://[TODO: Добавить testnet bootnode]" \
     --datadir ./data/testnet \
     init networks/testnet/genesis.json
```

### Конфигурация Genesis

Файл genesis для testnet находится в [`networks/testnet/genesis.json`](../networks/testnet/genesis.json).

Ключевые параметры:
- **Chain ID**: 111000
- **Консенсус**: Clique (PoA)
- **Период блока**: 3 секунды
- **Длина эпохи**: 30,000 блоков

---

## EVM-совместимость

Siberium полностью совместим с виртуальной машиной Ethereum (EVM), поддерживая:

- **Смарт-контракты Solidity** - Все версии до 0.8.x
- **EVM опкоды** - Полная поддержка набора инструкций
- **JSON-RPC API** - Стандартные методы Ethereum JSON-RPC
- **Web3 библиотеки** - web3.js, ethers.js, web3.py
- **Инструменты разработки** - Hardhat, Truffle, Remix, Foundry

### Поддерживаемые хардфорки

Обе сети включают поддержку:
- Homestead
- Byzantium
- Constantinople
- Petersburg
- Istanbul
- Berlin
- London

---

## API эндпоинты

### JSON-RPC методы

Ноды Siberium поддерживают все стандартные методы Ethereum JSON-RPC:

**Информация о сети:**
- `net_version` - Возвращает ID сети
- `eth_chainId` - Возвращает chain ID
- `net_peerCount` - Возвращает количество подключенных пиров

**Информация о блоках:**
- `eth_blockNumber` - Возвращает текущий номер блока
- `eth_getBlockByNumber` - Возвращает блок по номеру
- `eth_getBlockByHash` - Возвращает блок по хешу

**Методы транзакций:**
- `eth_sendRawTransaction` - Отправляет подписанную транзакцию
- `eth_getTransactionReceipt` - Возвращает квитанцию транзакции
- `eth_estimateGas` - Оценивает газ для транзакции

**Методы аккаунтов:**
- `eth_getBalance` - Возвращает баланс аккаунта
- `eth_getTransactionCount` - Возвращает nonce
- `eth_call` - Выполняет вызов без создания транзакции

**Взаимодействие с контрактами:**
- `eth_getLogs` - Возвращает логи, соответствующие фильтру
- `eth_call` - Вызывает метод контракта
- `eth_getCode` - Возвращает байткод контракта

### Примеры API вызовов

**Получить текущий номер блока:**

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

**Получить баланс аккаунта:**

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

## Сравнение сетей

| Параметр | Mainnet | Testnet |
|----------|---------|---------|
| **Назначение** | Продакшн | Разработка/Тестирование |
| **Chain ID** | 111111 | 111000 |
| **Валюта** | SIBR (реальная стоимость) | tSIBR (без стоимости) |
| **Кран** | Нет | Да |
| **Стабильность** | Высокая | Может сбрасываться периодически |
| **Случай использования** | dApps, DeFi, NFTs | Тестирование контрактов, разработка |

---

## Примеры подключения

### Web3.js

```javascript
const Web3 = require('web3');

// Mainnet
const web3Mainnet = new Web3('https://rpc.siberium.net');

// Testnet
const web3Testnet = new Web3('https://rpc.test.siberium.net');

// Получить chain ID
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

// Получить информацию о сети
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

# Проверить подключение
print(f"Connected: {w3_mainnet.is_connected()}")
print(f"Chain ID: {w3_mainnet.eth.chain_id}")
```

---

## Ограничения запросов

При использовании публичных RPC эндпоинтов, пожалуйста, учитывайте лимиты запросов:

<!-- TODO: Добавить актуальные спецификации rate limit -->

- **По умолчанию**: 100 запросов в секунду на IP
- **Burst**: До 200 запросов в режиме burst
- **WebSocket**: Максимум 10 одновременных соединений на IP

Для более высоких лимитов или выделенной инфраструктуры рассмотрите возможность запуска собственной ноды используя этот инфраструктурный кит.

---

## Следующие шаги

- [Подключить MetaMask](metamask-guide_ru.md) - Добавить сети Siberium в MetaMask
- [Запустить ноду](node-setup_ru.md) - Развернуть собственную ноду Siberium
- [Получить тестовые токены](resources_ru.md#faucet) - Запросить tSIBR из крана

---

[Назад к README](../README_RU.md)

