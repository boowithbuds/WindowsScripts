@echo off

:: Ejecutar como administrador

set "TNS_ADMIN=C:\Oracle_cliente11g"

setx TNS_ADMIN "%TNS_ADMIN%" /M

for /f "tokens=2,*" %%A in (
    'reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path'
) do set "SYSTEM_PATH=%%B"

setx PATH "%SYSTEM_PATH%;%TNS_ADMIN%" /M

echo.
echo Configuracion completada.
echo TNS_ADMIN=%TNS_ADMIN%
echo.
pause
