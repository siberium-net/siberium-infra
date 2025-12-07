# Siberium Infrastructure

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Логотип Siberium" width="200"/>
</p>

<p align="center">
  <strong>Инфраструктура корпоративного уровня для сети Siberium</strong>
</p>

<p align="center">
  <a href="#быстрый-старт">[БЫСТРЫЙ СТАРТ]</a> •
  <a href="docs/network-details_ru.md">[СЕТИ]</a> •
  <a href="docs/node-setup_ru.md">[НАСТРОЙКА НОДЫ]</a> •
  <a href="docs/metamask-guide_ru.md">[METAMASK]</a> •
  <a href="docs/resources_ru.md">[РЕСУРСЫ]</a> •
  <a href="README.md">[EN]</a>
</p>

---

## Обзор

Siberium — это EVM-совместимый блокчейн уровня L1, предназначенный для высокопроизводительных децентрализованных приложений. Этот репозиторий содержит полный инфраструктурный стек для развертывания и управления нодами сети Siberium, обозревателями блоков и вспомогательными сервисами.

### Сети

- **Mainnet** (Chain ID: 111111) - Продакшн сеть
- **Testnet** (Chain ID: 111000) - Тестовая сеть для разработки

### Ключевые возможности

- **EVM-совместимость** - Полная поддержка виртуальной машины Ethereum
- **Высокая производительность** - Время блока 3 секунды с оптимизированным консенсусом
- **Полный стек** - Нода, обозреватель, кран и сервисы шлюза
- **Docker-based** - Контейнеризированное развертывание для надежности
- **Готовность к продакшну** - Конфигурация промышленного уровня

---

## Быстрый старт

### Требования

- Docker 20.10+ и Docker Compose v2+
- 4GB+ RAM, 100GB+ хранилище (рекомендуется SSD)
- Linux/macOS/Windows с WSL2

### Развертывание ноды Mainnet

```bash
# Клонировать репозиторий
git clone https://github.com/siberium-net/siberium-infra.git
cd siberium-infra

# Настроить окружение
cp env.example networks/mainnet/.env
nano networks/mainnet/.env  # Отредактировать конфигурацию

# Запустить ноду
./ops.sh mainnet up -d

# Проверить логи
./ops.sh mainnet logs -f node
```

### Развертывание ноды Testnet

```bash
# Настроить testnet
cp env.example networks/testnet/.env
nano networks/testnet/.env  # Отредактировать конфигурацию

# Запустить testnet
./ops.sh testnet up -d
```

RPC вашей ноды будет доступен по адресу `http://localhost:8545` (или настроенный порт).

---

## Архитектура

Этот инфраструктурный стек включает:

| Сервис | Описание | Порт |
|--------|----------|------|
| **Node** | Geth (v1.13.14) полная нода | 8545 (RPC), 8546 (WS) |
| **Explorer** | Обозреватель блоков Blockscout | 4000 |
| **Database** | PostgreSQL 15 для обозревателя | 5432 (внутренний) |
| **Gateway** | Nginx reverse proxy с ограничением запросов | 80 |
| **Faucet** | Кран токенов для testnet | 8000 |

### Конфигурация сети

- **Консенсус**: Proof of Authority
- **Время блока**: 3 секунды
- **Лимит газа**: 4,700,000
- **Режим синхронизации**: Full (поддерживается archive)

---

## Документация

### Информация о сети
- [Детали сети](docs/network-details_ru.md) - Chain ID, RPC эндпоинты, обозреватели
- [Интеграция MetaMask](docs/metamask-guide_ru.md) - Подключение кошельков к Siberium

### Операции с нодой
- [Руководство по настройке ноды](docs/node-setup_ru.md) - Три способа развертывания:
  - Быстрый старт (Docker Image)
  - Инфраструктурный кит (Docker Compose)
  - Из исходников (Geth)

### Ресурсы
- [Ресурсы](docs/resources_ru.md) - Краны, мосты, ссылки сообщества

---

## Конфигурация

### Переменные окружения

Ключевые параметры конфигурации в `networks/{mainnet,testnet}/.env`:

```bash
NETWORK_NAME=mainnet          # Идентификатор сети
NETWORK_ID=111111            # Chain ID
RPC_PORT=8545                # RPC порт на хосте
WS_PORT=8546                 # WebSocket порт
EXPLORER_PORT=4000           # Порт Blockscout
```

См. [`env.example`](env.example) для всех доступных опций.

### Конфигурация Genesis

