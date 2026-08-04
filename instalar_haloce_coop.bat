@echo off
setlocal enabledelayedexpansion
title HALO CE COOP - x3btc
cls

:: Obtener ESC para ANSI
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "R=!ESC![91m"
set "DR=!ESC![31m"
set "G=!ESC![92m"
set "Y=!ESC![93m"
set "W=!ESC![97m"
set "GR=!ESC![90m"
set "C=!ESC![96m"
set "Z=!ESC![0m"
set "B=!ESC![1m"

echo.
echo !R!!B!  ##  ##  #####  ##      ######      ######  #######!Z!
echo !R!!B!  ##  ##  ##  ## ##      ##   ##     ##      ##!Z!
echo !DR!!B!  #######  #####  ##      ##   ##     ##      #####!Z!
echo !DR!!B!  ##  ##  ##  ## ##      ##   ##     ##      ##!Z!
echo !R!!B!  ##  ##  ##  ## #######  ######      ######  #######!Z!
echo.
echo !DR!  ========================================================!Z!
echo !DR!  ##!Z!   !W!!B!C O O P   E V O L V E D   I N S T A L L E R!Z!   !DR!##!Z!
echo !DR!  ========================================================!Z!
echo.
echo                         !DR!!B!by x3btc!Z!
echo !GR!  --------------------------------------------------------!Z!
echo.

:: Verificar admin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  !R![X]!Z! Necesita permisos de Administrador.
    echo  !Y![!]!Z! Clic derecho -^> Ejecutar como administrador
    pause & exit /b 1
)
echo  !G![OK]!Z! Administrador confirmado.
echo.

set "DOWNLOADS=%~dp0downloads"
set "KEY64=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo CE"
set "KEY32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Halo CE"
set "DEF_PATH=C:\Program Files (x86)\Microsoft Games\Halo Custom Edition"
set "INSTALLED=0"
set "OUTDATED=0"
set "HCE_PATH="
mkdir "%DOWNLOADS%" 2>nul

:: =============================================
:: PASO 1 - DETECCION
:: =============================================
echo  !C![1/5]!Z! !B!Detectando Halo Custom Edition...!Z!
echo  !GR!  --------------------------------------------------------!Z!
echo.

