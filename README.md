# Ubuntu Virtual Machine в Docker

Этот проект создает полноценную Ubuntu виртуальную машину в Docker контейнере с всеми необходимыми инструментами для разработки и администрирования.

## 🚀 Быстрый старт

1. **Собрать и запустить VM:**
   ```bat
   .\start.bat
   ```
   или
   ```powershell
   powershell -ExecutionPolicy Bypass -File "vm.ps1" start
   ```

2. **Подключиться к VM:**
   ```bat
   # Через Docker (рекомендуется)
   .\shell.bat
   
   # Через SSH
   .\ssh.bat
   ```
   или
   ```powershell
   powershell -ExecutionPolicy Bypass -File "vm.ps1" shell
   powershell -ExecutionPolicy Bypass -File "vm.ps1" ssh
   ```

## 📋 Доступные команды
## Команды (простой способ)

| .bat файл | Описание |
|---------|----------|
| `.\start.bat` | Запустить Ubuntu VM |
| `.\stop.bat` | Остановить Ubuntu VM |
| `.\shell.bat` | Подключиться к VM через bash |
| `.\ssh.bat` | Подключиться к VM через SSH |
| `.\status.bat` | Показать статус VM |

## Полные PowerShell команды

| Команда | Описание |
|---------|-----------|
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" start` | Запустить Ubuntu VM |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" stop` | Остановить Ubuntu VM |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" restart` | Перезапустить Ubuntu VM |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" shell` | Подключиться к VM через bash |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" ssh` | Подключиться к VM через SSH |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" build` | Собрать образ Ubuntu VM |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" status` | Показать статус VM |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" logs` | Показать логи VM |
| `powershell -ExecutionPolicy Bypass -File "vm.ps1" remove` | Удалить контейнер и образ |
| `.\ubuntu-vm.ps1 remove` | Удалить контейнер и образ |

## 🔧 Что установлено

### Базовые утилиты
- `curl`, `wget` - загрузка файлов
- `git` - система контроля версий
- `vim`, `nano` - текстовые редакторы
- `htop` - мониторинг системы
- `tree` - просмотр структуры директорий
- `zip`, `unzip` - архивация

### Сетевые утилиты
- `net-tools` - сетевые инструменты
- `ping`, `traceroute` - диагностика сети
- `nmap` - сканирование портов

### Инструменты разработки
- `build-essential` - компиляторы и инструменты сборки
- `python3`, `pip` - Python разработка
- `nodejs`, `npm` - Node.js разработка

### Системные утилиты
- `sudo` - выполнение команд от имени root
- `openssh-server` - SSH сервер
- `mc` - файловый менеджер
- `tmux`, `screen` - терминальные мультиплексоры

## 🌐 Сетевые порты

| Порт на хосте | Порт в контейнере | Назначение |
|---------------|-------------------|------------|
| 2222 | 22 | SSH |
| 8080 | 80 | HTTP |
| 8443 | 443 | HTTPS |
| 3000 | 3000 | Node.js dev server |
| 8000 | 8000 | Python dev server |
| 5000 | 5000 | Flask/другие веб-приложения |

## 📁 Общие папки

- `./shared` ↔ `/home/ubuntu/shared` - папка для обмена файлами между Windows и Ubuntu
- Домашняя директория пользователя сохраняется в Docker volume
- Системные настройки сохраняются между перезапусками

## 👤 Пользователи

- **Пользователь**: `ubuntu`
- **Пароль**: `ubuntu`
- **Права**: sudo без пароля

- **Root пользователь**: `root`
- **Пароль**: `root`

## 🔒 SSH доступ

```bash
# Подключение через SSH
ssh ubuntu@localhost -p 2222

# Пароль: ubuntu
```

## 🛠 Дополнительная настройка

### Установка дополнительного ПО

```bash
# Подключиться к VM
.\ubuntu-vm.ps1 shell

# Установить дополнительное ПО
sudo apt update
sudo apt install имя_пакета
```

### Настройка Git

```bash
git config --global user.name "Ваше имя"
git config --global user.email "your.email@example.com"
```

### Монтирование Windows диска (опционально)

Раскомментируйте строку в `docker-compose.yml`:
```yaml
- C:\:/mnt/windows
```

## 🔄 Управление данными

- **Persistent storage**: Все пользовательские данные, настройки системы и установленные пакеты сохраняются в Docker volumes
- **Backup**: Данные volume можно экспортировать через `docker volume`
- **Reset**: Для полного сброса используйте `.\ubuntu-vm.ps1 remove`

## 🐛 Устранение проблем

### VM не запускается
```powershell
# Проверить статус
.\ubuntu-vm.ps1 status

# Посмотреть логи
.\ubuntu-vm.ps1 logs

# Пересобрать образ
.\ubuntu-vm.ps1 build
```

### SSH не работает
- Убедитесь, что VM запущена: `.\ubuntu-vm.ps1 status`
- Проверьте, что порт 2222 не занят другим процессом
- Попробуйте подключиться через shell: `.\ubuntu-vm.ps1 shell`

### Нехватка места
```bash
# Очистить кэш пакетов
sudo apt clean
sudo apt autoclean
sudo apt autoremove

# Очистить временные файлы
sudo rm -rf /tmp/*
```

## 📚 Полезные команды внутри VM

```bash
# Информация о системе
uname -a
lsb_release -a

# Мониторинг ресурсов
htop
df -h
free -h

# Сетевая информация
ifconfig
netstat -tulpn

# Файловый менеджер
mc
```