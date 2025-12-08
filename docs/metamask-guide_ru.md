# Руководство по интеграции MetaMask

<p align="center">
  <img src="https://chainlist.wtf/static/3e1879b064cdf9a7a81b92280887746a/siberium.svg" alt="Логотип Siberium" width="150"/>
</p>

## Обзор

Это руководство поможет вам подключить кошелек MetaMask к сетям Siberium. Вы можете добавить сети Siberium используя автоматическую кнопку или ручную настройку.

---

## Быстрое добавление (автоматически)

Самый простой способ добавить сети Siberium в MetaMask — использовать кнопку "Добавить в MetaMask".

### Добавить Mainnet в MetaMask

Нажмите кнопку ниже, чтобы автоматически добавить Siberium Mainnet:

<div id="add-mainnet-status"></div>

**Кнопка добавления в MetaMask (Mainnet):**

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
    [ДОБАВИТЬ] Добавить Siberium Mainnet в MetaMask
  </button>
  <div id="status-mainnet" class="status-message"></div>

  <script>
    async function addSiberiumMainnet() {
      const statusDiv = document.getElementById('status-mainnet');
      
      if (typeof window.ethereum === 'undefined') {
        showStatus(statusDiv, 'MetaMask не установлен. Пожалуйста, установите расширение MetaMask.', 'error');
        return;
      }

      const networkParams = {
        chainId: '0x1B207', // 111111 в hex
        chainName: 'Siberium Mainnet',
        nativeCurrency: {
          name: 'SIBR',
          symbol: 'SIBR',
          decimals: 18
        },
        rpcUrls: ['https://rpc.siberium.net'], // TODO: Заменить на актуальный RPC URL
        blockExplorerUrls: ['https://explorer.siberium.net'] // TODO: Заменить на актуальный explorer URL
      };

      try {
        await window.ethereum.request({
          method: 'wallet_addEthereumChain',
          params: [networkParams]
        });
        showStatus(statusDiv, 'Siberium Mainnet успешно добавлен!', 'success');
      } catch (error) {
        console.error('Ошибка добавления сети:', error);
        showStatus(statusDiv, `Ошибка: ${error.message}`, 'error');
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

### Добавить Testnet в MetaMask

Нажмите кнопку ниже, чтобы автоматически добавить Siberium Testnet:

**Кнопка добавления в MetaMask (Testnet):**

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
    [ДОБАВИТЬ] Добавить Siberium Testnet в MetaMask
  </button>
  <div id="status-testnet" class="status-message"></div>

  <script>
    async function addSiberiumTestnet() {
      const statusDiv = document.getElementById('status-testnet');
      
      if (typeof window.ethereum === 'undefined') {
        showStatus(statusDiv, 'MetaMask не установлен. Пожалуйста, установите расширение MetaMask.', 'error');
        return;
      }

      const networkParams = {
        chainId: '0x1B178', // 111000 в hex
        chainName: 'Siberium Testnet',
        nativeCurrency: {
          name: 'Test SIBR',
          symbol: 'tSIBR',
          decimals: 18
        },
        rpcUrls: ['https://rpc.test.siberium.net'], // TODO: Заменить на актуальный RPC URL
        blockExplorerUrls: ['https://explorer.test.siberium.net'] // TODO: Заменить на актуальный explorer URL
      };

      try {
        await window.ethereum.request({
          method: 'wallet_addEthereumChain',
          params: [networkParams]
        });
        showStatus(statusDiv, 'Siberium Testnet успешно добавлен!', 'success');
      } catch (error) {
        console.error('Ошибка добавления сети:', error);
        showStatus(statusDiv, `Ошибка: ${error.message}`, 'error');
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

## Ручная настройка

Если вы предпочитаете добавить сеть вручную или автоматический метод не работает, следуйте этим пошаговым инструкциям.

### Шаг 1: Откройте MetaMask

Нажмите на иконку расширения MetaMask в вашем браузере.

<!-- [PLACEHOLDER: Скриншот иконки MetaMask в панели инструментов браузера] -->

### Шаг 2: Откройте настройки сети

1. Нажмите на выпадающий список сетей вверху MetaMask
2. Нажмите "Добавить сеть" или "Custom RPC"

<!-- [PLACEHOLDER: Скриншот выпадающего меню сетей MetaMask] -->

### Шаг 3: Введите данные сети

#### Для Mainnet:

Заполните следующую информацию:

| Поле | Значение |
|------|----------|
| **Название сети** | Siberium Mainnet |
| **Новый RPC URL** | https://rpc.siberium.net <!-- TODO: Заменить на актуальный RPC --> |
| **Chain ID** | 111111 |
| **Символ валюты** | SIBR |
| **URL обозревателя блоков** | https://explorer.siberium.net <!-- TODO: Заменить на актуальный explorer --> |

<!-- [PLACEHOLDER: Скриншот формы добавления сети MetaMask с данными mainnet] -->

#### Для Testnet:

Заполните следующую информацию:

| Поле | Значение |
|------|----------|
| **Название сети** | Siberium Testnet |
| **Новый RPC URL** | https://rpc.test.siberium.net <!-- TODO: Заменить на актуальный RPC --> |
| **Chain ID** | 111000 |
| **Символ валюты** | tSIBR |
| **URL обозревателя блоков** | https://explorer.test.siberium.net <!-- TODO: Заменить на актуальный explorer --> |

<!-- [PLACEHOLDER: Скриншот формы добавления сети MetaMask с данными testnet] -->

### Шаг 4: Сохраните и подключитесь

1. Нажмите "Сохранить" или "Добавить"
2. MetaMask автоматически переключится на новую сеть
3. Вы должны увидеть название сети вверху MetaMask

<!-- [PLACEHOLDER: Скриншот MetaMask успешно подключенного к сети Siberium] -->

---

## Переключение между сетями

Чтобы переключаться между сетями после их добавления:

1. Нажмите на выпадающий список сетей вверху MetaMask
2. Выберите "Siberium Mainnet" или "Siberium Testnet"

<!-- [PLACEHOLDER: Скриншот выбора сети в MetaMask] -->

---

## Проверка подключения

После добавления сети проверьте, что подключение работает:

### Метод 1: Проверить Chain ID

Откройте консоль MetaMask в инструментах разработчика браузера:

```javascript
// Откройте консоль браузера (F12)
await window.ethereum.request({ method: 'eth_chainId' })
// Должно вернуть: "0x1B207" (Mainnet) или "0x1B178" (Testnet)
```

### Метод 2: Проверить баланс

1. Перейдите в обозреватель блоков
2. Скопируйте адрес вашего кошелька из MetaMask
3. Найдите ваш адрес в обозревателе

### Метод 3: Отправить тестовую транзакцию

В тестовой сети вы можете проверить:
1. Получите тестовые токены из [крана](resources_ru.md#faucet)
2. Отправьте небольшое количество на другой адрес
3. Проверьте транзакцию в обозревателе

---

## Использование Web3 библиотек

### Интеграция Web3.js

```javascript
const Web3 = require('web3');

// Mainnet
const web3 = new Web3('https://rpc.siberium.net');

// Или используйте провайдер MetaMask
if (window.ethereum) {
  const web3 = new Web3(window.ethereum);
  await window.ethereum.request({ method: 'eth_requestAccounts' });
  
  const chainId = await web3.eth.getChainId();
  console.log('Подключено к цепи:', chainId); // 111111 или 111000
}
```

### Интеграция Ethers.js

```javascript
const { ethers } = require('ethers');

// Подключиться к MetaMask
const provider = new ethers.BrowserProvider(window.ethereum);
await provider.send("eth_requestAccounts", []);

const signer = await provider.getSigner();
const address = await signer.getAddress();
console.log('Подключенный адрес:', address);

// Получить информацию о сети
const network = await provider.getNetwork();
console.log('Сеть:', network.name, 'Chain ID:', network.chainId);
```

---

## Устранение неполадок

### MetaMask не обнаруживает сеть

**Проблема:** Сеть добавлена, но не отображается в MetaMask.

**Решение:**
1. Перезапустите браузер
2. Добавьте сеть снова
3. Проверьте, что Chain ID указан правильно (111111 для Mainnet, 111000 для Testnet)

### Не удается подключиться к RPC

**Проблема:** Сообщение "Ошибка подключения к RPC".

**Решение:**
1. Проверьте правильность RPC URL
2. Проверьте подключение к интернету
3. Попробуйте альтернативный RPC эндпоинт (если доступен)
4. Подождите немного и попробуйте снова

### Выбрана неправильная сеть

**Проблема:** Транзакции не проходят из-за неправильной сети.

**Решение:**
1. Проверьте выпадающий список сетей MetaMask
2. Переключитесь на правильную сеть (Mainnet или Testnet)
3. Проверьте Chain ID в консоли разработчика

### Ошибка "nonce too low"

**Проблема:** Транзакция не проходит с ошибкой "nonce too low".

**Решение:**
1. Перейдите в Настройки MetaMask → Расширенные
2. Нажмите "Сбросить аккаунт"
3. Это очистит историю транзакций без влияния на ваши средства

### Зависшие транзакции

**Проблема:** Транзакция застряла в состоянии ожидания.

**Решение:**
1. Подождите 5-10 минут (сеть может быть перегружена)
2. Проверьте, что цена газа достаточна
3. Попробуйте ускорить транзакцию в MetaMask
4. В крайнем случае сбросьте аккаунт (см. выше)

---

## Лучшие практики безопасности

### Храните seed-фразу в безопасности

- **Никогда не делитесь** seed-фразой ни с кем
- **Никогда не вводите** seed-фразу на подозрительных сайтах
- **Храните безопасно** оффлайн в нескольких местах
- MetaMask **никогда** не попросит вашу seed-фразу

### Проверяйте транзакции

Перед подтверждением любой транзакции:
1. Внимательно проверьте адрес получателя
2. Проверьте отправляемую сумму
3. Убедитесь, что выбрана правильная сеть
4. Просмотрите комиссии за газ

### Защита от фишинга

- Всегда проверяйте, что вы на правильном сайте
- Используйте закладки для часто посещаемых сайтов
- Будьте подозрительны к срочным запросам
- Дважды проверяйте адреса контрактов перед взаимодействием

### Используйте аппаратные кошельки

Для больших сумм рассмотрите использование аппаратного кошелька:
- Ledger
- Trezor

Подключите их к MetaMask для повышенной безопасности.

---

## Расширенная настройка

### Пользовательские RPC эндпоинты

Если вы запускаете собственную ноду:

```
http://localhost:8545
```

Или используете удаленную ноду:

```
http://your-node-ip:8545
```

### Множественные RPC эндпоинты

Вы можете добавить несколько RPC URL для резервирования:

1. Добавьте сеть с первым RPC URL
2. Если подключение не удается, отредактируйте сеть
3. Измените на резервный RPC URL

---

## Мобильный MetaMask

Те же сети можно добавить в мобильное приложение MetaMask:

### iOS/Android

1. Откройте приложение MetaMask
2. Нажмите меню (☰)
3. Нажмите "Настройки"
4. Нажмите "Сети"
5. Нажмите "Добавить сеть"
6. Введите данные сети (те же, что и для десктопа)
7. Нажмите "Добавить"

<!-- [PLACEHOLDER: Скриншоты настройки сети в мобильном MetaMask] -->

---

## Следующие шаги

- [Получить тестовые токены](resources_ru.md#faucet) - Запросить tSIBR из крана
- [Развернуть смарт-контракты](node-setup_ru.md) - Начать строить на Siberium
- [Просмотреть детали сети](network-details_ru.md) - Полные спецификации сети

---

[Назад к README](../README_RU.md)


