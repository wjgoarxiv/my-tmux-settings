# install.ps1 — Windows (psmux) installer
# No bash/TPM needed. Uses Node.js to generate hardcoded Dracula config.
$ErrorActionPreference = "Stop"
$DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== my-tmux-settings installer (Windows / psmux) ===" -ForegroundColor Cyan

# 1. Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Node.js required." -ForegroundColor Red
    Write-Host "Install: winget install OpenJS.NodeJS"
    exit 1
}
Write-Host ("✓ Node.js " + (node --version)) -ForegroundColor Green

# 2. Generate ~/.tmux.conf
Write-Host "Generating ~/.tmux.conf (Dracula, hardcoded)..." -ForegroundColor Yellow
node "$DIR\customize\gen-config.js"

# 3. Font reminder
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  Set Windows Terminal font to:" -ForegroundColor White
Write-Host "  JetBrainsMono Nerd Font" -ForegroundColor Cyan
Write-Host "  Install: choco install -y nerd-fonts-JetBrainsMono" -ForegroundColor Gray
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""
Write-Host "Done! Start psmux." -ForegroundColor Green
