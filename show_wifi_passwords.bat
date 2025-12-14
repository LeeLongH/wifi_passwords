@echo off

REM UTF-8
chcp 65001 >nul
setlocal EnableDelayedExpansion

REM Output file
set OUTPUT=%USERPROFILE%\Downloads\wifi_passwords.txt

REM Clear file
echo. > "%OUTPUT%"

for /f "tokens=2* delims=:" %%A in (
    'netsh wlan show profiles 
    ^| findstr "All User Profile"') do (

    set "WIFI=%%A"
    REM Remove leading spaces
    set "WIFI=!WIFI:~1!"

    set "PASSWORD="

    for /f "tokens=2* delims=:" %%B in (
        'netsh wlan show profile name^="!WIFI!" key^=clear 
        ^| findstr "Key Content"') do (
            set PASSWORD=%%B
            set "PASSWORD=!PASSWORD:~1!"
        )

    set "PADDING=                              "
    set "WIFI_PAD=!PADDING!!WIFI!"
    set "WIFI_PAD=!WIFI_PAD:~-30!"

    REM password 1 means SSID has not password
    if "!PASSWORD!"=="1" (
        REM echo !WIFI_PAD! : >> "%OUTPUT%"
        echo !WIFI_PAD! : 
    ) else (
        REM echo !WIFI_PAD! : !PASSWORD! >> "%OUTPUT%"
        echo !WIFI_PAD! : !PASSWORD!
    )
)
echo.
REM echo Successfully written to %OUTPUT%
pause
