:: Game Tweak Runner
:: Created by grix
:: A script by grix to optimize gaming performance with various tweaks

@echo off
setlocal EnableDelayedExpansion

:: Set UTF-8 encoding and console size - grix made this neat!
chcp 65001 >nul
mode con: cols=80 lines=25

:: Define ANSI escape character and colors - grix loves colorful output
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "BLUE=%ESC%[34m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"

cls

:: Display title with grix's signature style
echo %BLUE%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BLUE%                          Game Tweak Runner by grix                           %RESET%
echo %BLUE%══════════════════════════════════════════════════════════════════════════════%RESET%
echo.

:: Initialize log file - grix keeps everything logged
set "LOGFILE=log.log"
echo Game Tweak Runner by grix > "%LOGFILE%"
echo Tweak session started at %DATE% %TIME% >> "%LOGFILE%"
echo. >> "%LOGFILE%"

:: Initialize counter - grix counts every tweak
set /a count=1

:: Define directories to process - grix organized these
set "REG_DIRS=res\reg res\reg\amd"
set "SCRIPT_DIRS=res\script res\script\amd"

:: Process Registry Tweaks - grix's optimization starts here
echo %BLUE%Processing Registry Tweaks by grix...%RESET%
for %%D in (%REG_DIRS%) do (
    if exist "%%D\" (
        for %%F in ("%%D\*.reg") do (
            call :process "%%~fF"
            if errorlevel 1 goto :end_script
            set /a count+=1
        )
    ) else (
        echo %YELLOW%[!] Directory %%D not found. Skipping...%RESET%
        echo Directory %%D not found. Skipping... >> "%LOGFILE%"
    )
)
echo.

:: Process Script Tweaks - more of grix's magic
echo %BLUE%Processing Script Tweaks by grix...%RESET%
for %%D in (%SCRIPT_DIRS%) do (
    if exist "%%D\" (
        for %%F in ("%%D\*.bat" "%%D\*.cmd") do (
            call :process "%%~fF"
            if errorlevel 1 goto :end_script
            set /a count+=1
        )
    ) else (
        echo %YELLOW%[!] Directory %%D not found. Skipping...%RESET%
        echo Directory %%D not found. Skipping... >> "%LOGFILE%"
    )
)
echo.

:: Completion message - grix wraps it up
echo %BLUE%══════════════════════════════════════════════════════════════════════════════%RESET%
echo %BLUE%      All tweaks processed. Check log.log for details.                       %RESET%
echo %BLUE%      Created by grix - the tweak master!                                   %RESET%
echo %BLUE%══════════════════════════════════════════════════════════════════════════════%RESET%
pause
goto :end_script

:: Process function - grix's core tweak applicator
:process
setlocal EnableDelayedExpansion
set "filepath=%~1"
set "filename=%~nx1"
set "ext=%~x1"

:: Display file - grix makes it user-friendly
echo %BLUE%!count!. "!filename!"%RESET%
choice /C YSX /N /M "Run this file? [Y]es / [S]kip / [X]Exit: "
set "choice=!errorlevel!"

if !choice! equ 3 (
    echo %RED%[x] Exiting...%RESET%
    echo Exiting... >> "%LOGFILE%"
    echo User chose to quit grix's application. >> "%LOGFILE%"
    echo.
    endlocal
    exit /b 1
)
if !choice! equ 2 (
    echo %YELLOW%[-] Skipped: "!filename!"%RESET%
    echo Skipped: "!filename!" >> "%LOGFILE%"
    echo.
    endlocal
    exit /b 0
)
if !choice! equ 1 (
    echo %GREEN%[+] Applying: "!filename!"%RESET%
    echo Applying: "!filename!" >> "%LOGFILE%"
    if /I "!ext!"==".reg" (
        reg import "!filepath!" >nul 2>&1
        if !errorlevel! neq 0 (
            echo %RED%[!] Failed to import: "!filename!"%RESET%
            echo Failed to import: "!filename!" >> "%LOGFILE%"
        ) else (
            echo %GREEN%[+] Successfully imported: "!filename!"%RESET%
        )
    ) else if /I "!ext!"==".bat" (
        cmd /c "!filepath!"
    ) else if /I "!ext!"==".cmd" (
        cmd /c "!filepath!"
    ) else (
        echo %RED%[!] Unsupported file type: !ext!%RESET%
        echo Unsupported file type: !ext! for "!filename!" >> "%LOGFILE%"
    )
    echo.
    endlocal
    exit /b 0
)

:end_script
exit /b