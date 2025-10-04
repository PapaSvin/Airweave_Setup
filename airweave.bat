@echo off
if "%1"=="" goto help
if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="status" goto status
if "%1"=="logs" goto logs
if "%1"=="shell" goto shell

:help
echo.
echo Airweave Management Commands:
echo   .\airweave.bat start   - Start Airweave services
echo   .\airweave.bat stop    - Stop Airweave services  
echo   .\airweave.bat status  - Show Airweave status
echo   .\airweave.bat logs    - Show Airweave logs
echo   .\airweave.bat shell   - Open shell in Ubuntu VM
echo.
echo Access URLs:
echo   Frontend UI:  http://localhost:8080
echo   Backend API:  http://localhost:8001
echo   Temporal UI:  http://localhost:8088
echo.
goto end

:start
echo Starting Airweave...
docker exec -it -u ubuntu ubuntu-vm /bin/bash -c "cd ~/airweave && ./start.sh --noninteractive"
goto end

:stop
echo Stopping Airweave...
docker exec -it -u ubuntu ubuntu-vm /bin/bash -c "cd ~/airweave && docker compose -f docker/docker-compose.yml down"
goto end

:status
echo Airweave Status:
docker exec -it -u ubuntu ubuntu-vm /bin/bash -c "cd ~/airweave && docker ps --filter name=airweave"
goto end

:logs
echo Airweave Logs (press Ctrl+C to exit):
docker exec -it -u ubuntu ubuntu-vm /bin/bash -c "cd ~/airweave && docker compose -f docker/docker-compose.yml logs -f"
goto end

:shell
echo Connecting to Ubuntu VM...
powershell -ExecutionPolicy Bypass -File "vm.ps1" shell
goto end

:end