# install.ps1 — Windows (psmux) installer
# Self-contained Tokyonight Night config. No Node.js or bash required.
$ErrorActionPreference = "Stop"
$DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "=== my-tmux-settings installer (Windows / psmux) ===" -ForegroundColor Cyan

# 1. Copy tmux-windows.conf → ~/.tmux.conf
Copy-Item "$DIR\tmux-windows.conf" "$env:USERPROFILE\.tmux.conf"
Write-Host "✓ ~/.tmux.conf installed (Tokyonight Night theme)" -ForegroundColor Green

# 2. Install sysinfo script
$tmuxDir = Join-Path $env:USERPROFILE ".tmux"
if (-not (Test-Path $tmuxDir)) { New-Item -ItemType Directory -Path $tmuxDir | Out-Null }
Copy-Item "$DIR\scripts\sysinfo.sh" "$tmuxDir\sysinfo.sh"
Write-Host "✓ ~/.tmux/sysinfo.sh installed (CPU/MEM widget)" -ForegroundColor Green

# 3. Font reminder
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host "  Set Windows Terminal font to:" -ForegroundColor White
Write-Host "  JetBrainsMono Nerd Font" -ForegroundColor Cyan
Write-Host "  Install: choco install -y nerd-fonts-JetBrainsMono" -ForegroundColor Gray
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Magenta
Write-Host ""
Write-Host "Done! Start psmux." -ForegroundColor Green
