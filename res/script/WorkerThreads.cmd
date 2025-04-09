@echo off
:: Made by PRDGY_Aceツグ
rem # https://www.overclock.net/threads/additionalcriticalworkerthreads.1254416/
rem # https://martin77s.wordpress.com/2010/04/05/performance-tuning-your-windows-server-part-3/
rem # https://www.wilderssecurity.com/threads/increase-number-of-threads-per-process.317532/
rem # 4 threads = 1 default critical thread , 2 additional critical threads and 1 thread left for background processes / AdditionalCriticalWorkerThreads = 2
rem # 8 threads = 2 default critical thread , 4 additional critical threads and 2 thread left for background processes / AdditionalCriticalWorkerThreads = 4
rem # 12 threads = 3 default critical thread , 6 additional critical threads and 3 thread left for background processes / AdditionalCriticalWorkerThreads = 6
rem # 16 threads = 4 default critical thread , 8 additional critical threads and 4 thread left for background processes / AdditionalCriticalWorkerThreads = 8
rem # 32 threads = 8 default critical thread , 16 additional critical threads and 8 thread left for background processes / AdditionalCriticalWorkerThreads = 16
rem # Delayed Worker Threads - Threads in this queue have a lower priority and therefore a higher latency because they must compete with other processing for CPU time

rem Get the number of logical processors (CPU threads)
for /f "tokens=2 delims==" %%a in ('wmic cpu get NumberOfLogicalProcessors /value') do set threadCount=%%a

rem Calculate AdditionalCriticalWorkerThreads
rem Formula: (threadCount / 2) - (threadCount / 8)
set /a "additionalThreads=threadCount/2"
set /a "backgroundThreads=threadCount/8"
set /a "criticalThreads=additionalThreads-backgroundThreads"

rem Apply the calculated AdditionalCriticalWorkerThreads
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "AdditionalCriticalWorkerThreads" /t REG_DWORD /d "%criticalThreads%" /f
echo AdditionalCriticalWorkerThreads set to %criticalThreads%.

rem Set AdditionalDelayedWorkerThreads to 0 (default)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "AdditionalDelayedWorkerThreads" /t REG_DWORD /d "0" /f
echo AdditionalDelayedWorkerThreads set to 0.
pause