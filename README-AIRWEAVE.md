# Ubuntu VM с Airweave

Полноценная Ubuntu виртуальная машина с Docker-in-Docker и предустановленным Airweave AI.

## 🚀 Быстрый старт

1. **Запустить Ubuntu VM:**
   ```bat
   .\start.bat
   ```

2. **Запустить Airweave:**
   ```bat
   .\airweave.bat start
   ```

3. **Открыть Airweave в браузере:**
   - Frontend UI: http://localhost:8080
   - Backend API: http://localhost:8001
   - Temporal UI: http://localhost:8088

## 📋 Команды управления VM

| .bat файл | Описание |
|---------|----------|
| `.\start.bat` | Запустить Ubuntu VM |
| `.\stop.bat` | Остановить Ubuntu VM |
| `.\shell.bat` | Подключиться к VM через bash |
| `.\ssh.bat` | Подключиться к VM через SSH |
| `.\status.bat` | Показать статус VM |

## 🤖 Команды управления Airweave

| Команда | Описание |
|---------|----------|
| `.\airweave.bat start` | Запустить Airweave сервисы |
| `.\airweave.bat stop` | Остановить Airweave сервисы |
| `.\airweave.bat status` | Показать статус Airweave |
| `.\airweave.bat logs` | Показать логи Airweave |
| `.\airweave.bat shell` | Открыть shell в Ubuntu VM |

## 🌐 Доступ к сервисам

### Airweave
- **Frontend UI**: http://localhost:8080 - Основной интерфейс
- **Backend API**: http://localhost:8001 - REST API
- **Temporal UI**: http://localhost:8088 - Workflow управление

### Базы данных
- **PostgreSQL**: localhost:5432 - Основная БД
- **Redis**: localhost:6379 - Кэш и очереди
- **Qdrant**: http://localhost:6333 - Векторная БД

### SSH доступ
- **Host**: localhost:2222
- **User**: ubuntu
- **Password**: ubuntu

## 🔧 Настройка API ключей

Для полной функциональности Airweave необходимо настроить API ключи:

1. **Подключиться к VM:**
   ```bat
   .\shell.bat
   ```

2. **Отредактировать .env файл:**
   ```bash
   cd ~/airweave
   nano .env
   ```

3. **Добавить ваши API ключи:**
   ```bash
   OPENAI_API_KEY="your-openai-api-key-here"
   MISTRAL_API_KEY="your-mistral-api-key-here"
   ```

4. **Перезапустить Airweave:**
   ```bash
   exit  # выйти из VM
   .\airweave.bat stop
   .\airweave.bat start
   ```

## 📁 Структура файлов

```
E:\docker\
├── Dockerfile              # Docker образ Ubuntu с Docker-in-Docker
├── docker-compose.yml      # Конфигурация VM
├── vm.ps1                  # PowerShell скрипт управления VM
├── airweave.bat           # Управление Airweave
├── start.bat              # Быстрый запуск VM
├── stop.bat               # Остановка VM
├── shell.bat              # Подключение к VM
├── ssh.bat                # SSH подключение
├── status.bat             # Статус VM
└── shared/                # Общая папка Windows ↔ Ubuntu
```

## 🔍 Устранение проблем

### VM не запускается
```bat
.\status.bat
powershell -ExecutionPolicy Bypass -File "vm.ps1" logs
```

### Airweave не запускается
```bat
.\airweave.bat logs
.\shell.bat
# Внутри VM:
cd ~/airweave
docker compose -f docker/docker-compose.yml logs
```

### Docker daemon не запущен
```bat
.\shell.bat
# Внутри VM:
sudo dockerd > /var/log/docker.log 2>&1 &
```

## 💡 Полезные команды

### Внутри Ubuntu VM
```bash
# Проверить статус Docker
docker info

# Управление Airweave вручную
cd ~/airweave
./start.sh --noninteractive    # Запуск
docker compose -f docker/docker-compose.yml down  # Остановка

# Просмотр логов отдельных сервисов
docker logs airweave-backend
docker logs airweave-frontend
docker logs airweave-temporal

# Обновление Airweave
git pull
./start.sh --noninteractive
```

### Из Windows
```bat
# Быстрый доступ к логам
.\airweave.bat logs

# Проверка всех сервисов
.\airweave.bat status

# Перезапуск всего
.\airweave.bat stop
.\airweave.bat start
```

## 🎯 Что дальше?

1. Откройте http://localhost:8080 в браузере
2. Настройте API ключи в .env файле
3. Изучите документацию Airweave
4. Создайте свой первый AI workflow!

## 📚 Ссылки

- [Airweave GitHub](https://github.com/airweave-ai/airweave)
- [Airweave Documentation](https://docs.airweave.ai)
- [Docker Documentation](https://docs.docker.com)
- [Temporal Documentation](https://docs.temporal.io)