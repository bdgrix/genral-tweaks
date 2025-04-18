@echo off
:: ================================
:: SYSTEM TWEAKS SCRIPT (SAFE MODE)
:: ================================

:: Requires Admin Privileges
:: Run as Administrator!

:: Check administrator privileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' NEQ '0' (
    echo Error: This script must be run as Administrator!
    echo Right-click the file and select "Run as administrator"
    pause
    exit /b
)

:MAIN_MENU
cls
echo.
echo ================================
echo          SYSTEM TWEAKS
echo ================================
echo.
echo 1. Create System Restore Point
echo 2. Apply System Tweaks
echo 3. Exit
echo.
set /p choice="Enter option [1-3]: "

if "%choice%"=="1" goto CREATE_RESTORE
if "%choice%"=="2" goto APPLY_TWEAKS
if "%choice%"=="3" exit /b

echo Invalid option! Please enter 1-3
timeout /t 2 >nul
goto MAIN_MENU

:: ───────────────────────────────
:: 🛑 Create System Restore Point
:: ───────────────────────────────
:CREATE_RESTORE
echo.
echo ================================
echo   Creating System Restore Point
echo ================================
echo.
powershell -Command "Checkpoint-Computer -Description 'Pre-Tweak State' -RestorePointType 'MODIFY_SETTINGS'"
if %errorlevel% neq 0 (
    echo Failed to create restore point!
    echo Please ensure you're running as Administrator
    pause
    exit /b
)
echo.
echo [✓] Restore point created successfully
pause
goto MAIN_MENU

:: ───────────────────────────────
:: 🚀 Apply System Tweaks
:: ───────────────────────────────
:APPLY_TWEAKS
echo.
echo ================================
echo   Applying System Optimizations
echo ================================
echo.
echo This may take several minutes...
echo Please do not interrupt the process...
timeout /t 3 >nul

:: Original tweaks content starts here (preserve all registry edits)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: 🔋 POWER & PERFORMANCE ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
color 0A
:: ---------------------------------------------------
:: Instructions:
:: - To exclude a tweak, add '::' at the beginning of the line.
:: - Review each tweak’s purpose in the comments before applying.
:: - Restart your system after applying for full effect.
:: ---------------------------------------------------

:: ---------------------------------------------------
:: Power and Processor Settings
:: Maximize CPU performance and power efficiency
:: ---------------------------------------------------

:: Disable power throttling for maximum performance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d 1 /f

: Set processor scheduling to favor foreground applications
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 0x00000024 /f

:: Disable C-states for better responsiveness
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Processor" /v "Capabilities" /t REG_DWORD /d 516198 /f

:: Disable hibernate to free up disk space
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d 0 /f

:: Disable idle power management
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power" /v "EnergyEstimationDisabled" /t REG_DWORD /d 1 /f

:: Set maximum processor state to 100%
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\bc5038f7-23e0-4960-96da-33abaf5935ec" /v "ValueMax" /t REG_DWORD /d 100 /f

:: Set minimum processor state to 100%
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\893dee8e-2bef-41e0-89c6-b55d0929964c" /v "ValueMin" /t REG_DWORD /d 100 /f

:: Disable core parking for maximum CPU usage
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" /v "ValueMin" /t REG_DWORD /d 0 /f

:: Enable high performance power plan
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

:: Disable USB selective suspend
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USB" /v "DisableSelectiveSuspend" /t REG_DWORD /d 1 /f

:: Disable link power management for PCIe devices
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5" /v "Attributes" /t REG_DWORD /d 1 /f

:: Disable power-saving mode for audio devices
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e96c-e325-11ce-bfc1-08002be10318}\0000\PowerSettings" /v "ConservationIdleTime" /t REG_DWORD /d 0 /f

:: Disable processor idle states
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\5d76a2ca-e8c0-402f-a133-2158492d58ad" /v "ValueMin" /t REG_DWORD /d 0 /f

:: ---------------------------------------------------
:: Memory Management
:: Optimize RAM and disk usage
:: ---------------------------------------------------

:: Disable paging cutive (keep drivers in RAM)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingcutive" /t REG_DWORD /d 1 /f

:: Increase system cache size
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "LargeSystemCache" /t REG_DWORD /d 1 /f

:: Disable Superfetch to reduce disk usage
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d 0 /f

:: Disable Prefetch to reduce disk usage
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f

:: Disable Windows write-cache buffer flushing
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisableWriteCombining" /t REG_DWORD /d 1 /f

