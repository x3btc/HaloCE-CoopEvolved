# ============================================================
# push_to_github.ps1
# Sube los archivos del proyecto a GitHub via API REST
# No necesita Git instalado localmente
# ============================================================

param(
    [string]$GitHubUser = "",
    [string]$Token = "",
    [string]$RepoName = "HaloCE-CoopEvolved"
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Push a GitHub via API - Sin Git necesario     ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Pedir datos si no se pasaron como argumentos
if (!$GitHubUser) { $GitHubUser = Read-Host "Tu usuario de GitHub" }
if (!$Token) {
    Write-Host ""
    Write-Host "[*] Necesitas un Personal Access Token (PAT) con permisos 'repo'" -ForegroundColor Yellow
    Write-Host "[*] Crear token en: https://github.com/settings/tokens/new" -ForegroundColor Yellow
    Start-Process "https://github.com/settings/tokens/new?scopes=repo&description=HaloCE-Installer"
    Write-Host ""
    $TokenSecure = Read-Host "Pega tu GitHub Token aqui" -AsSecureString
    $Token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($TokenSecure))
}

$headers = @{
    "Authorization" = "token $Token"
    "User-Agent"    = "HaloCE-CoopEvolved-Installer"
    "Accept"        = "application/vnd.github.v3+json"
}

# ─── 1. Crear el repositorio ───────────────────────────────
Write-Host "[*] Creando repositorio '$RepoName' en GitHub..." -ForegroundColor Green

$repoBody = @{
    name        = $RepoName
    description = "Instalador automatico de Halo CE Custom Edition + Coop Evolved mod (co-op campaña hasta 16 jugadores)"
    private     = $false
    auto_init   = $false
} | ConvertTo-Json

try {
    $repo = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method POST -Headers $headers -Body $repoBody -ContentType "application/json"
    Write-Host "[OK] Repositorio creado: $($repo.html_url)" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 422) {
        Write-Host "[*] El repositorio ya existe, continuando..." -ForegroundColor Yellow
    } else {
        Write-Host "[ERROR] No se pudo crear el repo: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# ─── 2. Subir cada archivo ─────────────────────────────────
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$files = @(
    "instalar_haloce_coop.bat",
    "subir_a_github.bat",
    "README.md",
    ".gitignore"
)

foreach ($file in $files) {
    $filePath = Join-Path $scriptDir $file
    if (!(Test-Path $filePath)) {
        Write-Host "[!] Archivo no encontrado: $file" -ForegroundColor Yellow
        continue
    }

    $content = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($filePath))
    
    $fileBody = @{
        message = "feat: add $file"
        content = $content
    } | ConvertTo-Json

    $apiUrl = "https://api.github.com/repos/$GitHubUser/$RepoName/contents/$file"
    
    try {
        # Intentar crear (PUT)
        $result = Invoke-RestMethod -Uri $apiUrl -Method PUT -Headers $headers -Body $fileBody -ContentType "application/json"
        Write-Host "[OK] Subido: $file" -ForegroundColor Green
    } catch {
        if ($_.Exception.Response.StatusCode -eq 422) {
            # El archivo ya existe, obtener SHA y actualizar
            try {
                $existing = Invoke-RestMethod -Uri $apiUrl -Method GET -Headers $headers
                $updateBody = @{
                    message = "update: $file"
                    content = $content
                    sha     = $existing.sha
                } | ConvertTo-Json
                Invoke-RestMethod -Uri $apiUrl -Method PUT -Headers $headers -Body $updateBody -ContentType "application/json" | Out-Null
                Write-Host "[OK] Actualizado: $file" -ForegroundColor Green
            } catch {
                Write-Host "[!] Error actualizando $file`: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        } else {
            Write-Host "[!] Error subiendo $file`: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   ✅ SUBIDO A GITHUB EXITOSAMENTE               ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "URL: https://github.com/$GitHubUser/$RepoName" -ForegroundColor White
Write-Host ""
Start-Process "https://github.com/$GitHubUser/$RepoName"
