@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title HALO CE COOP - bt pr3ttywhit3

:: ╔══════════════════════════════════════════════╗
:: ║  ASCII ART + COLOR ROJO/NEGRO                ║
:: ╚══════════════════════════════════════════════╝

cls

:: Activar color ANSI en Windows 10+
for /f "tokens=*" %%a in ('reg query "HKEY_CURRENT_USER\Console" /v VirtualTerminalLevel 2^>nul') do set "VT=%%a"
reg add "HKEY_CURRENT_USER\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1

:: Secuencias ANSI
set "RED=[91m"
set "DARKRED=[31m"
set "BLACK=[30m"
set "WHITE=[97m"
set "GRAY=[90m"
set "YELLOW=[93m"
set "GREEN=[92m"
set "CYAN=[96m"
set "RESET=[0m"
set "BG_BLACK=[40m"
set "BOLD=[1m"

echo.
echo %RED%%BOLD%  ██╗  ██╗ █████╗ ██╗      ██████╗      ██████╗███████╗%RESET%
echo %RED%%BOLD%  ██║  ██║██╔══██╗██║     ██╔═══██╗    ██╔════╝██╔════╝%RESET%
echo %DARKRED%%BOLD%  ███████║███████║██║     ██║   ██║    ██║     █████╗  %RESET%
echo %DARKRED%%BOLD%  ██╔══██║██╔══██║██║     ██║   ██║    ██║     ██╔══╝  %RESET%
echo %RED%%BOLD%  ██║  ██║██║  ██║███████╗╚██████╔╝    ╚██████╗███████╗%RESET%
echo %RED%%BOLD%  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝      ╚═════╝╚══════╝%RESET%
echo.
echo %DARKRED%  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄%RESET%
echo %DARKRED%  ██%RESET%  %WHITE%%BOLD%C O O P   E V O L V E D   I N S T A L L E R%RESET%  %DARKRED%██%RESET%
echo %DARKRED%  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀%RESET%
echo.
echo                     %GRAY%by%RESET% %RED%%BOLD%bt pr3ttywhit3%RESET%
echo %GRAY%  ─────────────────────────────────────────────────────────%RESET%
echo.

:: ─── VERIFICAR ADMIN ────────────────────────────────────────────
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  %RED%[✗] Se necesitan permisos de Administrador.%RESET%
    echo  %YELLOW%[!] Haz clic derecho → "Ejecutar como administrador"%RESET%
    echo.
    pause
    exit /b 1
)
echo  %GREEN%[✓]%RESET% Permisos de administrador OK
echo.

:: ─── VARIABLES GLOBALES ─────────────────────────────────────────
set "INSTALL_DIR=%~dp0"
set "DOWNLOADS=%INSTALL_DIR%downloads"
set "HALOCE_REG_KEY64=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Microsoft Games\Halo CE"
set "HALOCE_REG_KEY32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Games\Halo CE"
set "HALOCE_DEFAULT=C:\Program Files (x86)\Microsoft Games\Halo Custom Edition"
set "LATEST_VERSION=1.0.10.0621"
set "HALOCE_INSTALLED=0"
set "HALOCE_OUTDATED=0"
set "HALOCE_PATH="

mkdir "%DOWNLOADS%" 2>nul

:: ─────────────────────────────────────────────────────────────────
::   PASO 1 — DETECCIÓN DEL JUEGO
:: ─────────────────────────────────────────────────────────────────
echo  %CYAN%[PASO 1/5]%RESET% %BOLD%Detectando Halo Custom Edition...%RESET%
echo  %GRAY%  ──────────────────────────────────────────%RESET%

:: Buscar en registro (64-bit)
for /f "tokens=2*" %%a in ('reg query "%HALOCE_REG_KEY64%" /v "EXE Path" 2^>nul') do set "HALOCE_PATH=%%b"
:: Buscar en registro (32-bit)
if not defined HALOCE_PATH (
    for /f "tokens=2*" %%a in ('reg query "%HALOCE_REG_KEY32%" /v "EXE Path" 2^>nul') do set "HALOCE_PATH=%%b"
)
:: Buscar por ruta por defecto
if not defined HALOCE_PATH (
    if exist "%HALOCE_DEFAULT%\halo.exe" set "HALOCE_PATH=%HALOCE_DEFAULT%"
)
:: Buscar rutas alternativas
if not defined HALOCE_PATH (
    if exist "C:\Program Files\Microsoft Games\Halo Custom Edition\halo.exe" (
        set "HALOCE_PATH=C:\Program Files\Microsoft Games\Halo Custom Edition"
    )
)

