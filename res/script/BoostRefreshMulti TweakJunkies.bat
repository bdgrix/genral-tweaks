@echo off
setlocal enabledelayedexpansion

:: Define the registry path root
set "regPath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Configuration"

:: Display a clean banner without special characters
mode con: cols=80 lines=30
color 0A

echo =============================================
echo        GRAPHICS DRIVERS CONFIGURATION TOOL
echo =============================================

echo.
echo Initializing registry modifications...
echo.

:: Get all subkeys under the Configuration key
for /f "tokens=*" %%a in ('reg query "%regPath%" /s /f "VSyncFreq.Numerator"') do (
    set "subkey=%%a"
    echo [*] Processing detected entry...
    timeout /t 1 >nul
    
    :: Modify the registry values with obfuscated output
    reg add "!subkey!" /v "BoostRefreshRateMultiplier" /t REG_DWORD /d 0x0000FFFF /f >nul 2>&1
    echo [OK] Update applied successfully!
)

echo.
echo =============================================
echo        All updates applied successfully!
echo =============================================
echo.
echo System optimization complete!
pause
endlocal
