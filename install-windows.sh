#!/usr/bin/env bash
# install-windows.sh — Windows (Git Bash + MSYS2 native tmux) installer
# Installs Catppuccin Mocha tmux config for native tmux on Windows
#
# IMPORTANT: This script should be run from Git Bash (not from MSYS2 shell).
# It sets up MSYS2 tmux + MSYS2 zsh as a native tmux environment on Windows.
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== my-tmux-settings installer (Windows / MSYS2 native tmux) ==="

# ── 1. Check MSYS2 ───────────────────────────────────────────────
MSYS2_ROOT="/c/msys64"
if [ ! -d "$MSYS2_ROOT" ]; then
  echo "ERROR: MSYS2 not found at $MSYS2_ROOT"
  echo "Install MSYS2 from https://www.msys2.org"
  exit 1
fi
echo "✓ MSYS2 found at $MSYS2_ROOT"

PACMAN="$MSYS2_ROOT/usr/bin/pacman.exe"

# ── 2. Install MSYS2 tmux ────────────────────────────────────────
if "$PACMAN" -Qs tmux &>/dev/null; then
  echo "✓ MSYS2 tmux already installed"
else
  echo "Installing MSYS2 tmux..."
  "$PACMAN" -S --noconfirm tmux
  echo "✓ MSYS2 tmux installed"
fi

# ── 3. Install MSYS2 zsh ─────────────────────────────────────────
# CRITICAL: Must use MSYS2's own zsh (not Git Bash's zsh).
# Git Bash's zsh uses a different MSYS2 runtime (msys-2.0.dll),
# causing PTY incompatibility with MSYS2 tmux — the shell starts
# but produces no visible output.
if "$PACMAN" -Qs zsh &>/dev/null; then
  echo "✓ MSYS2 zsh already installed"
else
  echo "Installing MSYS2 zsh..."
  "$PACMAN" -S --noconfirm zsh
  echo "✓ MSYS2 zsh installed"
fi

# ── 4. Fix MSYS2 HOME directory ──────────────────────────────────
# By default MSYS2 sets HOME=/home/Username. This must be changed
# to use the Windows home directory so zsh finds .zshrc, oh-my-zsh, etc.
NSS_CONF="$MSYS2_ROOT/etc/nsswitch.conf"
if grep -q "db_home: windows" "$NSS_CONF" 2>/dev/null; then
  echo "✓ MSYS2 HOME already set to Windows home"
else
  echo "Fixing MSYS2 HOME directory..."
  sed -i 's/db_home:.*/db_home: windows/' "$NSS_CONF"
  echo "✓ MSYS2 HOME set to Windows home ($USERPROFILE)"
fi

# ── 5. Remove psmux if it shadows tmux ───────────────────────────
WINGET_TMUX="$HOME/AppData/Local/Microsoft/WinGet/Links/tmux"
if [ -L "$WINGET_TMUX" ] && readlink "$WINGET_TMUX" | grep -qi psmux; then
  echo "⚠  psmux detected at $WINGET_TMUX (shadows native tmux)"
  echo "   Run from PowerShell: winget uninstall marlocarlo.psmux"
fi

# ── 6. Generate tmux.conf ────────────────────────────────────────
# Uses gen-config.js to produce a self-contained Catppuccin Mocha config
# with hardcoded powerline separators. The catppuccin/tmux plugin's
# source -F "#{d:current_file}/..." syntax doesn't work on MSYS2 tmux.
if ! command -v node &>/dev/null; then
  echo "ERROR: Node.js required for config generation."
  echo "Install: winget install OpenJS.NodeJS"
  exit 1
fi
echo "Generating ~/.tmux.conf (Catppuccin Mocha)..."
node "$DIR/customize/gen-config.js" --windows
echo "✓ ~/.tmux.conf installed"

