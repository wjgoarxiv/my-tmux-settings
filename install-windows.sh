#!/usr/bin/env bash
# install-windows.sh — Windows (MSYS2 native tmux) installer
# Installs Tokyonight Night tmux config for native tmux on Windows
#
# Run from Git Bash or MSYS2 shell.
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

# ── 6. Install tmux.conf ────────────────────────────────────────
cp "$DIR/tmux-windows.conf" "$HOME/.tmux.conf"
echo "✓ ~/.tmux.conf installed (Tokyonight Night theme)"

# ── 7. Install sysinfo script ────────────────────────────────────
mkdir -p "$HOME/.tmux"
cp "$DIR/scripts/sysinfo.sh" "$HOME/.tmux/sysinfo.sh"
chmod +x "$HOME/.tmux/sysinfo.sh"
echo "✓ ~/.tmux/sysinfo.sh installed (CPU/MEM widget)"

# ── 8. Add tmux alias to .zshrc ──────────────────────────────────
if grep -qF "alias tmux=" "$HOME/.zshrc" 2>/dev/null; then
  echo "✓ tmux alias already in .zshrc"
else
  echo "" >> "$HOME/.zshrc"
  echo "# Native MSYS2 tmux with UTF-8 mode" >> "$HOME/.zshrc"
  echo "alias tmux='/usr/bin/tmux -u'" >> "$HOME/.zshrc"
  echo "✓ tmux alias added to .zshrc"
fi

# ── 9. Enable Windows Terminal builtinGlyphs ─────────────────────
WT_SETTINGS="$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
if [ -f "$WT_SETTINGS" ]; then
  if python -c "
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

# ── 10. Font reminder ────────────────────────────────────────────
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