if defined HALOCE_PATH (
    set "HALOCE_INSTALLED=1"
    echo  %GREEN%  [✓] Halo CE encontrado en:%RESET%
    echo       %WHITE%%HALOCE_PATH%%RESET%
    echo.
    
    :: Verificar version del ejecutable
    for /f "delims=" %%v in ('powershell -Command "(Get-Item '%HALOCE_PATH%\halo.exe').VersionInfo.FileVersion" 2^>nul') do set "CURRENT_VERSION=%%v"
    
    if defined CURRENT_VERSION (
        echo  %GRAY%  Versión instalada: %WHITE%%CURRENT_VERSION%%RESET%
        echo  %GRAY%  Versión más reciente: %WHITE%%LATEST_VERSION%%RESET%
        
        :: Comparar versiones - si no contiene 1.0.10 está desactualizado
        echo %CURRENT_VERSION% | findstr /C:"1.0.10" >nul 2>&1
        if %errorLevel% neq 0 (
            set "HALOCE_OUTDATED=1"
            echo  %YELLOW%  [!] VERSION DESACTUALIZADA → Se aplicará el parche 1.0.10%RESET%
        ) else (
            echo  %GREEN%  [✓] Versión actualizada (1.0.10) — Sin necesidad de parche%RESET%
        )
    ) else (
        :: Si no podemos leer la version, asumimos desactualizado por seguridad
        set "HALOCE_OUTDATED=1"
        echo  %YELLOW%  [!] No se pudo verificar la version → Se aplicará el parche%RESET%
    )
) else (
    echo  %YELLOW%  [!] Halo CE NO encontrado → Se instalará%RESET%
    set "HALOCE_INSTALLED=0"
    set "HALOCE_OUTDATED=0"
)
echo.

:: ─────────────────────────────────────────────────────────────────
::   PASO 2 — INSTALAR / ACTUALIZAR HALO CE
:: ─────────────────────────────────────────────────────────────────
echo  %CYAN%[PASO 2/5]%RESET% %BOLD%Halo CE Custom Edition%RESET%
echo  %GRAY%  ──────────────────────────────────────────%RESET%

if "%HALOCE_INSTALLED%"=="1" (
    if "%HALOCE_OUTDATED%"=="0" (
        echo  %GREEN%  [✓] Halo CE ya instalado y actualizado — Saltando instalación%RESET%
        goto :check_patch_skip
    ) else (
        echo  %YELLOW%  [→] Halo CE instalado pero desactualizado → Aplicando parche...%RESET%
        goto :apply_patch
    )
)

:: Instalar Halo CE desde cero
set "HCE_EXE=%DOWNLOADS%\hce_setup.exe"

if exist "%HCE_EXE%" (
    echo  %GREEN%  [✓] Instalador ya en caché%RESET%
) else (
    echo  %WHITE%  [↓] Descargando Halo CE installer...%RESET%
    curl -L --max-time 300 --progress-bar -o "%HCE_EXE%" "http://hce.halomaps.org/files/hce_setup.exe" 2>nul
    if not exist "%HCE_EXE%" (
        echo  %YELLOW%  [!] Descarga directa fallida. Abriendo HaloMaps...%RESET%
        start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=410"
        echo.
        echo  %WHITE%  Descarga "hce_setup.exe" y guárdalo en:%RESET%
        echo  %YELLOW%  %DOWNLOADS%\hce_setup.exe%RESET%
        echo.
        pause
    )
)

if exist "%HCE_EXE%" (
    echo  %WHITE%  [→] Ejecutando instalador de Halo CE...%RESET%
    echo  %GRAY%     (Instala en la ruta por defecto)%RESET%
    start /wait "" "%HCE_EXE%"
    echo  %GREEN%  [✓] Instalación completada%RESET%
    
    :: Re-detectar ruta después de instalación
    for /f "tokens=2*" %%a in ('reg query "%HALOCE_REG_KEY64%" /v "EXE Path" 2^>nul') do set "HALOCE_PATH=%%b"
    if not defined HALOCE_PATH (
        for /f "tokens=2*" %%a in ('reg query "%HALOCE_REG_KEY32%" /v "EXE Path" 2^>nul') do set "HALOCE_PATH=%%b"
    )
    if not defined HALOCE_PATH (
        if exist "%HALOCE_DEFAULT%\halo.exe" set "HALOCE_PATH=%HALOCE_DEFAULT%"
    )
    set "HALOCE_OUTDATED=1"
)
echo.

