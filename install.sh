#!/usr/bin/env bash
# install.sh — macOS / Linux installer for my-tmux-settings
# Usage: bash install.sh

set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== my-tmux-settings installer (macOS/Linux) ==="

# 1. Check tmux
if ! command -v tmux &>/dev/null; then
  echo "tmux not found. Install with:"
  echo "  macOS:  brew install tmux"
  echo "  Ubuntu: sudo apt install tmux"
  exit 1
fi
echo "✓ tmux $(tmux -V)"

# 2. Generate config
if command -v node &>/dev/null; then
  echo "✓ Node.js found — generating config with Nerd Font glyphs"
  node "$DIR/customize/gen-config.js"
else
  echo "⚠ Node.js not found — copying pre-built tmux.conf"
  cp "$DIR/tmux.conf" "$HOME/.tmux.conf"
  echo "✓ Copied to ~/.tmux.conf"
fi

# 3. Font reminder
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set terminal font to: JetBrainsMono Nerd Font"
echo "  Install: brew install --cask font-jetbrains-mono-nerd-font"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Done! Start tmux and enjoy your Dracula theme."
