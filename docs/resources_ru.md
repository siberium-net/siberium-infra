# Ресурсы

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Логотип Siberium" width="150"/>
</p>

## Обзор

Эта страница содержит ссылки на основные ресурсы сети Siberium, инструменты и каналы сообщества.

---

## Сетевые ресурсы

### Mainnet

| Ресурс | URL | Описание |
|--------|-----|----------|
| **RPC эндпоинт** | https://rpc.siberium.net | JSON-RPC API эндпоинт |
| **WebSocket** | wss://ws.siberium.net | WebSocket эндпоинт |
| **Обозреватель блоков** | https://explorer.siberium.net | Обозреватель Blockscout |
| **Статус сети** | https://status.siberium.net | Панель состояния сети |

<!-- TODO: Заменить все mainnet URL на актуальные продакшн эндпоинты -->

### Testnet

| Ресурс | URL | Описание |
|--------|-----|----------|
| **RPC эндпоинт** | https://rpc.test.siberium.net | JSON-RPC API эндпоинт |
| **WebSocket** | wss://ws.test.siberium.net | WebSocket эндпоинт |
| **Обозреватель блоков** | https://explorer.test.siberium.net | Обозреватель Blockscout |
| **Кран токенов** | https://faucet.test.siberium.net | Кран тестовых токенов |

<!-- TODO: Заменить все testnet URL на актуальные эндпоинты -->

---

## Кран токенов

### Testnet кран

Получите бесплатные tSIBR токены для тестирования в Siberium Testnet.

**URL:** https://faucet.test.siberium.net
<!-- TODO: Добавить актуальный URL крана -->

**Как использовать:**
1. Подключите кошелек MetaMask
2. Убедитесь, что вы в Siberium Testnet (Chain ID: 111000)
3. Введите адрес вашего кошелька
4. Нажмите "Запросить токены"
5. Получите 1 tSIBR за запрос

**Лимиты:**
- 1 запрос на адрес за 24 часа
- Максимум 1 tSIBR за запрос

**Устранение неполадок:**
- Убедитесь, что кошелек подключен к testnet
- Проверьте, не запрашивали ли вы токены за последние 24 часа
- Проверьте, что у контракта крана достаточный баланс

---

## Мост

### Кросс-чейн мост

Перевод активов между Siberium и другими сетями.

**URL моста:** https://bridge.siberium.net
<!-- TODO: Добавить актуальный URL моста когда будет доступен -->

**Поддерживаемые сети:**
- Ethereum Mainnet
- Binance Smart Chain
- Polygon
- Arbitrum
<!-- TODO: Обновить актуальными поддерживаемыми сетями -->

**Поддерживаемые активы:**
- SIBR (нативный токен)
- USDT
- USDC
- ETH
<!-- TODO: Обновить актуальными поддерживаемыми активами -->

**Комиссии моста:**
- Применяются сетевые комиссии за газ
- Комиссия моста: 0.1% за транзакцию
<!-- TODO: Обновить актуальными комиссиями моста -->

---

## Обозреватели блоков

### Официальные обозреватели

**Mainnet обозреватель:**
- URL: https://explorer.siberium.net
- Функции: Транзакции, блоки, контракты, токены, аналитика

**Testnet обозреватель:**
- URL: https://explorer.test.siberium.net
- Функции: Полная поддержка разработки и тестирования

<!-- TODO: Добавить актуальные URL обозревателей -->

### Сторонние обозреватели

Дополнительные обозреватели блоков могут быть доступны через сторонних провайдеров.

<!-- TODO: Добавить ссылки на сторонние обозреватели когда будут доступны -->

---

## Инструменты разработчика

### Разработка смарт-контрактов

**Remix IDE:**
- Онлайн IDE для разработки на Solidity
- URL: https://remix.ethereum.org
- Настройте с Siberium RPC

**Hardhat:**
```bash
npm install --save-dev hardhat
npx hardhat init
```

