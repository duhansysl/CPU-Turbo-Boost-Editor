@echo off
title CPU Boost Advanced Control

:: Admin kontrol
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Administrator privileges are required...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:menu
cls
echo =====================================
echo        CPU BOOST SETTING MENU
echo              @duhansysl
echo =====================================
echo.
echo - Default is "2", for disabling Turbo Boost type "0"
echo.
echo 0 - Disabled (0)
echo 1 - Enabled (1)
echo 2 - Aggressive (2)
echo 3 - Efficient Enabled (3)
echo 4 - Efficient Aggressive (4)
echo 5 - Show Current Boost Mode Value
echo 6 - Exit
echo.
set /p secim=Enter your choice: 

if "%secim%"=="0" goto set0
if "%secim%"=="1" goto set1
if "%secim%"=="2" goto set2
if "%secim%"=="3" goto set3
if "%secim%"=="4" goto set4
if "%secim%"=="5" goto show
if "%secim%"=="6" exit
goto menu

:set0
call :apply 0 Disabled
goto menu

:set1
call :apply 1 Enabled
goto menu

:set2
call :apply 2 Aggressive
goto menu

:set3
call :apply 3 Efficient Enabled
goto menu

:set4
call :apply 4 Efficient Aggressive
goto menu

:apply
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE %1
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE %1
powercfg -S SCHEME_CURRENT
echo.
echo Boost mode is set to %2.
pause
exit /b

:show
echo.
REM Powercfg çıktısını bir değişkene atıyoruz
for /f "tokens=*" %%i in ('powercfg -query SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE ^| find "Current AC Power Setting Index"') do set "current_val=%%i"

REM Hex değerini kontrol edip okunabilir karşılığını yazdıran IF blokları
echo %current_val% | find "0x00000000" >nul
if %errorlevel%==0 echo   Current AC Power Setting: Disabled

echo %current_val% | find "0x00000001" >nul
if %errorlevel%==0 echo   Current AC Power Setting: Enabled

echo %current_val% | find "0x00000002" >nul
if %errorlevel%==0 echo   Current AC Power Setting: Aggressive

echo %current_val% | find "0x00000003" >nul
if %errorlevel%==0 echo   Current AC Power Setting: Efficient Enabled

echo %current_val% | find "0x00000004" >nul
if %errorlevel%==0 echo   Current AC Power Setting: Efficient Aggressive

echo.
pause
goto menu
