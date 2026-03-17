#!/usr/bin/env bash
# install.sh — Mac / WSL2 / Linux installer
# Installs Catppuccin Mocha tmux config with catppuccin/tmux plugin
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

# 2. Install catppuccin/tmux plugin
PLUGIN_DIR="$HOME/.config/tmux/plugins/catppuccin/tmux"
if [ -d "$PLUGIN_DIR" ]; then
  echo "✓ catppuccin/tmux plugin already installed"
else
  echo "Installing catppuccin/tmux plugin..."
  mkdir -p "$(dirname "$PLUGIN_DIR")"
  git clone https://github.com/catppuccin/tmux.git "$PLUGIN_DIR"
  echo "✓ catppuccin/tmux plugin installed"
fi

# 3. Copy tmux.conf → ~/.tmux.conf
cp "$DIR/tmux.conf" "$HOME/.tmux.conf"
echo "✓ ~/.tmux.conf installed (Catppuccin Mocha theme)"

# 4. Install sysinfo script
mkdir -p "$HOME/.tmux"
cp "$DIR/scripts/sysinfo.sh" "$HOME/.tmux/sysinfo.sh"
chmod +x "$HOME/.tmux/sysinfo.sh"
echo "✓ ~/.tmux/sysinfo.sh installed (CPU/MEM widget)"

# 5. Font reminder
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set terminal font to: JetBrainsMono Nerd Font"
echo "  macOS: brew install --cask font-jetbrains-mono-nerd-font"
echo "  Ubuntu: download from https://www.nerdfonts.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Done! Run: tmux"
