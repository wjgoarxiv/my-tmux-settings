# install.ps1 — Windows (psmux) installer
# No bash/TPM needed. Uses Node.js to generate hardcoded Tokyonight Night config.
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
Write-Host "Generating ~/.tmux.conf (Tokyonight Night, hardcoded)..." -ForegroundColor Yellow
node "$DIR\customize\gen-config.js"

# 3. Install sysinfo script
$tmuxDir = Join-Path $env:USERPROFILE ".tmux"
if (-not (Test-Path $tmuxDir)) { New-Item -ItemType Directory -Path $tmuxDir | Out-Null }
Copy-Item "$DIR\scripts\sysinfo.sh" "$tmuxDir\sysinfo.sh"
Write-Host "✓ ~/.tmux/sysinfo.sh installed (CPU/MEM widget)" -ForegroundColor Green

# 4. Font reminder
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  Set Windows Terminal font to:" -ForegroundColor White
Write-Host "  JetBrainsMono Nerd Font" -ForegroundColor Cyan
Write-Host "  Install: choco install -y nerd-fonts-JetBrainsMono" -ForegroundColor Gray
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""
Write-Host "Done! Start psmux." -ForegroundColor Green
