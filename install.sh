#!/usr/bin/env bash
# install.sh — Mac / WSL2 / Linux installer
# Installs Dracula-themed tmux config (hardcoded, no plugin dependency)
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

# 2. Copy tmux-unix.conf → ~/.tmux.conf
cp "$DIR/tmux-unix.conf" "$HOME/.tmux.conf"
echo "✓ ~/.tmux.conf installed (Dracula theme)"

# 3. Font reminder
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set terminal font to: JetBrainsMono Nerd Font"
echo "  macOS: brew install --cask font-jetbrains-mono-nerd-font"
echo "  Ubuntu: download from https://www.nerdfonts.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Done! Run: tmux"
