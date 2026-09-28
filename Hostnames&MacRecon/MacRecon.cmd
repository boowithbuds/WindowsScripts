@echo off
setlocal EnableDelayedExpansion
title RECOLECTOR DE EQUIPOS

REM ============================================================
REM CONFIGURACION
REM ============================================================

set "ARCHIVO=%~dp0equipos.csv"

REM ============================================================
REM CREAR CSV SI NO EXISTE
REM ============================================================

if not exist "%ARCHIVO%" (
    echo Fecha;Hora;Hostname;Tipo;MAC>"%ARCHIVO%"
)

REM ============================================================
REM OBTENER MAC ETHERNET
REM ============================================================

set "MAC_ETH="

for /f "tokens=2 delims==" %%A in ('wmic nic where "NetConnectionID='Ethernet' and NetEnabled=true" get MACAddress /value 2^>nul ^| find "="') do (
    if not defined MAC_ETH set "MAC_ETH=%%A"
)

REM ============================================================
REM OBTENER MAC WIFI
REM ============================================================

set "MAC_WIFI="

for /f "tokens=2 delims==" %%A in ('wmic nic where "NetConnectionID='Wi-Fi' and NetEnabled=true" get MACAddress /value 2^>nul ^| find "="') do (
    if not defined MAC_WIFI set "MAC_WIFI=%%A"
)

REM ============================================================
REM PANTALLA PRINCIPAL
REM ============================================================

:menu

cls

echo.
echo ============================================================
echo                    RECOLECTOR DE EQUIPOS
echo ============================================================
echo.
echo Hostname actual:
echo.
echo     %COMPUTERNAME%
echo.
echo ------------------------------------------------------------
echo.

if defined MAC_ETH (
    echo [1] ETHERNET
    echo.
    echo     MAC: %MAC_ETH%
    echo.
) else (
    echo [1] ETHERNET
    echo.
    echo     No detectado
    echo.
)

if defined MAC_WIFI (
    echo [2] WI-FI
    echo.
    echo     MAC: %MAC_WIFI%
    echo.
) else (
    echo [2] WI-FI
    echo.
    echo     No detectado
    echo.
)

echo ------------------------------------------------------------
echo.
echo [3] Guardar Ethernet
echo [4] Guardar Wi-Fi
echo [5] Guardar ambas
echo [6] Mostrar listado guardado
echo [7] Salir
echo.
echo ============================================================
echo.

choice /c 34567 /n /m "Selecciona una opcion: "

if errorlevel 5 goto :salir
if errorlevel 4 goto :mostrar
if errorlevel 3 goto :guardar_ambas
if errorlevel 2 goto :guardar_wifi
if errorlevel 1 goto :guardar_ethernet

REM ============================================================
REM GUARDAR ETHERNET
REM ============================================================

:guardar_ethernet

if not defined MAC_ETH (
    echo.
    echo No se ha detectado una conexion Ethernet activa.
    echo.
    pause
    goto :menu
)

call :guardar "Ethernet" "%MAC_ETH%"

echo.
echo Ethernet procesado.
echo.
pause
goto :menu


REM ============================================================
REM GUARDAR WIFI
REM ============================================================

:guardar_wifi

if not defined MAC_WIFI (
    echo.
    echo No se ha detectado una conexion Wi-Fi activa.
    echo.
    pause
    goto :menu
)

call :guardar "Wi-Fi" "%MAC_WIFI%"

echo.
echo Wi-Fi procesado.
echo.
pause
goto :menu


REM ============================================================
REM GUARDAR AMBAS
REM ============================================================

:guardar_ambas

if defined MAC_ETH (
    call :guardar "Ethernet" "%MAC_ETH%"
) else (
    echo.
    echo Ethernet no detectado.
)

if defined MAC_WIFI (
    call :guardar "Wi-Fi" "%MAC_WIFI%"
) else (
    echo.
    echo Wi-Fi no detectado.
)

echo.
echo Proceso terminado.
echo.
pause
goto :menu


REM ============================================================
REM FUNCION PARA GUARDAR
REM ============================================================

:guardar

set "TIPO=%~1"
set "MAC=%~2"

REM Comprobar si la MAC ya existe en el CSV

findstr /i /c:";%MAC%" "%ARCHIVO%" >nul 2>&1

if not errorlevel 1 (
    echo.
    echo --------------------------------------------------------
    echo YA EXISTE EN EL LISTADO
    echo.
    echo Hostname: %COMPUTERNAME%
    echo Tipo:     %TIPO%
    echo MAC:      %MAC%
    echo --------------------------------------------------------
    exit /b
)

REM Obtener fecha y hora

set "FECHA=%date%"
set "HORA=%time:~0,8%"

REM Guardar

>>"%ARCHIVO%" echo %FECHA%;%HORA%;%COMPUTERNAME%;%TIPO%;%MAC%

echo.
echo --------------------------------------------------------
echo GUARDADO
echo.
echo Hostname: %COMPUTERNAME%
echo Tipo:     %TIPO%
echo MAC:      %MAC%
echo.
echo Archivo:
echo %ARCHIVO%
echo --------------------------------------------------------

exit /b


REM ============================================================
REM MOSTRAR LISTADO
REM ============================================================

:mostrar

cls

echo.
echo ============================================================
echo                     LISTADO ACTUAL
echo ============================================================
echo.

type "%ARCHIVO%"

echo.
echo ============================================================
echo.

pause
goto :menu


REM ============================================================
REM SALIR
REM ============================================================

:salir

cls

echo.
echo ============================================================
echo.
echo   Listado guardado en:
echo.
echo   %ARCHIVO%
echo.
echo   Hasta luego.
echo.
echo ============================================================
echo.

pause
exit /b
