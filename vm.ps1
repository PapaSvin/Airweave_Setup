# Ubuntu VM Management Script
# This script provides convenient commands for managing Ubuntu container as VM

param(
    [Parameter(Position=0)]
    [ValidateSet("start", "stop", "restart", "shell", "ssh", "build", "remove", "status", "logs")]
    [string]$Action = "help"
)

$ContainerName = "ubuntu-vm"

function Show-Help {
    Write-Host ""
    Write-Host "Ubuntu VM Management Commands:" -ForegroundColor Green
    Write-Host "  start    - Start Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  stop     - Stop Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  restart  - Restart Ubuntu VM" -ForegroundColor Yellow
    Write-Host "  shell    - Connect to VM via bash" -ForegroundColor Yellow
    Write-Host "  ssh      - Connect to VM via SSH" -ForegroundColor Yellow
    Write-Host "  build    - Build Ubuntu VM image" -ForegroundColor Yellow
    Write-Host "  remove   - Remove container and image" -ForegroundColor Yellow
    Write-Host "  status   - Show VM status" -ForegroundColor Yellow
    Write-Host "  logs     - Show VM logs" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Usage examples:" -ForegroundColor Cyan
    Write-Host "  .\vm.ps1 start" -ForegroundColor Gray
    Write-Host "  .\vm.ps1 shell" -ForegroundColor Gray
    Write-Host "  .\vm.ps1 ssh" -ForegroundColor Gray
    Write-Host ""
    Write-Host "VM Access:" -ForegroundColor Cyan
    Write-Host "  SSH: ssh ubuntu@localhost -p 2222 (password: ubuntu)" -ForegroundColor Gray
    Write-Host "  Web: http://localhost:8080" -ForegroundColor Gray
    Write-Host "  Shared folder: ./shared <-> /home/ubuntu/shared" -ForegroundColor Gray
    Write-Host ""
}

function Start-VM {
    Write-Host "Starting Ubuntu VM..." -ForegroundColor Green
    
    # Create shared directory if it doesn't exist
    if (!(Test-Path "shared")) {
        New-Item -ItemType Directory -Name "shared" -Force | Out-Null
        Write-Host "Created shared directory for file exchange" -ForegroundColor Yellow
    }
    
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM started successfully!" -ForegroundColor Green
        Write-Host "Connection:" -ForegroundColor Cyan
        Write-Host "  Shell: .\vm.ps1 shell" -ForegroundColor Gray
        Write-Host "  SSH:   ssh ubuntu@localhost -p 2222" -ForegroundColor Gray
    } else {
        Write-Host "Error starting VM" -ForegroundColor Red
    }
}

function Stop-VM {
    Write-Host "Stopping Ubuntu VM..." -ForegroundColor Yellow
    docker-compose down
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM stopped" -ForegroundColor Green
    }
}

function Restart-VM {
    Write-Host "Restarting Ubuntu VM..." -ForegroundColor Yellow
    docker-compose restart
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM restarted" -ForegroundColor Green
    }
}

function Connect-Shell {
    Write-Host "Connecting to Ubuntu VM via bash..." -ForegroundColor Green
    Write-Host "Use 'exit' command to disconnect" -ForegroundColor Yellow
    docker exec -it $ContainerName /bin/bash
}

function Connect-SSH {
    Write-Host "SSH connection to Ubuntu VM..." -ForegroundColor Green
    Write-Host "User: ubuntu, Password: ubuntu" -ForegroundColor Yellow
    Write-Host "Use 'exit' command to disconnect" -ForegroundColor Yellow
    ssh ubuntu@localhost -p 2222
}

function Build-VM {
    Write-Host "Building Ubuntu VM image..." -ForegroundColor Green
    docker-compose build --no-cache
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Ubuntu VM image built successfully!" -ForegroundColor Green
    }
}

function Remove-VM {
    Write-Host "Removing Ubuntu VM..." -ForegroundColor Red
    $confirm = Read-Host "Are you sure? All data will be lost! (y/N)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        docker-compose down -v --rmi all
        Write-Host "Ubuntu VM removed" -ForegroundColor Green
    } else {
        Write-Host "Cancelled" -ForegroundColor Yellow
    }
}

function Show-Status {
    Write-Host "Ubuntu VM Status:" -ForegroundColor Green
    docker-compose ps
    Write-Host ""
    Write-Host "Docker images:" -ForegroundColor Green
    docker images | Select-String "ubuntu"
    Write-Host ""
    Write-Host "Docker volumes:" -ForegroundColor Green
    docker volume ls | Select-String "docker"
}

function Show-Logs {
    Write-Host "Ubuntu VM Logs:" -ForegroundColor Green
    docker-compose logs -f
}

# Main logic
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