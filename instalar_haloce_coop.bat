@echo off
setlocal enabledelayedexpansion
title HALO CE COOP - x3btc
cls

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
echo !R!!B!  ##  ##  ##  ## ##      ##   ##     ##      ##     !Z!
echo !DR!!B!  #######  #####  ##      ##   ##     ##      #####  !Z!
echo !DR!!B!  ##  ##  ##  ## ##      ##   ##     ##      ##     !Z!
echo !R!!B!  ##  ##  ##  ## #######  ######      ######  #######!Z!
echo.
echo !DR!  ========================================================!Z!
echo !DR!  ##!Z!   !W!!B!C O O P   E V O L V E D   I N S T A L L E R!Z!   !DR!##!Z!
echo !DR!  ========================================================!Z!
echo.
echo                         !DR!!B! by x3btc !Z!
echo !GR!  --------------------------------------------------------!Z!
echo.

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  !R![X] Necesita permisos de Administrador.!Z!
    echo  !Y![!] Clic derecho -^> Ejecutar como administrador!Z!
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

::------- PASO 1: DETECCION --------------------------------------
echo  !C![1/5]!Z! !B!Detectando Halo Custom Edition...!Z!
echo  !GR!  --------------------------------------------------------!Z!

for /f "tokens=2*" %%a in ('reg query "%KEY64%" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
if not defined HCE_PATH for /f "tokens=2*" %%a in ('reg query "%KEY32%" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
if not defined HCE_PATH if exist "%DEF_PATH%\halo.exe" set "HCE_PATH=%DEF_PATH%"

if defined HCE_PATH (
    set "INSTALLED=1"
    echo  !G!  [OK] Halo CE encontrado en:!Z!
    echo       !W!!HCE_PATH!!Z!
    echo.
    for /f "delims=" %%v in ('powershell -NoProfile -Command "(Get-Item '!HCE_PATH!\halo.exe').VersionInfo.FileVersion" 2^>nul') do set "VER=%%v"
    if defined VER (
        echo  !GR!  Version instalada : !W!!VER!!Z!
        echo !VER! | findstr /C:"1.0.10" >nul 2>&1
        if !errorLevel! neq 0 (
            set "OUTDATED=1"
            echo  !Y!  [!] DESACTUALIZADA -^> se aplica parche 1.0.10!Z!
        ) else (
            echo  !G!  [OK] Version 1.0.10 - no necesita parche!Z!
        )
    ) else (
        set "OUTDATED=1"
        echo  !Y!  [!] Version no verificable -^> parche preventivo!Z!
    )
) else (
    echo  !Y!  [!] No encontrado -^> instalacion desde cero!Z!
)
echo.

::------- PASO 2: INSTALAR HALO CE --------------------------------
echo  !C![2/5]!Z! !B!Halo CE Custom Edition!Z!
echo  !GR!  --------------------------------------------------------!Z!

if "%INSTALLED%"=="1" (
    if "%OUTDATED%"=="0" (
        echo  !G!  [OK] Ya instalado y actualizado -^> saltando!Z!
        echo.
        goto paso3
    )
    echo  !Y!  [->] Desactualizado -^> solo parche!Z!
    echo.
    goto paso3
)

set "HCE_EXE=%DOWNLOADS%\hce_setup.exe"
if not exist "%HCE_EXE%" (
    echo  !W!  [v] Descargando Halo CE...!Z!
    curl -L --max-time 300 --progress-bar -o "%HCE_EXE%" "http://hce.halomaps.org/files/hce_setup.exe" 2>nul
)
if exist "%HCE_EXE%" (
    echo  !W!  [->] Ejecutando instalador...!Z!
    start /wait "" "%HCE_EXE%"
    echo  !G!  [OK] Halo CE instalado!Z!
    for /f "tokens=2*" %%a in ('reg query "%KEY64%" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
    if not defined HCE_PATH if exist "%DEF_PATH%\halo.exe" set "HCE_PATH=%DEF_PATH%"
    set "OUTDATED=1"
) else (
    echo  !Y!  [!] Descarga fallida -^> abriendo HaloMaps...!Z!
    start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=410"
    echo  !W!  Guarda hce_setup.exe en downloads\ y reinicia.!Z!
    pause & exit /b
)
echo.

:paso3
::------- PASO 3: PARCHE 1.0.10 -----------------------------------
echo  !C![3/5]!Z! !B!Parche Oficial v1.0.10!Z!
echo  !GR!  --------------------------------------------------------!Z!

if "%OUTDATED%"=="0" (
    echo  !G!  [OK] No necesita parche!Z!
    echo.
    goto paso4
)

set "PATCH=%DOWNLOADS%\haloce_patch_1010.exe"
if not exist "%PATCH%" (
    echo  !W!  [v] Descargando parche...!Z!
    curl -L --max-time 120 --progress-bar -o "%PATCH%" "http://hce.halomaps.org/files/haloce_patch_1_0_10.exe" 2>nul
)
if exist "%PATCH%" (
    echo  !W!  [->] Aplicando parche 1.0.10...!Z!
    start /wait "" "%PATCH%"
    echo  !G!  [OK] Halo CE v1.0.10 activo!Z!
) else (
    echo  !Y!  [!] Descarga fallida. Link manual:!Z!
    echo  !GR!      https://hce.halomaps.org/index.cfm?pg=3^&fid=6798!Z!
    start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=6798"
    pause
)
echo.

:paso4
::------- PASO 4: MERCURY -----------------------------------------
echo  !C![4/5]!Z! !B!Mercury - Gestor de Mods!Z!
echo  !GR!  --------------------------------------------------------!Z!

set "MERCURY_CMD="
where mercury >nul 2>&1
if %errorLevel% equ 0 set "MERCURY_CMD=mercury"
if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
if not defined MERCURY_CMD if exist "%ProgramFiles%\mercury\mercury.exe" set "MERCURY_CMD=%ProgramFiles%\mercury\mercury.exe"

if defined MERCURY_CMD (
    echo  !G!  [OK] Mercury encontrado!Z!
    echo.
    goto paso5
)

echo  !W!  [v] Descargando Mercury...!Z!
powershell -NoProfile -Command "& { try { $r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/mercury/releases/latest'; $a=$r.assets|?{$_.name -like '*.exe'}|select -First 1; Invoke-WebRequest $a.browser_download_url -OutFile '%DOWNLOADS%\mercury-setup.exe' -UseBasicParsing } catch { Write-Host $_.Exception.Message } }" 2>nul

if exist "%DOWNLOADS%\mercury-setup.exe" (
    echo  !W!  [->] Instalando Mercury...!Z!
    start /wait "" "%DOWNLOADS%\mercury-setup.exe" /S
    timeout /t 3 /nobreak >nul
    where mercury >nul 2>&1 && set "MERCURY_CMD=mercury"
    if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
    if defined MERCURY_CMD ( echo  !G!  [OK] Mercury listo!Z! ) else ( echo  !Y!  [!] Reinicia si el paso 5 falla!Z! )
) else (
    echo  !Y!  [!] Descarga fallida. Descargalo desde:!Z!
    echo  !GR!      https://github.com/Sledmine/mercury/releases/latest!Z!
    start "" "https://github.com/Sledmine/mercury/releases/latest"
    echo  !W!  Instala Mercury y presiona una tecla...!Z!
    pause >nul
    where mercury >nul 2>&1 && set "MERCURY_CMD=mercury"
    if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
)
echo.

:paso5
echo.
::------- PASO 5: COOP EVOLVED ------------------------------------
echo  !C![5/5]!Z! !B!Coop Evolved!Z!
echo  !GR!  --------------------------------------------------------!Z!
echo  !GR!  Co-op campaña hasta 16 jugadores LAN/Internet!Z!
echo.

if not defined MERCURY_CMD (
    echo  !R!  [X] Mercury no disponible!Z!
    echo  !Y!  Abre Mercury Console y escribe: mercury install coopevolved!Z!
    start "" "https://github.com/Sledmine/coop-evolved"
    goto fin
)

echo  !W!  [->] Ejecutando: mercury install coopevolved!Z!
echo.
"%MERCURY_CMD%" install coopevolved
if %errorLevel% equ 0 (
    echo.
    echo  !G!  [OK] Coop Evolved instalado!!Z!
) else (
    echo  !Y!  [->] Reintentando con --force...!Z!
    "%MERCURY_CMD%" install coopevolved --force 2>nul
    if !errorLevel! equ 0 (
        echo  !G!  [OK] Coop Evolved instalado!!Z!
    ) else (
        echo  !R!  [X] Error - abre Mercury Console: mercury install coopevolved!Z!
    )
)

:fin
echo.
echo.
echo  !DR!  ========================================================!Z!
echo  !DR!  ##!Z!                                                  !DR!##!Z!
echo  !DR!  ##!Z!    !G!!B! INSTALACION COMPLETADA !Z!                        !DR!##!Z!
echo  !DR!  ##!Z!                                                  !DR!##!Z!
echo  !DR!  ##!Z!    !W!Halo CE  :!Z! !HCE_PATH!
echo  !DR!  ##!Z!    !W!Version  :!Z! !G!1.0.10!Z!                              !DR!##!Z!
echo  !DR!  ##!Z!    !W!Co-op    :!Z! !G!Coop Evolved (hasta 16 jugadores)!Z!  !DR!##!Z!
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