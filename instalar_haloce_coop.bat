@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando permisos de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    exit /b
)

:: Ya somos admin, arrancar
setlocal enabledelayedexpansion
title HALO CE COOP - x3btc
mode con: cols=70 lines=45
cls

:: Fijar directorio de trabajo al directorio del .bat
cd /d "%~dp0"

:: Obtener ESC para colores ANSI
for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "R=!ESC![91m"
set "DR=!ESC![31m"
set "G=!ESC![92m"
set "Y=!ESC![93m"
set "W=!ESC![97m"
set "GR=!ESC![90m"
set "C=!ESC![96m"
set "X=!ESC![0m"
set "B=!ESC![1m"

echo.
echo !R!!B!  ##  ##  #####  ##      ######      ######  #######!X!
echo !R!!B!  ##  ##  ##  ## ##      ##   ##     ##      ##!X!
echo !DR!!B!  #######  #####  ##      ##   ##     ##      #####!X!
echo !DR!!B!  ##  ##  ##  ## ##      ##   ##     ##      ##!X!
echo !R!!B!  ##  ##  ##  ## #######  ######      ######  #######!X!
echo.
echo !DR!  ========================================================!X!
echo !DR!  ##!X!   !W!!B!C O O P   E V O L V E D   I N S T A L L E R!X!   !DR!##!X!
echo !DR!  ========================================================!X!
echo.
echo                         !DR!!B! by x3btc !X!
echo !GR!  --------------------------------------------------------!X!
echo.
echo  !G![OK]!X! Administrador confirmado.
echo.

set "DOWNLOADS=%~dp0downloads"
set "KEY64=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo CE"
set "KEY32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Halo CE"
set "DEF_PATH=C:\Program Files (x86)\Microsoft Games\Halo Custom Edition"
set "INSTALLED=0"
set "OUTDATED=0"
set "HCE_PATH="
mkdir "!DOWNLOADS!" 2>nul

:: === PASO 1: DETECCION ====================================
echo  !C![1/5]!X! !B!Detectando Halo Custom Edition...!X!
echo  !GR!  --------------------------------------------------------!X!
echo.

