# Руководство по настройке ноды

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Логотип Siberium" width="150"/>
</p>

## Обзор

Это руководство предоставляет три метода развертывания ноды Siberium. Выберите метод, который лучше всего соответствует вашим требованиям:

- **Метод A: Быстрый старт** - Единичный Docker контейнер, самое быстрое развертывание
- **Метод B: Инфраструктурный кит** - Полный стек с обозревателем и сервисами
- **Метод C: Из исходников** - Ручная настройка Geth, максимальный контроль

---

## Предварительные требования

Все методы требуют:

- **Операционная система**: Linux (Ubuntu 20.04+), macOS, или Windows с WSL2
- **CPU**: 4+ ядра (рекомендуется 8+)
- **RAM**: минимум 8GB (рекомендуется 16GB+)
- **Хранилище**: 200GB+ SSD (рекомендуется 500GB+ для долгосрочной работы)
- **Сеть**: Стабильное интернет-соединение (10+ Mbps)

### Дополнительные требования по методам

**Метод A и B:**
- Docker 20.10+ ([руководство по установке](https://docs.docker.com/engine/install/))
- Docker Compose v2+ ([руководство по установке](https://docs.docker.com/compose/install/))

**Метод C:**
- Go 1.20+ ([руководство по установке](https://go.dev/doc/install))
- Git
- Инструменты сборки (gcc, make)

---

## Метод A: Быстрый старт (Docker Image)

Самый быстрый способ запустить ноду Siberium используя готовый Docker образ.

### Шаг 1: Получить Genesis файл

```bash
# Создать директорию для данных
mkdir -p ./siberium-data

# Скачать genesis файл для mainnet
curl -o ./genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/mainnet/genesis.json

# Для testnet используйте:
# curl -o ./genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/testnet/genesis.json
```

### Шаг 2: Запустить ноду

**Для Mainnet:**

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

<!-- TODO: Заменить на актуальное имя Docker образа после публикации на ghcr.io -->

**Для Testnet:**

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

<!-- TODO: Добавить актуальные адреса bootnode для переменной окружения BOOTNODES -->

### Шаг 3: Проверить работу ноды

```bash
# Проверить логи
docker logs -f siberium-mainnet

# Тестировать RPC соединение
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

### Опции конфигурации

| Переменная окружения | Описание | По умолчанию |
|---------------------|----------|--------------|
| `NETWORK_ID` | Chain ID (111111 или 111000) | 111000 |
| `BOOTNODES` | Bootnode enode через запятую | (пусто) |
| `STATIC_PEERS` | Static peer enode через запятую | (пусто) |
| `DATADIR` | Директория данных внутри контейнера | /root/.ethereum |

### Управление нодой

```bash
# Остановить ноду
docker stop siberium-mainnet

# Запустить ноду
docker start siberium-mainnet

# Перезапустить ноду
docker restart siberium-mainnet

# Просмотреть логи
docker logs -f siberium-mainnet

# Удалить ноду (данные сохраняются)
docker rm -f siberium-mainnet
```

---

## Метод B: Инфраструктурный кит (Docker Compose)

Развертывание полного инфраструктурного стека включая ноду, обозреватель блоков, кран и шлюз.

### Архитектура

Этот метод развертывает:
- **Geth Node** (v1.13.14) - Полная архивная нода
- **Blockscout** - Обозреватель блокчейна
- **PostgreSQL** - База данных для обозревателя
- **Nginx Gateway** - Reverse proxy с ограничением запросов
- **Faucet** - Сервис распределения токенов (только testnet)

### Шаг 1: Клонировать репозиторий

```bash
git clone https://github.com/siberium-net/siberium-infra.git
cd siberium-infra
```

<!-- TODO: Обновить URL репозитория когда станет публичным -->

### Шаг 2: Настроить окружение

**Для Mainnet:**

```bash
# Скопировать пример файла окружения
cp env.example networks/mainnet/.env

# Отредактировать конфигурацию
nano networks/mainnet/.env
```

Отредактируйте следующие ключевые параметры в `networks/mainnet/.env`:

```bash
# Конфигурация сети
NETWORK_NAME=mainnet
NETWORK_ID=111111

# Порты на хост-машине
RPC_PORT=8545
WS_PORT=8546
GATEWAY_PORT=80
EXPLORER_PORT=4000

# Подключение ноды
BOOTNODES=enode://[TODO: Добавить адреса mainnet bootnode]
STATIC_PEERS=

# Учетные данные БД (изменить в продакшене!)
POSTGRES_USER=blockscout
POSTGRES_PASSWORD=ИЗМЕНИТЕ_ЭТОТ_ПАРОЛЬ
POSTGRES_DB=blockscout

# Секрет обозревателя (сгенерировать: openssl rand -base64 64)
SECRET_KEY_BASE=СГЕНЕРИРУЙТЕ_И_ВСТАВЬТЕ_СЕКРЕТ_СЮДА
```

**Для Testnet:**

```bash
# Скопировать пример файла окружения
cp env.example networks/testnet/.env

# Отредактировать конфигурацию
nano networks/testnet/.env
```

Дополнительная testnet-специфичная конфигурация:

```bash
# Конфигурация крана
FAUCET_PRIVATE_KEY=ВАШ_ПРИВАТНЫЙ_КЛЮЧ_ЗДЕСЬ
FAUCET_RPC_URL=http://node:8545
FAUCET_AMOUNT=1
FAUCET_PORT=8000
```

### Шаг 3: Развернуть стек

**Для Mainnet:**

```bash
./ops.sh mainnet up -d
```

**Для Testnet:**

```bash
./ops.sh testnet up -d
```

### Шаг 4: Мониторинг развертывания

```bash
# Проверить статус сервисов
./ops.sh mainnet ps

# Просмотреть логи всех сервисов
./ops.sh mainnet logs -f

# Просмотреть логи конкретного сервиса
./ops.sh mainnet logs -f node
./ops.sh mainnet logs -f blockscout
```

### Шаг 5: Доступ к сервисам

После развертывания сервисы доступны по адресам:

| Сервис | URL | Описание |
|--------|-----|----------|
| RPC | http://localhost:8545 | JSON-RPC эндпоинт |
| WebSocket | ws://localhost:8546 | WebSocket эндпоинт |
| Explorer | http://localhost:4000 | Обозреватель блоков Blockscout |
| Gateway | http://localhost:80 | Единый шлюз (RPC + Explorer) |
| Faucet | http://localhost:8000 | Кран токенов (только testnet) |

### Управление стеком

```bash
# Остановить все сервисы
./ops.sh mainnet down

# Перезапустить конкретный сервис
./ops.sh mainnet restart node

# Просмотреть использование ресурсов
./ops.sh mainnet stats

# Выполнить команду в контейнере
./ops.sh mainnet exec node geth attach /root/.ethereum/geth.ipc

# Удалить все контейнеры (данные сохраняются)
./ops.sh mainnet down

# Удалить все данные (ВНИМАНИЕ: деструктивно)
./ops.sh mainnet down -v
rm -rf data/mainnet/
```

### Обновление стека

```bash
# Получить последние образы
./ops.sh mainnet pull

# Перезапустить с новыми образами
./ops.sh mainnet up -d

# Или пересобрать из исходников
./ops.sh mainnet build --no-cache
./ops.sh mainnet up -d
```

### Соображения для продакшена

#### 1. Настройка SSL/TLS

Для продакшена настройте SSL/TLS используя reverse proxy:

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

#### 2. Конфигурация файрвола

```bash
# Разрешить RPC и P2P порты
sudo ufw allow 8545/tcp  # RPC
sudo ufw allow 8546/tcp  # WebSocket
sudo ufw allow 30303/tcp # P2P
sudo ufw allow 30303/udp # P2P Discovery
```

#### 3. Мониторинг

Настройте мониторинг с Prometheus и Grafana:

```bash
# Добавить в docker-compose.override.yml
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

## Метод C: Из исходников (Geth)

Соберите и запустите Geth вручную для максимального контроля и настройки.

### Шаг 1: Установить зависимости

**Ubuntu/Debian:**

```bash
sudo apt-get update
sudo apt-get install -y build-essential git golang-1.20
```

**macOS:**

```bash
brew install go git
```

### Шаг 2: Клонировать и собрать Geth

```bash
# Клонировать репозиторий go-ethereum
git clone https://github.com/ethereum/go-ethereum.git
cd go-ethereum

# Переключиться на стабильную версию (v1.13.14)
git checkout v1.13.14

# Собрать Geth
make geth

# Проверить установку
./build/bin/geth version
```

### Шаг 3: Скачать Genesis файл

```bash
# Создать структуру директорий
mkdir -p ~/siberium-node/data
cd ~/siberium-node

# Скачать mainnet genesis
curl -o genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/mainnet/genesis.json

# Для testnet:
# curl -o genesis.json https://raw.githubusercontent.com/siberium-net/siberium-infra/main/networks/testnet/genesis.json
```

### Шаг 4: Инициализировать ноду

```bash
# Инициализировать с genesis файлом
geth --datadir ./data init genesis.json
```

### Шаг 5: Запустить ноду

**Для Mainnet:**

```bash
geth \
  --datadir ./data \
  --networkid 111111 \
  --bootnodes "enode://[TODO: Добавить адрес bootnode]" \
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

**Для Testnet:**

```bash
geth \
  --datadir ./data \
  --networkid 111000 \
  --bootnodes "enode://[TODO: Добавить адрес bootnode]" \
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

### Шаг 6: Запуск как системный сервис

Создайте systemd сервис для автоматического старта:

```bash
sudo nano /etc/systemd/system/siberium.service
```

Добавьте следующее:

```ini
[Unit]
Description=Siberium Node
After=network.target

[Service]
Type=simple
User=ВАШ_ЮЗЕРНЕЙМ
WorkingDirectory=/home/ВАШ_ЮЗЕРНЕЙМ/siberium-node
ExecStart=/usr/local/bin/geth \
  --datadir /home/ВАШ_ЮЗЕРНЕЙМ/siberium-node/data \
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

Включите и запустите сервис:

```bash
# Перезагрузить systemd
sudo systemctl daemon-reload

# Включить сервис
sudo systemctl enable siberium

# Запустить сервис
sudo systemctl start siberium

# Проверить статус
sudo systemctl status siberium

# Просмотреть логи
sudo journalctl -u siberium -f
```

### Опции командной строки Geth

| Опция | Описание | Рекомендуемое значение |
|-------|----------|------------------------|
| `--networkid` | Chain ID | 111111 (mainnet) / 111000 (testnet) |
| `--syncmode` | Режим синхронизации | `full` или `snap` |
| `--gcmode` | Сборка мусора | `full` или `archive` |
| `--cache` | Кэш памяти (MB) | 4096 (4GB) |
| `--maxpeers` | Макс. подключений пиров | 50 |
| `--http.api` | Включенные RPC API | `eth,net,web3,txpool` |
| `--verbosity` | Уровень логов (0-5) | 3 |

---

## Мониторинг и диагностика ноды

### Проверить статус синхронизации

```bash
# Через RPC
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'

# Через консоль Geth
geth attach http://localhost:8545
> eth.syncing
```

### Проверить количество пиров

```bash
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'
```

### Просмотреть подключенных пиров

```bash
geth attach http://localhost:8545
> admin.peers
```

### Мониторинг производства блоков

```bash
# Получить текущий блок
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Следить за блоками в реальном времени
watch -n 3 'curl -s -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"eth_blockNumber\",\"params\":[],\"id\":1}" | jq'
```

### Мониторинг ресурсов

```bash
# Использование диска
du -sh ~/siberium-node/data

# Если используется Docker
docker stats siberium-mainnet

# Если используется systemd
systemctl status siberium
```

---

## Устранение неполадок

### Нода не синхронизируется

**Симптомы:** Номер блока остается на 0 или не увеличивается.

**Решения:**
1. Проверить подключение к bootnode
2. Проверить, что genesis файл соответствует сети
3. Убедиться, что файрвол разрешает P2P порт (30303)
4. Проверить, синхронизировано ли время (NTP)

```bash
# Проверить системное время
timedatectl

# Синхронизировать время
sudo ntpdate -s time.nist.gov
```

### Недостаточно места на диске

**Симптомы:** Нода останавливается, ошибки о месте на диске.

**Решения:**
1. Увеличить место на диске
2. Использовать `--gcmode full` вместо `archive`
3. Включить обрезку (удаляет старое состояние)

```bash
# Проверить использование диска
df -h

# Обрезать старые данные (временно останавливает ноду)
geth --datadir ./data snapshot prune-state
```

### Высокое использование памяти

**Симптомы:** Замедление системы, ошибки OOM.

**Решения:**
1. Уменьшить значение `--cache`
2. Увеличить системную RAM
3. Включить swap пространство

```bash
# Проверить использование памяти
free -h

# Добавить swap пространство (4GB)
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### RPC не отвечает

**Симптомы:** Ошибки отказа в соединении или таймаута.

**Решения:**
1. Проверить, что нода запущена
2. Проверить, что порты не заблокированы
3. Убедиться, что `--http` и `--http.addr` установлены правильно

```bash
# Тестировать локальный RPC
curl http://localhost:8545

# Проверить привязку портов
netstat -tuln | grep 8545

# Проверить файрвол
sudo ufw status
```

---

## Оптимизация производительности

### Оптимизация хранилища

- Использовать NVMe SSD для лучшей производительности
- Включить TRIM на SSD
- Использовать файловую систему XFS или EXT4

### Оптимизация сети

```bash
# Увеличить лимиты файловых дескрипторов
sudo nano /etc/security/limits.conf
# Добавить:
* soft nofile 65536
* hard nofile 65536
```

### Оптимизация CPU

```bash
# Установить CPU governor на performance
sudo cpupower frequency-set -g performance
```

---

## Лучшие практики безопасности

1. **Правила файрвола**: Открывать только необходимые порты
2. **RPC аутентификация**: Использовать reverse proxy с аутентификацией
3. **Ограничение запросов**: Внедрить ограничение запросов на RPC эндпоинтах
4. **Регулярные обновления**: Поддерживать Geth и системные пакеты обновленными
5. **Мониторинг**: Настроить оповещения о проблемах с нодой
6. **Резервные копии**: Регулярные бэкапы критических данных

---

## Следующие шаги

- [Подключить MetaMask](metamask-guide_ru.md) - Подключить кошелек к ноде
- [Детали сети](network-details_ru.md) - Узнать больше о сетях Siberium
- [Ресурсы](resources_ru.md) - Дополнительные инструменты и ссылки

---

[Назад к README](../README_RU.md)

