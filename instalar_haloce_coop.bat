@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando permisos de administrador...
    powershell -NoProfile -Command "Start-Process -FilePath '%~dpnx0' -Verb RunAs"
    exit /b
)

setlocal enabledelayedexpansion
chcp 65001 >nul
title HALO CE COOP - x3btc
mode con: cols=70 lines=50
cls
cd /d "%~dp0"

for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set "R=!ESC![91m"
set "DR=!ESC![31m"
set "G=!ESC![92m"
set "Y=!ESC![93m"
set "W=!ESC![97m"
set "GR=!ESC![90m"
set "C=!ESC![96m"
set "X=!ESC![0m"
set "BL=!ESC![1m"

echo.
echo !R!!BL!  ██  ██  █████  ██      ██████      ██████ ███████!X!
echo !R!!BL!  ██  ██ ██▓▓▓██ ██     ██▓▓▓▓██    ██▓▓▓▓ ██▓▓▓▓▓!X!
echo !DR!!BL!  ██████ ███████ ██     ██   ██    ██     █████!X!
echo !DR!!BL!  ██▓▓██ ██▓▓▓██ ██     ██   ██    ██     ██▓▓▓!X!
echo !R!!BL!  ██  ██ ██  ██ ███████  ██████      ██████ ███████!X!
echo !DR!  ▓▓  ▓▓ ▓▓  ▓▓ ▓▓▓▓▓▓▓  ▓▓▓▓▓▓      ▓▓▓▓▓▓ ▓▓▓▓▓▓▓!X!
echo.
echo !DR!  ████████████████████████████████████████████████████████!X!
echo !DR!  ██!X!   !W!!BL!C O O P   E V O L V E D   I N S T A L L E R!X!   !DR!██!X!
echo !DR!  ████████████████████████████████████████████████████████!X!
echo.
echo                         !DR!!BL! by x3btc !X!
echo !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo.
echo  !G![OK]!X! Administrador confirmado.
echo.

set "DL=%~dp0downloads"
set "K64=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo CE"
set "K32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Halo CE"
set "DPATH=C:\Program Files (x86)\Microsoft Games\Halo Custom Edition"
set "INST=0"
set "OUTD=0"
set "HPATH="
mkdir "!DL!" 2>nul

echo  !C![1/5]!X! !BL!Detectando Halo Custom Edition...!X!
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo.

set "HPATH="
for /f "tokens=2*" %%a in ('reg query "!K64!" /v "EXE Path" 2^>nul') do set "HPATH=%%b"
if not defined HPATH for /f "tokens=2*" %%a in ('reg query "!K32!" /v "EXE Path" 2^>nul') do set "HPATH=%%b"
if not defined HPATH if exist "!DPATH!\halo.exe" set "HPATH=!DPATH!"

if not defined HPATH (
    echo  !Y!  [NO ENCONTRADO]!X! Se instalara desde cero
    echo.
    goto paso2_install
)

set "INST=1"
echo  !G!  [ENCONTRADO]!X! !W!!HPATH!!X!
echo.

set "VER="
powershell -NoProfile -Command "try{(Get-Item '!HPATH!\halo.exe').VersionInfo.FileVersion}catch{}" > "%TEMP%\hce_ver.txt" 2>nul
set /p VER=<"%TEMP%\hce_ver.txt"
del "%TEMP%\hce_ver.txt" 2>nul

if not defined VER (
    set "OUTD=1"
    echo  !Y!  [?]!X! Version no verificable - parche preventivo
    goto paso2
)

echo  !GR!  Version: !W!!VER!!X!
echo.!VER! | findstr /C:"1.0.10" >nul 2>&1
if errorlevel 1 (
    set "OUTD=1"
    echo  !Y!  [DESACTUALIZADA]!X! Se aplicara parche
) else (
    echo  !G!  [ACTUALIZADA]!X! v1.0.10
)
goto paso2

:paso2
echo.
echo  !C![2/5]!X! !BL!Halo CE Custom Edition!X!
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo.

if "!INST!"=="1" (
    if "!OUTD!"=="0" (
        echo  !G!  [OK]!X! Ya instalado y actualizado
        echo.
        goto paso3
    )
    echo  !Y!  [->]!X! Desactualizado - solo parche
    echo.
    goto paso3
)