:apply_patch
:: ─────────────────────────────────────────────────────────────────
::   PASO 3 — PARCHE 1.0.10
:: ─────────────────────────────────────────────────────────────────
echo  %CYAN%[PASO 3/5]%RESET% %BOLD%Parche Oficial v1.0.10%RESET%
echo  %GRAY%  ──────────────────────────────────────────%RESET%

if "%HALOCE_OUTDATED%"=="0" (
    echo  %GREEN%  [✓] No se necesita parche%RESET%
    goto :install_mercury
)

set "PATCH_EXE=%DOWNLOADS%\haloce_patch_1_0_10.exe"

if exist "%PATCH_EXE%" (
    echo  %GREEN%  [✓] Parche ya en caché%RESET%
) else (
    echo  %WHITE%  [↓] Descargando parche v1.0.10...%RESET%
    curl -L --max-time 120 --progress-bar -o "%PATCH_EXE%" "http://hce.halomaps.org/files/haloce_patch_1_0_10.exe" 2>nul
    if not exist "%PATCH_EXE%" (
        :: Fuente alternativa
        curl -L --max-time 120 --progress-bar -o "%PATCH_EXE%" "https://www.moddb.com/downloads/mirror/halo-custom-edition-patch-1010" 2>nul
    )
)

if exist "%PATCH_EXE%" (
    echo  %WHITE%  [→] Aplicando parche 1.0.10...%RESET%
    start /wait "" "%PATCH_EXE%"
    echo  %GREEN%  [✓] Parche aplicado — Halo CE v1.0.10 activo%RESET%
) else (
    echo  %YELLOW%  [!] No se pudo descargar el parche. Descárgalo manualmente:%RESET%
    echo  %GRAY%      https://hce.halomaps.org/index.cfm?pg=3^&fid=6798%RESET%
    start "" "https://hce.halomaps.org/index.cfm?pg=3&fid=6798"
    pause
)

:check_patch_skip
:install_mercury
echo.

:: ─────────────────────────────────────────────────────────────────
::   PASO 4 — MERCURY (gestor de mods)
:: ─────────────────────────────────────────────────────────────────
echo  %CYAN%[PASO 4/5]%RESET% %BOLD%Mercury — Gestor de Mods%RESET%
echo  %GRAY%  ──────────────────────────────────────────%RESET%

set "MERCURY_CMD="
where mercury >nul 2>&1
if %errorLevel% equ 0 (
    set "MERCURY_CMD=mercury"
    echo  %GREEN%  [✓] Mercury ya instalado%RESET%
    goto :install_coop
)
if exist "%LOCALAPPDATA%\mercury\mercury.exe" (
    set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
    echo  %GREEN%  [✓] Mercury encontrado en AppData%RESET%
    goto :install_coop
)
if exist "%ProgramFiles%\mercury\mercury.exe" (
    set "MERCURY_CMD=%ProgramFiles%\mercury\mercury.exe"
    echo  %GREEN%  [✓] Mercury encontrado en Program Files%RESET%
    goto :install_coop
)

echo  %WHITE%  [↓] Descargando Mercury desde GitHub Releases...%RESET%
powershell -Command "try { $r = Invoke-RestMethod 'https://api.github.com/repos/Sledmine/mercury/releases/latest'; $a = $r.assets | Where-Object { $_.name -like '*.exe' } | Select-Object -First 1; if ($a) { Invoke-WebRequest $a.browser_download_url -OutFile '%DOWNLOADS%\mercury-installer.exe' -UseBasicParsing; Write-Host '  OK: ' $a.name } else { Write-Host '  [!] No se encontro asset .exe' } } catch { Write-Host '  ERROR: ' $_.Exception.Message }"

