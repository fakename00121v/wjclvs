@echo off
setlocal

set SINGBOX_VERSION=1.9.7
set SINGBOX_ZIP=sing-box-%SINGBOX_VERSION%-windows-amd64-legacy.zip
set SINGBOX_URL=https://github.com/SagerNet/sing-box/releases/download/v%SINGBOX_VERSION%/%SINGBOX_ZIP%
set CONFIG_URL=https://raw.githubusercontent.com/fakename00121v/wjclvs/refs/heads/main/download/config.json

rem Check if sing-box.exe exists
if not exist "sing-box.exe" (
    echo sing-box.exe not found
    
    echo Downloading sing-box %SINGBOX_VERSION%...
    curl -L -o "%SINGBOX_ZIP%" "%SINGBOX_URL%"
    if errorlevel 1 (
        echo ERROR: Failed to download sing-box!
        pause
        exit /b 1
    )
    echo Download complete
    
    rem Extract zip
    echo Extracting sing-box...
    tar -xf "%SINGBOX_ZIP%"
    if errorlevel 1 (
        echo ERROR: Failed to extract sing-box!
        pause
        exit /b 1
    )
    
    rem Move sing-box.exe from subfolder to current directory
    move "sing-box-%SINGBOX_VERSION%-windows-amd64-legacy\sing-box.exe" "sing-box.exe" >nul
    
    rem Clean up
    rmdir /s /q "sing-box-%SINGBOX_VERSION%-windows-amd64-legacy"
    del "%SINGBOX_ZIP%"
    
    echo Extraction complete
)

rem Check if config.json exists
if not exist "config.json" (
    echo config.json not found!
    echo Downloading config.json...
    curl -L -o "config.json" "%CONFIG_URL%"
    if errorlevel 1 (
        echo ERROR: Failed to download config.json!
        pause
        exit /b 1
    )
    echo Config downloaded successfully
)

rem Start sing-box VLESS server
echo Starting sing-box server on port 3084...
start "" /b sing-box.exe run -c config.json

rem Check if sing-box started successfully
timeout /t 2 /nobreak >nul
tasklist /FI "IMAGENAME eq sing-box.exe" 2>NUL | find /I /N "sing-box.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] sing-box server is running
    echo.
    echo ========================================
    echo  Your PC IP: ipconfig
    echo  Server port: 3084
    echo ========================================
    echo.
    echo Press any key to stop the server...
    pause >nul
) else (
    echo [ERROR] sing-box failed to start!
    pause
    exit /b 1
)

rem Kill sing-box
echo Stopping sing-box...
taskkill /im sing-box.exe /f >nul 2>&1

echo Done!
timeout /t 2 /nobreak >nul

endlocal
exit