:paso2_install
echo  !C![2/5]!X! !BL!Halo CE Custom Edition!X!
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo.

set "HCE_EXE=!DL!\hce_setup.exe"
if exist "!HCE_EXE!" goto paso2_run

echo  !W!  [v]!X! Descargando Halo CE...
echo.

powershell -NoProfile -Command "$r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/ce-setup/releases/latest';$a=$r.assets|Where-Object{$_.name -like '*.exe'}|Select-Object -First 1;$a.browser_download_url" > "%TEMP%\hce_url.txt" 2>nul
set "DL_URL="
set /p DL_URL=<"%TEMP%\hce_url.txt"
del "%TEMP%\hce_url.txt" 2>nul

if defined DL_URL (
    echo  !GR!  Fuente: GitHub!X!
    echo.
    curl -L --progress-bar -o "!HCE_EXE!" "!DL_URL!"
    echo.
) else (
    echo  !GR!  Fuente: HaloMaps.org!X!
    echo.
    curl -L --progress-bar -A "Mozilla/5.0" -o "!HCE_EXE!" "http://hce.halomaps.org/files/hce_setup.exe"
    echo.
)

if exist "!HCE_EXE!" (
    powershell -NoProfile -Command "$f=Get-Item '!HCE_EXE!';if($f.Length -lt 1048576){Remove-Item '!HCE_EXE!' -Force;exit 1};$b=[IO.File]::ReadAllBytes('!HCE_EXE!')[0..1];if($b[0]-ne77-or$b[1]-ne90){Remove-Item '!HCE_EXE!' -Force;exit 1}" 2>nul
    if errorlevel 1 (
        echo  !Y!  [*]!X! Archivo invalido descartado
        del "!HCE_EXE!" 2>nul
    )
)

if not exist "!HCE_EXE!" (
    echo  !Y!  [*]!X! Descarga automatica fallida.
    echo.
    echo  Descarga manual:
    echo  !W!  1. https://hce.halomaps.org!X!
    echo  !W!  2. https://github.com/Sledmine/ce-setup/releases!X!
    echo.
    echo  Guarda como: !Y!!DL!\hce_setup.exe!X!
    start "" "https://hce.halomaps.org"
    echo.
    echo  Presiona una tecla cuando lo hayas descargado...
    pause >nul
    if not exist "!HCE_EXE!" ( echo  !R![X]!X! No encontrado. Reinicia. & pause & exit /b )
)

:paso2_run
echo  !W!  [->]!X! Ejecutando instalador de Halo CE...
echo  !GR!  Instala en la ruta por defecto!X!
echo.
start /wait "" "!HCE_EXE!"
echo  !G!  [OK]!X! Halo CE instalado

set "HPATH="
for /f "tokens=2*" %%a in ('reg query "!K64!" /v "EXE Path" 2^>nul') do set "HPATH=%%b"
if not defined HPATH for /f "tokens=2*" %%a in ('reg query "!K32!" /v "EXE Path" 2^>nul') do set "HPATH=%%b"
if not defined HPATH if exist "!DPATH!\halo.exe" set "HPATH=!DPATH!"
set "OUTD=1"
echo.

:paso3
echo  !C![3/5]!X! !BL!Parche Oficial v1.0.10!X!
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo.

if "!OUTD!"=="0" (
    echo  !G!  [OK]!X! No necesita parche
    echo.
    goto paso4
)

set "PATCH=!DL!\haloce_patch_1010.exe"
if not exist "!PATCH!" (
    echo  !W!  [v]!X! Descargando parche v1.0.10...
    echo.
    curl -L --progress-bar -o "!PATCH!" "http://hce.halomaps.org/files/haloce_patch_1_0_10.exe"
    echo.
)
if exist "!PATCH!" (
    echo  !W!  [->]!X! Aplicando parche...
    start /wait "" "!PATCH!"
    echo  !G!  [OK]!X! v1.0.10 activo
) else (
    echo  !Y!  [*]!X! Parche no descargado.
    echo  !GR!  https://hce.halomaps.org/index.cfm?pg=3^&fid=6798!X!
    start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=6798"
    pause
)
echo.