for /f "tokens=2*" %%a in ('reg query "%KEY64%" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
if not defined HCE_PATH for /f "tokens=2*" %%a in ('reg query "%KEY32%" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
if not defined HCE_PATH if exist "%DEF_PATH%\halo.exe" set "HCE_PATH=%DEF_PATH%"

if defined HCE_PATH (
    set "INSTALLED=1"
    echo  !G!  [ENCONTRADO]!Z! %HCE_PATH%
    echo.
    for /f "delims=" %%v in ('powershell -NoProfile -Command "(Get-Item '!HCE_PATH!\halo.exe').VersionInfo.FileVersion" 2^>nul') do set "VER=%%v"
    if defined VER (
        echo  !GR!  Version instalada :!Z! !W!!VER!!Z!
        echo !VER! | findstr /C:"1.0.10" >nul 2>&1
        if !errorLevel! neq 0 (
            set "OUTDATED=1"
            echo  !Y!  [DESACTUALIZADA]!Z! Se aplicara parche 1.0.10
        ) else (
            echo  !G!  [OK]!Z! Version 1.0.10 - actualizada
        )
    ) else (
        set "OUTDATED=1"
        echo  !Y!  [?]!Z! Version no verificable - parche preventivo
    )
) else (
    echo  !Y!  [NO ENCONTRADO]!Z! Se instalara desde cero
)
echo.

:: =============================================
:: PASO 2 - INSTALAR HALO CE
:: =============================================
echo  !C![2/5]!Z! !B!Halo CE Custom Edition!Z!
echo  !GR!  --------------------------------------------------------!Z!
echo.

if "%INSTALLED%"=="1" (
    if "%OUTDATED%"=="0" (
        echo  !G!  [OK]!Z! Ya instalado y actualizado - saltando
        echo.
        goto paso3
    )
    echo  !Y!  [->]!Z! Desactualizado - solo se aplica parche
    echo.
    goto paso3
)

set "HCE_EXE=%DOWNLOADS%\hce_setup.exe"

:: Intentar descarga y verificar que sea EXE valido (header MZ = 4D5A)
if not exist "%HCE_EXE%" (
    echo  !W!  [v]!Z! Descargando Halo CE... (puede tardar unos minutos)
    echo.

    :: Fuente 1: GitHub release de ce-setup (Sledmine)
    powershell -NoProfile -Command "try { $r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/ce-setup/releases/latest'; $a=$r.assets|?{$_.name -like '*.exe'}|select -First 1; if($a){ Invoke-WebRequest $a.browser_download_url -OutFile '%HCE_EXE%' -UseBasicParsing; Write-Host '  Descargado desde GitHub:' $a.name } else { Write-Host '  Sin assets en GitHub' } } catch { Write-Host '  GitHub fallo:' $_.Exception.Message }" 2>nul

    :: Verificar si es EXE real (header MZ)
    if exist "%HCE_EXE%" (
        powershell -NoProfile -Command "$b=[System.IO.File]::ReadAllBytes('%HCE_EXE%'); if($b[0] -eq 77 -and $b[1] -eq 90){ Write-Host 'VALID_EXE' } else { Write-Host 'INVALID'; Remove-Item '%HCE_EXE%' -Force }" 2>nul | findstr /C:"INVALID" >nul 2>&1
        if !errorLevel! equ 0 (
            echo  !Y!  GitHub retorno archivo invalido - descartando!Z!
            del "%HCE_EXE%" 2>nul
        )
    )

    :: Fuente 2: HaloMaps directo
    if not exist "%HCE_EXE%" (
        echo  !W!  [v]!Z! Intentando HaloMaps.org...
        curl -L --max-time 300 --progress-bar -A "Mozilla/5.0" -o "%HCE_EXE%" "http://hce.halomaps.org/files/hce_setup.exe" 2>nul
        :: Verificar EXE
        if exist "%HCE_EXE%" (
            powershell -NoProfile -Command "$b=[System.IO.File]::ReadAllBytes('%HCE_EXE%'); if($b[0] -ne 77 -or $b[1] -ne 90){ Remove-Item '%HCE_EXE%' -Force; Write-Host 'BORRADO' }" 2>nul
        )
    )
)

if exist "%HCE_EXE%" (
    :: Verificacion final EXE
    powershell -NoProfile -Command "$b=[System.IO.File]::ReadAllBytes('%HCE_EXE%'); if($b[0] -eq 77 -and $b[1] -eq 90){ Write-Host 'OK_EXE' } else { Write-Host 'BAD_EXE' }" 2>nul | findstr "OK_EXE" >nul
    if !errorLevel! equ 0 (
        echo  !W!  [->]!Z! Ejecutando instalador de Halo CE...
        echo  !GR!  (Instala en la ruta por defecto cuando te lo pida)!Z!
        echo.
        start /wait "" "%HCE_EXE%"
        echo  !G!  [OK]!Z! Halo CE instalado
        for /f "tokens=2*" %%a in ('reg query "%KEY64%" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
        if not defined HCE_PATH if exist "%DEF_PATH%\halo.exe" set "HCE_PATH=%DEF_PATH%"
        set "OUTDATED=1"
    ) else (
        echo  !R!  [X]!Z! El archivo descargado no es un EXE valido (pagina web)
        del "%HCE_EXE%" 2>nul
        goto descarga_manual
    )
) else (
    :descarga_manual
    echo  !Y!  [!]!Z! Descarga automatica fallida.
    echo.
    echo  Descarga manual desde una de estas fuentes:
    echo  !W!  1. https://hce.halomaps.org (busca "Halo Custom Edition Game")!Z!
    echo  !W!  2. https://github.com/Sledmine/ce-setup/releases!Z!
    echo.
    echo  Guarda como: !Y!%DOWNLOADS%\hce_setup.exe!Z!
    echo.
    start "" "https://hce.halomaps.org"
    echo  Presiona una tecla cuando lo hayas descargado...
    pause >nul
    if not exist "%HCE_EXE%" ( echo  !R!  [X]!Z! No se encontro el archivo. Reinicia el script. & pause & exit /b )
)
echo.

:paso3
:: =============================================
:: PASO 3 - PARCHE 1.0.10
:: =============================================
echo  !C![3/5]!Z! !B!Parche Oficial v1.0.10!Z!
echo  !GR!  --------------------------------------------------------!Z!
echo.

if "%OUTDATED%"=="0" (
    echo  !G!  [OK]!Z! No necesita parche
    echo.
    goto paso4
)

set "PATCH=%DOWNLOADS%\haloce_patch_1010.exe"
if not exist "%PATCH%" (
    echo  !W!  [v]!Z! Descargando parche v1.0.10...
    curl -L --max-time 120 --progress-bar -o "%PATCH%" "http://hce.halomaps.org/files/haloce_patch_1_0_10.exe" 2>nul
    :: Verificar
    if exist "%PATCH%" (
        powershell -NoProfile -Command "$b=[System.IO.File]::ReadAllBytes('%PATCH%'); if($b[0] -ne 77 -or $b[1] -ne 90){ Remove-Item '%PATCH%' -Force }" 2>nul
    )
)
if exist "%PATCH%" (
    echo  !W!  [->]!Z! Aplicando parche...
    start /wait "" "%PATCH%"
    echo  !G!  [OK]!Z! Halo CE v1.0.10 activo
) else (
    echo  !Y!  [!]!Z! Descarga fallida. Link manual:
    echo  !GR!      https://hce.halomaps.org/index.cfm?pg=3^&fid=6798!Z!
    start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=6798"
    pause
)
echo.

:paso4
:: =============================================
:: PASO 4 - MERCURY
:: =============================================
echo  !C![4/5]!Z! !B!Mercury - Gestor de Mods!Z!
echo  !GR!  --------------------------------------------------------!Z!
echo.

set "MERCURY_CMD="
where mercury >nul 2>&1
if %errorLevel% equ 0 set "MERCURY_CMD=mercury"
if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
if not defined MERCURY_CMD if exist "%ProgramFiles%\mercury\mercury.exe" set "MERCURY_CMD=%ProgramFiles%\mercury\mercury.exe"

if defined MERCURY_CMD (
    echo  !G!  [OK]!Z! Mercury encontrado
    echo.
    goto paso5
)

echo  !W!  [v]!Z! Descargando Mercury desde GitHub...
powershell -NoProfile -Command "try { $r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/mercury/releases/latest'; $a=$r.assets|?{$_.name -like '*.exe'}|select -First 1; Invoke-WebRequest $a.browser_download_url -OutFile '%DOWNLOADS%\mercury-setup.exe' -UseBasicParsing; Write-Host '  OK:' $a.name } catch { Write-Host '  Error:' $_.Exception.Message }" 2>nul

if exist "%DOWNLOADS%\mercury-setup.exe" (
    echo  !W!  [->]!Z! Instalando Mercury...
    start /wait "" "%DOWNLOADS%\mercury-setup.exe" /S
    timeout /t 3 /nobreak >nul
    where mercury >nul 2>&1 && set "MERCURY_CMD=mercury"
    if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
    if defined MERCURY_CMD ( echo  !G!  [OK]!Z! Mercury listo ) else ( echo  !Y!  [!]!Z! Reinicia el script si el paso 5 falla )
) else (
    echo  !Y!  [!]!Z! Descarga fallida. Descargalo desde:
    echo  !GR!      https://github.com/Sledmine/mercury/releases/latest!Z!
    start "" "https://github.com/Sledmine/mercury/releases/latest"
    echo  Instala Mercury y presiona una tecla...
    pause >nul
    where mercury >nul 2>&1 && set "MERCURY_CMD=mercury"
    if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
)
echo.

:paso5
echo.
:: =============================================
:: PASO 5 - COOP EVOLVED
:: =============================================
echo  !C![5/5]!Z! !B!Coop Evolved!Z!
echo  !GR!  --------------------------------------------------------!Z!
echo  !GR!  Co-op campaña hasta 16 jugadores LAN/Internet!Z!
echo.

if not defined MERCURY_CMD (
    echo  !R!  [X]!Z! Mercury no disponible
    echo  !Y!  Abre Mercury Console y escribe: mercury install coopevolved!Z!
    start "" "https://github.com/Sledmine/coop-evolved"
    goto fin
)

echo  !W!  [->]!Z! mercury install coopevolved
echo.
"%MERCURY_CMD%" install coopevolved
if %errorLevel% equ 0 (
    echo.
    echo  !G!  [OK]!Z! Coop Evolved instalado!
) else (
    echo  !Y!  [->]!Z! Reintentando...
    "%MERCURY_CMD%" install coopevolved --force 2>nul
    if !errorLevel! equ 0 (
        echo  !G!  [OK]!Z! Coop Evolved instalado!
    ) else (
        echo  !R!  [X]!Z! Error - abre Mercury Console: mercury install coopevolved
    )
)

:fin
echo.
echo.
echo  !DR!  ========================================================!Z!
echo  !DR!  ##!Z!                                                  !DR!##!Z!
echo  !DR!  ##!Z!    !G!!B! INSTALACION COMPLETADA !Z!                       !DR!##!Z!
echo  !DR!  ##!Z!                                                  !DR!##!Z!
echo  !DR!  ##!Z!    !W!Halo CE  :!Z! %HCE_PATH%
echo  !DR!  ##!Z!    !W!Version  :!Z! !G!1.0.10!Z!                              !DR!##!Z!
echo  !DR!  ##!Z!    !W!Co-op    :!Z! !G!hasta 16 jugadores (Coop Evolved)!Z!  !DR!##!Z!
echo  !DR!  ##!Z!                                                  !DR!##!Z!
echo  !DR!  ========================================================!Z!
echo.
echo  !GR!  Como jugar en co-op:!Z!
echo  !W!  1. Lanza Halo CE!Z!
echo  !W!  2. Multijugador -^> Unirse a juego -^> busca coop!Z!
echo  !W!  3. Crea servidor: halo.exe -window -console!Z!
echo  !W!     luego escribe: sv_map a10 slayer!Z!
echo.
echo  !DR!                          by x3btc!Z!
echo  !GR!  github.com/x3btc/HaloCE-CoopEvolved!Z!
echo.
echo  !GR!  --------------------------------------------------------!Z!
pause