@echo off
title CPU Boost Advanced Control

if "%~1"==":admin" goto :menu
powershell -Command "Start-Process '%~f0' -ArgumentList ':admin' -Verb RunAs" & exit

:menu
cls
echo =====================================
echo     CPU BOOST SETTING MENU V1.2
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
set /p choice=Enter your choice: 

if "%choice%"=="0" goto set0
if "%choice%"=="1" goto set1
if "%choice%"=="2" goto set2
if "%choice%"=="3" goto set3
if "%choice%"=="4" goto set4
if "%choice%"=="5" goto show
if "%choice%"=="6" exit
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
for /f "tokens=*" %%i in ('powercfg -query SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE ^| find "Current AC Power Setting Index"') do set "current_val=%%i"

echo %current_val% | find "0x00000000" >nul
if %errorlevel%==0 echo   Current Turbo Boost Setting: Disabled

echo %current_val% | find "0x00000001" >nul
if %errorlevel%==0 echo   Current Turbo Boost Setting: Enabled

echo %current_val% | find "0x00000002" >nul
if %errorlevel%==0 echo   Current Turbo Boost Setting: Aggressive

echo %current_val% | find "0x00000003" >nul
if %errorlevel%==0 echo   Current Turbo Boost Setting: Efficient Enabled

echo %current_val% | find "0x00000004" >nul
if %errorlevel%==0 echo   Current Turbo Boost Setting: Efficient Aggressive

echo.
pause
goto menu