:paso4
echo  !C![4/5]!X! !BL!Mercury - Gestor de Mods!X!
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo.

set "MCMD="
where mercury >nul 2>&1
if not errorlevel 1 set "MCMD=mercury"
if not defined MCMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MCMD=%LOCALAPPDATA%\mercury\mercury.exe"
if not defined MCMD if exist "%ProgramFiles%\mercury\mercury.exe" set "MCMD=%ProgramFiles%\mercury\mercury.exe"

if defined MCMD (
    echo  !G!  [OK]!X! Mercury encontrado
    echo.
    goto paso5
)

echo  !W!  [v]!X! Descargando Mercury...
powershell -NoProfile -Command "$r=Invoke-RestMethod 'https://api.github.com/repos/Sledmine/mercury/releases/latest';$a=$r.assets|Where-Object{$_.name -like '*.exe'}|Select-Object -First 1;$a.browser_download_url" > "%TEMP%\merc_url.txt" 2>nul
set "MERC_URL="
set /p MERC_URL=<"%TEMP%\merc_url.txt"
del "%TEMP%\merc_url.txt" 2>nul

if defined MERC_URL (
    echo.
    curl -L --progress-bar -o "!DL!\mercury-setup.exe" "!MERC_URL!"
    echo.
)

if exist "!DL!\mercury-setup.exe" (
    echo  !W!  [->]!X! Instalando Mercury...
    start /wait "" "!DL!\mercury-setup.exe" /S
    timeout /t 3 /nobreak >nul
    where mercury >nul 2>&1
    if not errorlevel 1 set "MCMD=mercury"
    if not defined MCMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MCMD=%LOCALAPPDATA%\mercury\mercury.exe"
    if defined MCMD ( echo  !G!  [OK]!X! Mercury listo ) else ( echo  !Y!  [*]!X! Reinicia si paso 5 falla )
) else (
    echo  !Y!  [*]!X! Descarga fallida.
    echo  !GR!  https://github.com/Sledmine/mercury/releases/latest!X!
    start "" "https://github.com/Sledmine/mercury/releases/latest"
    echo  Instala Mercury y presiona una tecla...
    pause >nul
    where mercury >nul 2>&1
    if not errorlevel 1 set "MCMD=mercury"
    if not defined MCMD if exist "%LOCALAPPDATA%\mercury\mercury.exe" set "MCMD=%LOCALAPPDATA%\mercury\mercury.exe"
)
echo.

:paso5
echo.
echo  !C![5/5]!X! !BL!Coop Evolved!X!
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
echo  !GR!  Co-op hasta 16 jugadores LAN/Internet!X!
echo.

if not defined MCMD (
    echo  !R![X]!X! Mercury no disponible
    echo  !Y!  Abre Mercury Console: mercury install coopevolved!X!
    start "" "https://github.com/Sledmine/coop-evolved"
    goto fin
)

echo  !W!  [->]!X! mercury install coopevolved
echo.
"!MCMD!" install coopevolved
if not errorlevel 1 (
    echo.
    echo  !G!  [OK]!X! Coop Evolved instalado
) else (
    echo  !Y!  [->]!X! Reintentando...
    "!MCMD!" install coopevolved --force 2>nul
    if not errorlevel 1 (
        echo  !G!  [OK]!X! Coop Evolved instalado
    ) else (
        echo  !R![X]!X! Error - abre Mercury Console: mercury install coopevolved
    )
)

:fin
echo.
echo.
echo  !DR!  ████████████████████████████████████████████████████████!X!
echo  !DR!  ██!X!                                                !DR!██!X!
echo  !DR!  ██!X!    !G!!BL! INSTALACION COMPLETADA !X!                     !DR!██!X!
echo  !DR!  ██!X!                                                !DR!██!X!
echo  !DR!  ██!X!  !W!Halo CE :!X! !HPATH!
echo  !DR!  ██!X!  !W!Version :!X! !G!1.0.10!X!                            !DR!██!X!
echo  !DR!  ██!X!  !W!Co-op   :!X! !G!hasta 16 jugadores!X!               !DR!██!X!
echo  !DR!  ██!X!                                                !DR!██!X!
echo  !DR!  ████████████████████████████████████████████████████████!X!
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
echo  !GR!  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓!X!
pause