:: Increase file system cache size
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "IoPageLockLimit" /t REG_DWORD /d 524288 /f
: Disable memory compression
eg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisableCompression" /t REG_DWORD /d 1 /f
:: Optimize NTFS performance
g add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisableLastAccessUpdate" /t REG_DWORD /d 1 /f
eg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem" /v "NtfsDisable8dot3NameCreation" /t REG_DWORD /d 1 /f
: Disable page file encryption
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurretControlSet\Control\Session Manager\Memory Management" /v "DisablePageFileEncryption" /t REG_DWORD /d 1 /
:: Optimize memory for applications
eg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "NonPagedPoolQuota" /t REG_DWORD /d 1048576 /f
:: ---------------------------------------------------
: Network Optimizations
:: Enhance internet speed and connectivity
:: ---------------------------------------------------

:: Disable Nagle's algorithm for better latency
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpNoDelay" /t REG_DWORD /d 1 /f

:: Increase network throttling index
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d 4294967295 /f

:: Disable Wi-Fi Sense
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseCredShared" /t REG_DWORD /d 0 /f

:: Disable TCP/IP auto-tuning
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "AutoTuningLevelLocal" /t REG_DWORD /d 0 /f

:: Increase DNS cache size
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "MaxCacheTtl" /t REG_DWORD /d 86400 /f

:: Enable direct cache access
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDCA" /t REG_DWORD /d 1 /f

:: Optimize TCP window size
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d 64 /f

:: Disable QoS packet scheduler
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\QoS" /v "DoNotUseQoSPktSched" /t REG_DWORD /d 1 /f

:: Disable IPv6 (if not needed)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" /v "DisabledComponents" /t REG_DWORD /d 255 /f

:: Disable NetBIOS over TCP/IP
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d 2 /f

:: Enable RSS (Receive Side Scaling)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableRSS" /t REG_DWORD /d 1 /f

:: Disable TCP timestamps
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d 1 /f

:: Increase maximum connections per server
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_MAXCONNECTIONSPER1_0SERVER" /v "explorer." /t REG_DWORD /d 10 /f

::----------------------------------------------------
:: Disable startup delay
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "StartupDelayInMSec" /t REG_DWORD /d 0 /f
:: ---------------------------------------------------
:: Service Disabling
:: Reduce background processes (use with caution)
:: ---------------------------------------------------

:: Disable Windows Search
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WSearch" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Superfetch/SysMain
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SysMain" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Print Spooler (if no printer)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d 4 /f


:: Disable Windows Update
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d 4 /f

:: Disable BITS
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\BITS" /v "Start" /t REG_DWORD /d 4 /f


:: Disable Diagnostic Policy Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DPS" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Windows Event Log
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\eventlog" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Remote Registry
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\RemoteRegistry" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Windows Time Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Windows Image Acquisition
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\stisvc" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Font Cache Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Camera Frame Server
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FrameServer" /v "Start" /t REG_DWORD /d 4 /f

:: Disable Biometric Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\WbioSrvc" /v "Start" /t REG_DWORD /d 4 /f


:: Disable Fax Service
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Fax" /v "Start" /t REG_DWORD /d 4 /f

:: ---------------------------------------------------
:: Privacy and Telemetry
:: Minimize data collection and tracking
:: ---------------------------------------------------

:: Disable telemetry
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f

:: Disable location services
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc" /v "Start" /t REG_DWORD /d 4 /f

:: Disable advertising ID
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f

:: Disable Wi-Fi Sense
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseOpen" /t REG_DWORD /d 0 /f

:: Disable Cortana
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f

:: Disable OneDrive
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f

:: Disable Windows tips
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f

:: Disable activity history
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f

:: Disable app diagnostics
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f

:: Disable feedback notifications
reg add "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f

:: Disable Windows Error Reporting
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f

:: Disable Windows Insider Program
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d 0 /f

:: Disable remote assistance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f


:: Disable search indexing
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f

:: Disable sync provider notifications
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d 0 /f

:: Disable tailored experiences
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d 0 /f

:: ---------------------------------------------------
:: Gaming Optimizations
:: Boost gaming performance
:: ---------------------------------------------------

:: Disable Game DVR
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f

:: Disable Game Bar
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d 0 /f

:: Set high GPU priority for games
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f

:: Set high CPU priority for games
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f

:: Disable fullscreen optimizations
reg add "HKEY_CURRENT_USER\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d 2 /f

:: Enable hardware-accelerated GPU scheduling
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f

:: Disable Xbox services
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XblAuthManager" /v "Start" /t REG_DWORD /d 4 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\XblGameSave" /v "Start" /t REG_DWORD /d 4 /f

:: Optimize multimedia system profile
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d 0 /f

:: Disable mouse acceleration
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f

:: Enable game mode (if preferred)
reg add "HKEY_CURRENT_USER\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f

:: ---------------------------------------------------
:: Mouse and Input Settings
:: Improve responsiveness and precision
:: ---------------------------------------------------