Настройте `hardhat.config.js`:
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

Настройте `truffle-config.js`:
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

## Web3 библиотеки

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

## API и SDK

### JSON-RPC API

Полностью совместимый с Ethereum JSON-RPC API доступен по адресу:
- Mainnet: https://rpc.siberium.net
- Testnet: https://rpc.test.siberium.net

**Документация:** [Спецификация Ethereum JSON-RPC](https://ethereum.org/en/developers/docs/apis/json-rpc/)

### GraphQL API

Blockscout предоставляет GraphQL API для расширенных запросов:
- Mainnet: https://explorer.siberium.net/graphiql
- Testnet: https://explorer.test.siberium.net/graphiql

<!-- TODO: Проверить пути GraphQL эндпоинтов -->

---

## Инфраструктура

### Развертывание ноды

**Этот репозиторий:**
- GitHub: https://github.com/siberium-net/siberium-infra
- Документация: [Руководство по настройке ноды](node-setup_ru.md)

<!-- TODO: Добавить актуальный URL GitHub репозитория -->

**Docker образы:**
- Mainnet: `ghcr.io/siberium-net/siberium-mainnet:latest`
- Testnet: `ghcr.io/siberium-net/siberium-testnet:latest`

<!-- TODO: Добавить актуальные URL Docker registry -->

### Инструменты мониторинга

**Prometheus метрики:**
```yaml
scrape_configs:
  - job_name: 'siberium-node'
    static_configs:
      - targets: ['localhost:6060']
```

**Grafana панели:**
- Ethereum Node Dashboard
- Blockscout Dashboard
<!-- TODO: Добавить ссылки на JSON панелей Grafana -->

---

## Сообщество

### Официальные каналы

**Веб-сайт:**
- URL: https://siberium.net
<!-- TODO: Добавить актуальный URL сайта -->

**Документация:**
- URL: https://docs.siberium.net
<!-- TODO: Добавить актуальный URL документации -->

**GitHub:**
- Организация: https://github.com/siberium-net
<!-- TODO: Добавить актуальный URL организации GitHub -->

### Социальные сети

**Twitter:**
- Handle: @SiberiumNet
- URL: https://twitter.com/SiberiumNet
<!-- TODO: Добавить актуальный Twitter handle и URL -->

**Discord:**
- Сервер: Siberium Community
- URL: https://discord.gg/siberium
<!-- TODO: Добавить актуальную ссылку Discord invite -->

**Telegram:**
- Канал: @SiberiumOfficial
- URL: https://t.me/SiberiumOfficial
<!-- TODO: Добавить актуальный Telegram канал -->

**Medium:**
- Блог: https://medium.com/@siberium
<!-- TODO: Добавить актуальный URL блога Medium -->

---

## Поддержка

### Техническая поддержка

**GitHub Issues:**
- Сообщайте об ошибках и проблемах
- URL: https://github.com/siberium-net/siberium-infra/issues
<!-- TODO: Добавить актуальный URL issues -->

**Форум разработчиков:**
- Задавайте вопросы и обсуждайте
- URL: https://forum.siberium.net
<!-- TODO: Добавить актуальный URL форума если доступен -->

**Email поддержка:**
- Техническая: support@siberium.net
- Безопасность: security@siberium.net
- Бизнес: business@siberium.net
<!-- TODO: Добавить актуальные email адреса поддержки -->

---

## Гранты и программы

### Гранты для разработчиков

Поддержка для разработчиков, строящих на Siberium.

**Программа грантов:**
- URL: https://grants.siberium.net
- Финансирование: До $50,000 на проект
- Фокус: DeFi, Gaming, Infrastructure, Tooling
<!-- TODO: Добавить актуальный URL программы грантов и детали -->

### Программа Bug Bounty

Программа ответственного раскрытия для исследователей безопасности.

**Программа Bounty:**
- URL: https://bounty.siberium.net
- Награды: $100 - $100,000 в зависимости от серьезности
- Область: Программное обеспечение ноды, смарт-контракты, инфраструктура
<!-- TODO: Добавить актуальный URL bug bounty и детали -->

---

## Обучающие ресурсы

### Документация

- [Детали сети](network-details_ru.md) - Полные спецификации сети
- [Руководство MetaMask](metamask-guide_ru.md) - Подключение кошельков к Siberium
- [Настройка ноды](node-setup_ru.md) - Развертывание и управление нодами

### Туториалы

**Скоро:**
- Развертывание первого смарт-контракта
- Создание DApp на Siberium
- Настройка ноды валидатора
- Создание NFT коллекции
<!-- TODO: Добавить ссылки на туториалы когда будут доступны -->

### Примеры проектов

**GitHub репозитории:**
- Siberium DApp шаблон
- Примеры токен-контрактов
- Шаблон NFT маркетплейса
<!-- TODO: Добавить ссылки на примеры репозиториев -->

---

## Статистика сети

### Живая статистика

**Панель сети:**
- URL: https://stats.siberium.net
<!-- TODO: Добавить актуальный URL панели статистики сети -->

**Ключевые метрики:**
- Текущая высота блока
- Среднее время блока
- Всего транзакций
- Активные адреса
- Хешрейт сети
- Статистика цен на газ

---

## Медиа-кит

### Брендовые активы

**Загрузка логотипа:**
- SVG: https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg
- PNG (Высокое разрешение): [Скачать](#)
- Руководство по бренду: [Скачать](#)
<!-- TODO: Добавить актуальные ссылки для скачивания медиа-кита -->

**Цвета бренда:**
- Основной: `#c5de1d` (Лаймовый зеленый)
- Вторичный: `#1edaff` (Голубой)
- Градиент: `linear-gradient(135deg, #c5de1d 0%, #1edaff 100%)`

---

## Партнеры и интеграции

### Поддержка кошельков

- MetaMask
- Trust Wallet
- Coinbase Wallet
- WalletConnect
<!-- TODO: Обновить подтвержденными интеграциями кошельков -->

### Интеграции DEX

- Uniswap V3
- SushiSwap
- PancakeSwap
<!-- TODO: Обновить актуальными интеграциями DEX -->

### Инфраструктурные партнеры

- Alchemy
- Infura
- QuickNode
<!-- TODO: Обновить актуальными инфраструктурными партнерами -->

---

## Соответствие и юридические вопросы

### Условия использования

- URL: https://siberium.net/terms
<!-- TODO: Добавить актуальный URL ToS -->

### Политика конфиденциальности

- URL: https://siberium.net/privacy
<!-- TODO: Добавить актуальный URL политики конфиденциальности -->

### Соответствие регуляторным требованиям

Siberium работает в соответствии с применимыми регуляторными требованиями. Для конкретных запросов обращайтесь: legal@siberium.net
<!-- TODO: Добавить актуальный контакт юридического отдела -->

---

## Журнал изменений

### Последние обновления

**2024-12-07:**
- Опубликован репозиторий документации
- Выпущена конфигурация mainnet genesis
- Доступны инструменты развертывания инфраструктуры

<!-- TODO: Поддерживать журнал изменений актуальным с релизами -->

---

## Быстрые ссылки

| Категория | Ссылка |
|-----------|--------|
| Добавить Mainnet в MetaMask | [Руководство](metamask-guide_ru.md#быстрое-добавление-автоматически) |
| Добавить Testnet в MetaMask | [Руководство](metamask-guide_ru.md#добавить-testnet-в-metamask) |
| Получить тестовые токены | [Кран](#кран-токенов) |
| Развернуть ноду | [Руководство по настройке](node-setup_ru.md) |
| Спецификации сети | [Детали](network-details_ru.md) |
| GitHub репозиторий | https://github.com/siberium-net |

---

[Назад к README](../README_RU.md)

