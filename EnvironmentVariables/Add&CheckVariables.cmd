@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "TNS_ADMIN=C:\Oracle_cliente11g"

echo ==========================================
echo   Configuracion Oracle - Variables sistema
echo ==========================================
echo.

:: Comprobar permisos de administrador
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Este script debe ejecutarse como ADMINISTRADOR.
    echo.
    echo Haz clic derecho sobre el .CMD y selecciona:
    echo "Ejecutar como administrador"
    pause
    exit /b 1
)

:: Crear / actualizar TNS_ADMIN
echo Configurando TNS_ADMIN...
setx TNS_ADMIN "%TNS_ADMIN%" /M >nul

if %errorlevel% neq 0 (
    echo ERROR al crear TNS_ADMIN.
    pause
    exit /b 1
)

echo TNS_ADMIN = %TNS_ADMIN%

:: Obtener PATH del sistema
for /f "tokens=2,*" %%A in (
    'reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul'
) do set "SYSTEM_PATH=%%B"

:: Comprobar si ya existe C:\Oracle_cliente11g
echo !SYSTEM_PATH! | findstr /I /C:"%TNS_ADMIN%" >nul

if %errorlevel% equ 0 (
    echo C:\Oracle_cliente11g ya existe en el PATH.
) else (
    echo Añadiendo C:\Oracle_cliente11g al PATH...
    setx PATH "!SYSTEM_PATH!;%TNS_ADMIN%" /M >nul

    if !errorlevel! neq 0 (
        echo ERROR al modificar el PATH.
        pause
        exit /b 1
    )

    echo Ruta añadida correctamente.
)

echo.
echo ==========================================
echo   CONFIGURACION COMPLETADA
echo ==========================================
echo.
echo TNS_ADMIN:
echo   %TNS_ADMIN%
echo.
echo PATH:
echo   C:\Oracle_cliente11g añadido al PATH del sistema.
echo.
echo IMPORTANTE:
echo Las aplicaciones ya abiertas no veran las
echo nuevas variables hasta que se reinicien.
echo.

pause
