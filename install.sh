#!/usr/bin/env bash
# install.sh — Mac / WSL2 / Linux installer
# Uses official catppuccin/tmux bash plugin
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

# 2. Clone catppuccin/tmux plugin
PLUGIN_DIR="$HOME/.config/tmux/plugins/catppuccin/tmux"
if [ -d "$PLUGIN_DIR" ]; then
  echo "✓ catppuccin/tmux already exists — pulling latest"
  git -C "$PLUGIN_DIR" pull --quiet
else
  echo "  Cloning catppuccin/tmux..."
  mkdir -p "$HOME/.config/tmux/plugins/catppuccin"
  git clone --depth=1 https://github.com/catppuccin/tmux "$PLUGIN_DIR"
  echo "✓ catppuccin/tmux installed"
fi

# 3. Copy tmux-unix.conf → ~/.tmux.conf
cp "$DIR/tmux-unix.conf" "$HOME/.tmux.conf"
echo "✓ ~/.tmux.conf installed (catppuccin bash plugin)"

# 4. Font reminder
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set terminal font to: JetBrainsMono Nerd Font"
echo "  macOS: brew install --cask font-jetbrains-mono-nerd-font"
echo "  Ubuntu: download from https://www.nerdfonts.com"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Done! Run: tmux"
