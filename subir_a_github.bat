@echo off
chcp 65001 >nul
:: Lanzador del script de PowerShell para subir a GitHub sin necesitar Git instalado
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0push_to_github.ps1"
pause