Genesis файлы определяют инициализацию сети:
- Mainnet: [`networks/mainnet/genesis.json`](networks/mainnet/genesis.json)
- Testnet: [`networks/testnet/genesis.json`](networks/testnet/genesis.json)

---

## Операции

### Управление сервисами

```bash
# Запустить все сервисы
./ops.sh mainnet up -d

# Остановить сервисы
./ops.sh mainnet down

# Просмотр логов
./ops.sh mainnet logs -f node

# Перезапустить ноду
./ops.sh mainnet restart node

# Проверить статус
./ops.sh mainnet ps
```

### Сохранение данных

Данные блокчейна хранятся в `./data/{network}/`:
- `geth/` - Данные блокчейна ноды
- `pg/` - База данных обозревателя
- `faucet/` - База данных крана (testnet)

### Резервное копирование и восстановление

```bash
# Резервная копия данных ноды
tar -czf backup-mainnet-$(date +%Y%m%d).tar.gz data/mainnet/geth

# Восстановление из резервной копии
./ops.sh mainnet down
tar -xzf backup-mainnet-20231201.tar.gz
./ops.sh mainnet up -d
```

---

## Сетевое подключение

### Bootnodes

Настройте bootnodes в вашем `.env` файле:

```bash
BOOTNODES=enode://[TODO: Добавить адрес bootnode для mainnet]
```

<!-- TODO: Добавить актуальные enode адреса bootnode для mainnet и testnet -->

### Статические пиры

Для гарантированного подключения к определенным нодам:

```bash
STATIC_PEERS=enode://peer1@ip:port,enode://peer2@ip:port
```

---

## Соображения безопасности

### Развертывание в продакшн

1. **Конфигурация файрвола**
   - Открывать только необходимые порты (RPC/WS)
   - Ограничить доступ к RPC доверенными IP
   - Использовать VPN для административного доступа

2. **Управление секретами**
   - Изменить стандартные учетные данные PostgreSQL
   - Сгенерировать безопасный `SECRET_KEY_BASE` для обозревателя
   - Хранить приватные ключи крана безопасно

3. **Ограничение частоты запросов**
   - Шлюз включает ограничение nginx (100 req/s)
   - Настроить лимиты в `services/gateway/nginx.conf`

4. **SSL/TLS**
   - Использовать reverse proxy (Cloudflare, nginx) для HTTPS
   - Никогда не открывать RPC напрямую в интернет без шифрования

---

## Требования к оборудованию

### Минимальные требования

- **CPU**: 4 ядра
- **RAM**: 8GB
- **Хранилище**: 200GB SSD
- **Сеть**: 10 Mbps

### Рекомендуемые требования

- **CPU**: 8+ ядер
- **RAM**: 16GB+
- **Хранилище**: 500GB+ NVMe SSD
- **Сеть**: 100 Mbps

---

## Устранение неполадок

### Нода не синхронизируется

```bash
# Проверить подключения к пирам
./ops.sh mainnet exec node geth attach --exec "admin.peers" /root/.ethereum/geth.ipc

# Проверить подключение к bootnode
# Убедитесь, что переменная BOOTNODES установлена правильно
```

### Обозреватель не загружается

```bash
# Проверить подключение к базе данных
./ops.sh mainnet logs db

# Проверить подключение к RPC
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Высокое использование диска

```bash
# Проверить использование диска
du -sh data/mainnet/*

# Очистить логи
./ops.sh mainnet logs --tail 0
docker system prune -f
```

---

## Участие в разработке

Приветствуются вклады в проект! Пожалуйста, следуйте этим рекомендациям:

1. Сделайте форк репозитория
2. Создайте ветку для фичи
3. Тщательно протестируйте изменения
4. Отправьте pull request с четким описанием

---

## Лицензия

Этот проект лицензирован под MIT License - см. файл LICENSE для деталей.

---

## Поддержка

- **Документация**: [docs/](docs/)
- **Issues**: GitHub Issues
- **Сообщество**: [Discord](#) <!-- TODO: Добавить ссылку на Discord -->
- **Email**: support@siberium.net <!-- TODO: Добавить актуальный email поддержки -->

---

## Благодарности

Создано с использованием:
- [Go Ethereum (Geth)](https://geth.ethereum.org/) - Ethereum клиент
- [Blockscout](https://blockscout.com/) - Обозреватель блокчейна
- [Docker](https://docker.com/) - Платформа контейнеризации
- [Nginx](https://nginx.org/) - Веб-сервер и reverse proxy

---

<p align="center">
  Создано в соответствии со стандартами промышленного уровня для сети Siberium
</p>