:: Enable raw input for mouse
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f

:: Increase keyboard repeat rate
reg add "HKEY_CURRENT_USER\Control Panel\Keyboard" /v "KeyboardSpeed" /t REG_SZ /d "31" /f

:: Reduce keyboard delay
reg add "HKEY_CURRENT_USER\Control Panel\Keyboard" /v "KeyboardDelay" /t REG_SZ /d "0" /f

:: Disable sticky keys
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f

:: Disable filter keys
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f

:: Disable toggle keys
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_SZ /d "58" /f

:: Disable mouse keys
reg add "HKEY_CURRENT_USER\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_SZ /d "0" /f

:: Enhance pointer precision (optional)
reg add "HKEY_CURRENT_USER\Control Panel\Mouse" /v "MouseHoverTime" /t REG_SZ /d "0" /f

:: ---------------------------------------------------
:: Miscellaneous System Tweaks
:: General system optimizations
:: ---------------------------------------------------

:: Disable automatic maintenance
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d 1 /f


:: Disable Windows Update auto-restart
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d 1 /f



:: Disable UAC
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f

:: Disable automatic driver updates
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d 0 /f



:: Disable Action Center notifications
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f

:: Disable boot log
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v "BootLog" /t REG_DWORD /d 0 /f


:: Optimize boot performance
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetchOnBoot" /t REG_DWORD /d 0 /f

:: ---------------------------------------------------
:: Security Tweaks
:: Enhance system security
:: ---------------------------------------------------

:: Disable SMBv1 (old and insecure protocol)
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d 0 /f

:: Enable DEP (Data cution Prevention)
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoDatacutionPrevention" /t REG_DWORD /d 0 /f

:: Disable autorun for removable drives
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoAutorun" /t REG_DWORD /d 1 /f

:: Disable remote desktop
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f





:: ---------------------------------------------------
:: DirectX Tweaks
:: Enhance DirectX performance
:: ---------------------------------------------------



Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "CreateGdiPrimaryOnSlaveGPU" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DriverSupportsCddDwmInterop" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncDxAccess" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddSyncGPUAccess" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCddWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkCreateSwapChain" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkFreeGpuVirtualAddress" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkOpenSwapChain" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkShareSwapChainObject" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "DxgkWaitForVerticalBlankEvent2" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "SwapChainBackBuffer" /t REG_DWORD /d "1" /f
Reg add "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v "TdrResetFromTimeoutAsync" /t REG_DWORD /d "1" /f

:: D3D11 - D3D12 tweaks
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_ENABLE_UNSAFE_COMMAND_BUFFER_REUSE" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_ENABLE_RUNTIME_DRIVER_OPTIMIZATIONS" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_RESOURCE_ALIGNMENT" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_MULTITHREADED" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_MULTITHREADED" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_DEFERRED_CONTEXTS" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_DEFERRED_CONTEXTS" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_ALLOW_TILING" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D11_ENABLE_DYNAMIC_CODEGEN" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_ALLOW_TILING" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_CPU_PAGE_TABLE_ENABLED" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_HEAP_SERIALIZATION_ENABLED" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_MAP_HEAP_ALLOCATIONS" /t REG_DWORD /d "1" /f
Reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v "D3D12_RESIDENCY_MANAGEMENT_ENABLED" /t REG_DWORD /d "1" /f

:: DWMAdjustablesd-jdallmann 
cd %systemroot%\system32
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v SuperWetEnabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v SDRBoostPercentOverride /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v ResampleInLinearSpace /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v OneCoreNoDWMRawGameController /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v MPCInputRouterWaitForDebugger /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v InteractionOutputPredictionDisabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v InkGPUAccelOverrideVendorWhitelist /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableRenderPathTestMode /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v FlattenVirtualSurfaceEffectInput /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableCpuClipping /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisallowNonDrawListRendering /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableProjectedShadowsRendering /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableProjectedShadows /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableLockingMemory /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableHologramCompositor /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableDeviceBitmaps /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DebugFailFast /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DDisplayTestMode /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableLockingMemory /t REG_DWORD /d 1 /f

:: DWMImmediateRender-Kizzimo
SETLOCAL ENABLEEXTENSIONS
cd %windir%\system32


reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v UseHWDrawListEntriesOnWARP /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v ResampleModeOverride /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v RenderThreadWatchdogTimeoutMilliseconds /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v ParallelModePolicy /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableResizeOptimization /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableMegaRects /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableFrontBufferRenderChecks /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableEffectCaching /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableDesktopOverlays /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnablePrimitiveReordering /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v MaxD3DFeatureLevel /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v OverlayQualifyCount /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v OverlayDisqualifyCount /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v ResizeTimeoutModern /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v ResizeTimeoutGdi /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableResizeOptimization /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableEffectCaching /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v HighColor /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableDeviceBitmaps /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableCpuClipping /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableDrawListCaching /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v AnimationsShiftKey /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v AnimationAttributionEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v EnableCommonSuperSets /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\WINDOWS\DWM" /v DisableAdvancedDirectFlip /t REG_DWORD /d 1 /f
ENDLOCAL
taskkill /f /im dwm.exe
timeout /t 5
start %windir%\system32\dwm.exe


:: InterruptSteering
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v InterruptSteeringDisabled /t REG_DWORD /d 1 /f


:: DPC Kernel Tweaks
echo Adding values to the Registry...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogProfileOffset /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcTimeout /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v IdealDpcRate /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MaximumDpcQueueDepth /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MinimumDpcRate /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v DpcWatchdogPeriod /t REG_DWORD /d 0 /f

:: Kernel Tweaks
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaxDynamicTickDuration" /t REG_DWORD /d "10" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MaximumSharedReadyQueueSize" /t REG_DWORD /d "128" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "BufferSize" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueWorkItem" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueWorkItemToNode" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueWorkItemEx" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoQueueThreadIrp" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ExTryQueueWorkItem" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "ExQueueWorkItem" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "IoEnqueueIrp" /t REG_DWORD /d "32" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "XMMIZeroingEnable" /t REG_DWORD /d "0" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "UseNormalStack" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "UseNewEaBuffering" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "StackSubSystemStackSize" /t REG_DWORD /d "65536" /f

::SplitLargeCaches
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v SplitLargeCaches /t REG_DWORD /d 1 /f

::Thread DPC
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v ThreadDpcEnable /t REG_DWORD /d 0 /f

::Max Pending Interrupts
rem Founder: kizzimo

rem === CPU Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_IDLE_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_BOOST_POLICY /t REG_SZ /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_MAX_FREQUENCY /t REG_SZ /d 100 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_INTERRUPT_BALANCE_POLICY /t REG_SZ /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v MKL_DEBUG_CPU_TYPE /t REG_SZ /d 10 /f

rem === I/O Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v IO_COMPLETION_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v IO_REQUEST_LIMIT /t REG_SZ /d 1024 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DISK_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v IO_PRIORITY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DISK_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v IO_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === Power Management and Performance ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v POWER_THROTTLE_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v POWER_IDLE_TIMEOUT /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v CPU_POWER_POLICY /t REG_SZ /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DISABLE_DYNAMIC_TICK /t REG_SZ /d yes /f

rem === Memory and Latency Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v MEMORY_MAX_ALLOCATION /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v MEMORY_LATENCY_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v MEMORY_PREFETCH_POLICY /t REG_SZ /d 2 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v MEMORY_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DWM_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DWM_COMPOSITOR_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === Network and Connectivity Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_BUFFER_SIZE /t REG_SZ /d 512 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_INTERRUPT_COALESCING /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === Miscellaneous Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v TIMER_RESOLUTION /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v THREAD_SCHEDULER_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v GPU_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === Network Adapter Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_ADAPTER_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_ADAPTER_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_ADAPTER_INTERRUPT_MODERATION /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v NETWORK_ADAPTER_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === Storage Device Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v STORAGE_DEVICE_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v STORAGE_DEVICE_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v STORAGE_DEVICE_COMPLETION_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v STORAGE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v STORAGE_DEVICE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === USB Device Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v USB_DEVICE_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v USB_DEVICE_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v USB_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v USB_DEVICE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === PCIe Device Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PCIE_DEVICE_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PCIE_DEVICE_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PCIE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PCIE_DEVICE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === GPU Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v GPU_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v GPU_MAX_PENDING_COMPUTE /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v GPU_MAX_PENDING_RENDER /t REG_SZ /d 0 /f

rem === Audio Device Performance Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v AUDIO_DEVICE_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v AUDIO_DEVICE_BUFFER_SIZE /t REG_SZ /d 512 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v AUDIO_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v AUDIO_DEVICE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

rem === General Device Tuning ===
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DEVICE_PENDING_INTERRUPTS /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DEVICE_MAX_PENDING_IO /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DEVICE_COMPLETION_POLICY /t REG_SZ /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v DEVICE_MAX_PENDING_INTERRUPTS /t REG_SZ /d 0 /f

:: [Keep all your original registry tweaks here]
:: [All original tweaks content between POWER & PERFORMANCE and FINAL MESSAGE]

:: Final message after all tweaks
echo.
echo ================================
echo       All Tweaks Applied!
echo ================================
echo.
echo Please restart your system to complete optimizations
pause
exit /b
