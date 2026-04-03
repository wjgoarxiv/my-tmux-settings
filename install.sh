#!/usr/bin/env bash
# install.sh — Mac / WSL2 / Linux installer
# Installs Tokyonight Night tmux config (self-contained, no plugins needed)
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== my-tmux-settings installer (Mac / WSL2 / Linux) ==="

# 1. Check tmux
if ! command -v tmux &>/dev/null; then
  echo "tmux not found. Install:"
  echo "  macOS:  brew install tmux"
  echo "  Ubuntu: sudo apt install tmux"
  exit 1
fi
echo "✓ $(tmux -V)"

# 2. Copy tmux.conf → ~/.tmux.conf
cp "$DIR/tmux.conf" "$HOME/.tmux.conf"
echo "✓ ~/.tmux.conf installed (Tokyonight Night theme)"

# 3. Install sysinfo script
mkdir -p "$HOME/.tmux"
cp "$DIR/scripts/sysinfo.sh" "$HOME/.tmux/sysinfo.sh"
chmod +x "$HOME/.tmux/sysinfo.sh"
echo "✓ ~/.tmux/sysinfo.sh installed (CPU/MEM widget)"

# 4. Font reminder
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set terminal font to: JetBrainsMono Nerd Font"
echo "  macOS: brew install --cask font-jetbrains-mono-nerd-font"
echo "  Ubuntu: download from https://www.nerdfonts.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Done! Run: tmux"