for /f "tokens=2*" %%a in ('reg query "!KEY64!" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
if not defined HCE_PATH for /f "tokens=2*" %%a in ('reg query "!KEY32!" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
if not defined HCE_PATH if exist "!DEF_PATH!\halo.exe" set "HCE_PATH=!DEF_PATH!"

if defined HCE_PATH (
    set "INSTALLED=1"
    echo  !G!  [ENCONTRADO]!X! !W!!HCE_PATH!!X!
    echo.
    for /f "delims=" %%v in ('powershell -NoProfile -Command "try{(Get-Item '!HCE_PATH!\halo.exe').VersionInfo.FileVersion}catch{}"' 2^>nul) do set "VER=%%v"
    if defined VER (
        echo  !GR!  Version: !W!!VER!!X!
        echo.!VER! | findstr /C:"1.0.10" >nul 2>&1
        if errorlevel 1 (
            set "OUTDATED=1"
            echo  !Y!  [DESACTUALIZADA]!X! Se aplicara parche
        ) else (
            echo  !G!  [ACTUALIZADA]!X! v1.0.10
        )
    ) else (
        set "OUTDATED=1"
        echo  !Y!  [?]!X! Version no verificable - parche preventivo
    )
) else (
    echo  !Y!  [NO ENCONTRADO]!X! Se instalara desde cero
)
echo.

:: === PASO 2: INSTALAR HALO CE =============================
echo  !C![2/5]!X! !B!Halo CE Custom Edition!X!
echo  !GR!  --------------------------------------------------------!X!
echo.

if "!INSTALLED!"=="1" (
    if "!OUTDATED!"=="0" (
        echo  !G!  [OK]!X! Ya instalado y actualizado
        echo.
        goto paso3
    )
    echo  !Y!  [->]!X! Desactualizado - solo parche
    echo.
    goto paso3
)

set "HCE_EXE=!DOWNLOADS!\hce_setup.exe"
if not exist "!HCE_EXE!" (
    echo  !W!  [v]!X! Descargando Halo CE...
    echo.
    powershell -NoProfile -Command "try{$r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/ce-setup/releases/latest';$a=$r.assets|?{$_.name -like '*.exe'}|select -First 1;if($a){Invoke-WebRequest $a.browser_download_url -OutFile '!HCE_EXE!' -UseBasicParsing;Write-Host 'OK:' $a.name}else{Write-Host 'Sin assets'}}catch{Write-Host $_.Exception.Message}" 2>nul
    if exist "!HCE_EXE!" (
        powershell -NoProfile -Command "$b=[IO.File]::ReadAllBytes('!HCE_EXE!');if($b[0]-ne77-or$b[1]-ne90){Remove-Item '!HCE_EXE!' -Force;exit 1}" 2>nul
        if errorlevel 1 del "!HCE_EXE!" 2>nul
    )
    if not exist "!HCE_EXE!" (
        echo  !W!  [v]!X! Intentando HaloMaps.org...
        curl -L --max-time 300 --progress-bar -A "Mozilla/5.0" -o "!HCE_EXE!" "http://hce.halomaps.org/files/hce_setup.exe" 2>nul
        if exist "!HCE_EXE!" (
            powershell -NoProfile -Command "$b=[IO.File]::ReadAllBytes('!HCE_EXE!');if($b[0]-ne77-or$b[1]-ne90){Remove-Item '!HCE_EXE!' -Force}" 2>nul
        )
    )
)

if exist "!HCE_EXE!" (
    echo  !W!  [->]!X! Ejecutando instalador...
    echo  !GR!  Instala en la ruta por defecto!X!
    echo.
    start /wait "" "!HCE_EXE!"
    echo  !G!  [OK]!X! Halo CE instalado
    for /f "tokens=2*" %%a in ('reg query "!KEY64!" /v "EXE Path" 2^>nul') do set "HCE_PATH=%%b"
    if not defined HCE_PATH if exist "!DEF_PATH!\halo.exe" set "HCE_PATH=!DEF_PATH!"
    set "OUTDATED=1"
) else (
    echo  !Y!  [*]!X! Descarga automatica fallida.
    echo.
    echo  Descarga manual:
    echo  !W!  1. https://hce.halomaps.org!X!
    echo  !W!  2. https://github.com/Sledmine/ce-setup/releases!X!
    echo.
    echo  Guarda como: !Y!!DOWNLOADS!\hce_setup.exe!X!
    start "" "https://hce.halomaps.org"
    echo.
    echo  Presiona una tecla cuando lo hayas descargado...
    pause >nul
    if not exist "!HCE_EXE!" ( echo  !R![X]!X! No encontrado. Reinicia. & pause & exit /b )
    start /wait "" "!HCE_EXE!"
    echo  !G!  [OK]!X! Halo CE instalado
    set "OUTDATED=1"
)
echo.

:paso3
:: === PASO 3: PARCHE 1.0.10 ================================
echo  !C![3/5]!X! !B!Parche Oficial v1.0.10!X!
echo  !GR!  --------------------------------------------------------!X!
echo.

if "!OUTDATED!"=="0" (
    echo  !G!  [OK]!X! No necesita parche
    echo.
    goto paso4
)

set "PATCH=!DOWNLOADS!\haloce_patch_1010.exe"
if not exist "!PATCH!" (
    echo  !W!  [v]!X! Descargando parche v1.0.10...
    curl -L --max-time 120 --progress-bar -o "!PATCH!" "http://hce.halomaps.org/files/haloce_patch_1_0_10.exe" 2>nul
)
if exist "!PATCH!" (
    echo  !W!  [->]!X! Aplicando parche...
    start /wait "" "!PATCH!"
    echo  !G!  [OK]!X! v1.0.10 activo
) else (
    echo  !Y!  [*]!X! Parche no descargado. Link:
    echo  !GR!  https://hce.halomaps.org/index.cfm?pg=3^&fid=6798!X!
    start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=6798"
    pause
)
echo.

:paso4
:: === PASO 4: MERCURY ======================================
echo  !C![4/5]!X! !B!Mercury - Gestor de Mods!X!
echo  !GR!  --------------------------------------------------------!X!
echo.

set "MERCURY_CMD="
where mercury >nul 2>&1
if not errorlevel 1 set "MERCURY_CMD=mercury"
if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
if not defined MERCURY_CMD if exist "%ProgramFiles%\mercury\mercury.exe" set "MERCURY_CMD=%ProgramFiles%\mercury\mercury.exe"

if defined MERCURY_CMD (
    echo  !G!  [OK]!X! Mercury encontrado
    echo.
    goto paso5
)

echo  !W!  [v]!X! Descargando Mercury...
powershell -NoProfile -Command "try{$r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/mercury/releases/latest';$a=$r.assets|?{$_.name -like '*.exe'}|select -First 1;Invoke-WebRequest $a.browser_download_url -OutFile '!DOWNLOADS!\mercury-setup.exe' -UseBasicParsing;Write-Host 'OK:' $a.name}catch{Write-Host $_.Exception.Message}" 2>nul

if exist "!DOWNLOADS!\mercury-setup.exe" (
    echo  !W!  [->]!X! Instalando Mercury...
    start /wait "" "!DOWNLOADS!\mercury-setup.exe" /S
    timeout /t 3 /nobreak >nul
    where mercury >nul 2>&1
    if not errorlevel 1 set "MERCURY_CMD=mercury"
    if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
    if defined MERCURY_CMD ( echo  !G!  [OK]!X! Mercury listo ) else ( echo  !Y!  [*]!X! Reinicia si paso 5 falla )
) else (
    echo  !Y!  [*]!X! Descarga fallida.
    echo  !GR!  https://github.com/Sledmine/mercury/releases/latest!X!
    start "" "https://github.com/Sledmine/mercury/releases/latest"
    echo  Instala Mercury y presiona una tecla...
    pause >nul
    where mercury >nul 2>&1
    if not errorlevel 1 set "MERCURY_CMD=mercury"
    if not defined MERCURY_CMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
)
echo.

:paso5
echo.
:: === PASO 5: COOP EVOLVED =================================
echo  !C![5/5]!X! !B!Coop Evolved!X!
echo  !GR!  --------------------------------------------------------!X!
echo  !GR!  Co-op campaña hasta 16 jugadores LAN/Internet!X!
echo.

if not defined MERCURY_CMD (
    echo  !R![X]!X! Mercury no disponible
    echo  !Y!  Abre Mercury Console: mercury install coopevolved!X!
    start "" "https://github.com/Sledmine/coop-evolved"
    goto fin
)

echo  !W!  [->]!X! mercury install coopevolved
echo.
"!MERCURY_CMD!" install coopevolved
if not errorlevel 1 (
    echo.
    echo  !G!  [OK]!X! Coop Evolved instalado
) else (
    echo  !Y!  [->]!X! Reintentando...
    "!MERCURY_CMD!" install coopevolved --force 2>nul
    if not errorlevel 1 (
        echo  !G!  [OK]!X! Coop Evolved instalado
    ) else (
        echo  !R![X]!X! Error - abre Mercury Console: mercury install coopevolved
    )
)

:fin
echo.
echo.
echo  !DR!  ========================================================!X!
echo  !DR!  ##!X!                                                !DR!##!X!
echo  !DR!  ##!X!    !G!!B! INSTALACION COMPLETADA !X!                     !DR!##!X!
echo  !DR!  ##!X!                                                !DR!##!X!
echo  !DR!  ##!X!  !W!Halo CE :!X! !HCE_PATH!
echo  !DR!  ##!X!  !W!Version :!X! !G!1.0.10!X!                            !DR!##!X!
echo  !DR!  ##!X!  !W!Co-op   :!X! !G!hasta 16 jugadores!X!               !DR!##!X!
echo  !DR!  ##!X!                                                !DR!##!X!
echo  !DR!  ========================================================!X!
echo.
echo  !GR!  Como jugar:!X!
echo  !W!  1. Lanza Halo CE!X!
echo  !W!  2. Multijugador -^> Unirse a juego -^> busca coop!X!
echo  !W!  3. Crea servidor: halo.exe -window -console!X!
echo  !W!     luego: sv_map a10 slayer!X!
echo.
echo  !DR!                          by x3btc!X!
echo  !GR!  github.com/x3btc/HaloCE-CoopEvolved!X!
echo.
echo  !GR!  --------------------------------------------------------!X!
pause