if exist "%DOWNLOADS%\mercury-installer.exe" (
    echo  %WHITE%  [→] Instalando Mercury...%RESET%
    start /wait "" "%DOWNLOADS%\mercury-installer.exe" /S 2>nul
    start /wait "" "%DOWNLOADS%\mercury-installer.exe" 2>nul
    :: Actualizar PATH
    for /f "tokens=*" %%p in ('powershell -Command "[Environment]::GetEnvironmentVariable(\"PATH\",\"Machine\")"') do set "PATH=%%p;%PATH%"
    
    where mercury >nul 2>&1
    if %errorLevel% equ 0 (
        set "MERCURY_CMD=mercury"
        echo  %GREEN%  [✓] Mercury instalado y listo%RESET%
    ) else if exist "%LOCALAPPDATA%\mercury\mercury.exe" (
        set "MERCURY_CMD=%LOCALAPPDATA%\mercury\mercury.exe"
        echo  %GREEN%  [✓] Mercury instalado en AppData%RESET%
    ) else (
        echo  %YELLOW%  [!] Mercury instalado - reinicia el script si falla el siguiente paso%RESET%
    )
) else (
    echo  %YELLOW%  [!] Descarga de Mercury fallida. Descárgalo desde:%RESET%
    echo  %GRAY%      https://github.com/Sledmine/mercury/releases/latest%RESET%
    start "" "https://github.com/Sledmine/mercury/releases/latest"
    echo  %GRAY%  Instala y presiona una tecla para continuar...%RESET%
    pause >nul
    where mercury >nul 2>&1
    if %errorLevel% equ 0 set "MERCURY_CMD=mercury"
)

:install_coop
echo.

:: ─────────────────────────────────────────────────────────────────
::   PASO 5 — COOP EVOLVED
:: ─────────────────────────────────────────────────────────────────
echo  %CYAN%[PASO 5/5]%RESET% %BOLD%Coop Evolved — Co-op Campaña%RESET%
echo  %GRAY%  ──────────────────────────────────────────%RESET%
echo  %GRAY%  (Incluye Chimera + hasta 16 jugadores LAN/Internet)%RESET%
echo.

if not defined MERCURY_CMD (
    echo  %RED%  [✗] Mercury no disponible — no se puede instalar Coop Evolved%RESET%
    echo  %YELLOW%  [!] Instalación manual:%RESET%
    echo  %WHITE%      1. Abre "Mercury Console" desde el Escritorio%RESET%
    echo  %WHITE%      2. Escribe: mercury install coopevolved%RESET%
    start "" "https://github.com/Sledmine/coop-evolved"
    goto :fin
)

echo  %WHITE%  [→] Ejecutando: mercury install coopevolved%RESET%
echo.
"%MERCURY_CMD%" install coopevolved

if %errorLevel% equ 0 (
    echo.
    echo  %GREEN%  [✓] Coop Evolved instalado correctamente!%RESET%
) else (
    echo.
    echo  %YELLOW%  [!] Mercury retornó error. Intentando de nuevo con --force...%RESET%
    "%MERCURY_CMD%" install coopevolved --force 2>nul
    if %errorLevel% equ 0 (
        echo  %GREEN%  [✓] Coop Evolved instalado!%RESET%
    ) else (
        echo  %RED%  [✗] Fallo la instalación automática.%RESET%
        echo  %YELLOW%  [!] Manual: Abre Mercury Console y escribe "mercury install coopevolved"%RESET%
    )
)

:fin
echo.
echo.
echo  %DARKRED%▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄%RESET%
echo  %DARKRED%██%RESET%                                               %DARKRED%██%RESET%
echo  %DARKRED%██%RESET%   %GREEN%%BOLD%✓ INSTALACIÓN COMPLETADA%RESET%                     %DARKRED%██%RESET%
echo  %DARKRED%██%RESET%                                               %DARKRED%██%RESET%
echo  %DARKRED%██%RESET%   %WHITE%Halo CE:%RESET%  %HALOCE_PATH%
echo  %DARKRED%██%RESET%   %WHITE%Versión:%RESET%  %GREEN%1.0.10 (última)%RESET%                   %DARKRED%██%RESET%
echo  %DARKRED%██%RESET%   %WHITE%Co-op:%RESET%    %GREEN%Coop Evolved — hasta 16 jugadores%RESET%  %DARKRED%██%RESET%
echo  %DARKRED%██%RESET%                                               %DARKRED%██%RESET%
echo  %DARKRED%▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄▄▄▄▄▄▄▄▄%RESET%
echo.
echo  %GRAY%  Cómo jugar en co-op:%RESET%
echo  %WHITE%  1. Lanza Halo CE%RESET%
echo  %WHITE%  2. Multijugador → Unirse a juego → busca "coop"%RESET%
echo  %WHITE%  3. O crea servidor: halo.exe -window -console%RESET%
echo  %WHITE%     → sv_map a10 slayer%RESET%
echo.
echo  %DARKRED%                     bt pr3ttywhit3%RESET%
echo  %GRAY%  github.com/milkaarleth2-svg/HaloCE-CoopEvolved%RESET%
echo.
echo  %GRAY%  ─────────────────────────────────────────────────────%RESET%
pause
