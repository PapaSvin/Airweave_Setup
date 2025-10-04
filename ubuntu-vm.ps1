# Ubuntu VM Management Script
# This script provides convenient commands for managing Ubuntu container as VM

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "shell", "ssh", "build", "remove", "status", "logs")]
    [string]$Action = "help"
)

$ContainerName = "ubuntu-vm"
$DockerComposeFile = "docker-compose.yml"

function Show-Help {
    Write-Host ""
    Write-Host "Ubuntu VM Management Commands:" -ForegroundColor Green
    Write-Host "  start    - Запустить Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  stop     - Остановить Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  restart  - Перезапустить Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  shell    - Подключиться к VM через bash" -ForegroundColor Yellow
    Write-Host "  ssh      - Подключиться к VM через SSH" -ForegroundColor Yellow
    Write-Host "  build    - Собрать образ Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  remove   - Удалить контейнер и образ" -ForegroundColor Yellow
    Write-Host "  status   - Показать статус VM" -ForegroundColor Yellow
    Write-Host "  logs     - Показать логи VM" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Примеры использования:" -ForegroundColor Cyan
    Write-Host "  .\ubuntu-vm.ps1 start" -ForegroundColor Gray
    Write-Host "  .\ubuntu-vm.ps1 shell" -ForegroundColor Gray
    Write-Host "  .\ubuntu-vm.ps1 ssh" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Доступ к VM:" -ForegroundColor Cyan
    Write-Host "  SSH: ssh ubuntu@localhost -p 2222 (пароль: ubuntu)" -ForegroundColor Gray
    Write-Host "  Web: http://localhost:8080" -ForegroundColor Gray
    Write-Host "  Shared folder: ./shared <-> /home/ubuntu/shared" -ForegroundColor Gray
    Write-Host ""
}

function Start-VM {
    Write-Host "Запуск Ubuntu VM..." -ForegroundColor Green
    
    # Создаем shared директорию если её нет
    if (!(Test-Path "shared")) {
        New-Item -ItemType Directory -Name "shared" -Force | Out-Null
        Write-Host "Создана директория shared для обмена файлами" -ForegroundColor Yellow
    }
    
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM успешно запущена!" -ForegroundColor Green
        Write-Host "Подключение:" -ForegroundColor Cyan
        Write-Host "  Shell: .\ubuntu-vm.ps1 shell" -ForegroundColor Gray
        Write-Host "  SSH:   ssh ubuntu@localhost -p 2222" -ForegroundColor Gray
    } else {
        Write-Host "Ошибка при запуске VM" -ForegroundColor Red
    }
}

function Stop-VM {
    Write-Host "Остановка Ubuntu VM..." -ForegroundColor Yellow
    docker-compose down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM остановлена" -ForegroundColor Green
    }
}

function Restart-VM {
    Write-Host "Перезапуск Ubuntu VM..." -ForegroundColor Yellow
    docker-compose restart
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM перезапущена" -ForegroundColor Green
    }
}

function Connect-Shell {
    Write-Host "Подключение к Ubuntu VM через bash..." -ForegroundColor Green
    Write-Host "Для выхода используйте команду 'exit'" -ForegroundColor Yellow
    docker exec -it $ContainerName /bin/bash
}

function Connect-SSH {
    Write-Host "SSH подключение к Ubuntu VM..." -ForegroundColor Green
    Write-Host "Пользователь: ubuntu, Пароль: ubuntu" -ForegroundColor Yellow
    Write-Host "Для выхода используйте команду 'exit'" -ForegroundColor Yellow
    ssh ubuntu@localhost -p 2222
}

function Build-VM {
    Write-Host "Сборка образа Ubuntu VM..." -ForegroundColor Green
    docker-compose build --no-cache
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Образ Ubuntu VM успешно собран!" -ForegroundColor Green
    }
}

function Remove-VM {
    Write-Host "Удаление Ubuntu VM..." -ForegroundColor Red
    $confirm = Read-Host "Вы уверены? Все данные будут потеряны! (y/N)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        docker-compose down -v --rmi all
        Write-Host "Ubuntu VM удалена" -ForegroundColor Green
    } else {
        Write-Host "Отменено" -ForegroundColor Yellow
    }
}

function Show-Status {
    Write-Host "Статус Ubuntu VM:" -ForegroundColor Green
    docker-compose ps
    Write-Host ""
    Write-Host "Docker образы:" -ForegroundColor Green
    docker images | Select-String "ubuntu"
    Write-Host ""
    Write-Host "Docker volumes:" -ForegroundColor Green
    docker volume ls | Select-String "docker"
}

function Show-Logs {
    Write-Host "Логи Ubuntu VM:" -ForegroundColor Green
    docker-compose logs -f
}

# Основная логика
switch ($Action) {
    "start" { Start-VM }
    "stop" { Stop-VM }
    "restart" { Restart-VM }
    "shell" { Connect-Shell }
    "ssh" { Connect-SSH }
    "build" { Build-VM }
    "remove" { Remove-VM }
    "status" { Show-Status }
    "logs" { Show-Logs }
    default { Show-Help }
}