# ── 7. Install sysinfo script ────────────────────────────────────
mkdir -p "$HOME/.tmux"
cp "$DIR/scripts/sysinfo.sh" "$HOME/.tmux/sysinfo.sh"
chmod +x "$HOME/.tmux/sysinfo.sh"
echo "✓ ~/.tmux/sysinfo.sh installed (CPU/MEM widget)"

# ── 8. Add tmux alias to .zshrc ──────────────────────────────────
ALIAS_LINE="alias tmux='MSYS2_PATH_TYPE=inherit /c/msys64/usr/bin/tmux.exe -u'"
if grep -qF 'MSYS2_PATH_TYPE=inherit' "$HOME/.zshrc" 2>/dev/null; then
  echo "✓ tmux alias already in .zshrc"
elif grep -qF "alias tmux=" "$HOME/.zshrc" 2>/dev/null; then
  echo "Updating tmux alias with MSYS2_PATH_TYPE=inherit..."
  sed -i "s|alias tmux=.*|$ALIAS_LINE|" "$HOME/.zshrc"
  echo "✓ tmux alias updated in .zshrc"
else
  echo "" >> "$HOME/.zshrc"
  echo "# Native MSYS2 tmux with UTF-8 mode" >> "$HOME/.zshrc"
  echo "$ALIAS_LINE" >> "$HOME/.zshrc"
  echo "✓ tmux alias added to .zshrc"
fi

# ── 9. Add Windows tool paths to .zshrc ────────────────────────
# MSYS2 tmux doesn't fully inherit the Windows user PATH.
# These paths ensure tools like node, nvim, git, eza, claude work inside tmux.
PATH_LINE='export PATH="$HOME/.local/bin:$HOME/AppData/Roaming/npm:/c/Program Files/Neovim/bin:/c/Program Files/nodejs:/c/ProgramData/chocolatey/bin:/c/Program Files/Git/cmd:$HOME/AppData/Local/Microsoft/WinGet/Links:$PATH"'
if grep -qF 'Program Files/nodejs' "$HOME/.zshrc" 2>/dev/null; then
  echo "✓ Windows tool paths already in .zshrc"
else
  echo "" >> "$HOME/.zshrc"
  echo "# Windows tool paths for MSYS2 tmux" >> "$HOME/.zshrc"
  echo "$PATH_LINE" >> "$HOME/.zshrc"
  echo "✓ Windows tool paths added to .zshrc"
fi

# ── 10. Enable Windows Terminal builtinGlyphs ────────────────────
WT_SETTINGS="$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
if [ -f "$WT_SETTINGS" ]; then
  PYTHON=$(command -v python3 2>/dev/null || command -v python 2>/dev/null || echo "")
  if [ -z "$PYTHON" ]; then
    echo "⚠  Python not found (skipping builtinGlyphs — enable manually in Windows Terminal settings)"
  elif "$PYTHON" -c "
import json, sys
with open(sys.argv[1], 'r', encoding='utf-8') as f:
    d = json.load(f)
defaults = d.setdefault('profiles', {}).setdefault('defaults', {})
if defaults.get('builtinGlyphs') is not True:
    defaults['builtinGlyphs'] = True
    with open(sys.argv[1], 'w', encoding='utf-8') as f:
        json.dump(d, f, indent=4, ensure_ascii=False)
    print('enabled')
else:
    print('already')
" "$WT_SETTINGS" 2>/dev/null | grep -q "enabled"; then
    echo "✓ Windows Terminal builtinGlyphs enabled"
  else
    echo "✓ Windows Terminal builtinGlyphs already enabled"
  fi
else
  echo "⚠  Windows Terminal settings not found (skipping builtinGlyphs)"
fi

# ── 11. Font reminder ────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set Windows Terminal font to: JetBrainsMono Nerd Font"
echo "  Install: choco install -y nerd-fonts-JetBrainsMono"
echo ""
echo "  IMPORTANT: Close and reopen Windows Terminal after install"
echo "  to apply builtinGlyphs and font changes."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Done! Open a new terminal and run: tmux"
