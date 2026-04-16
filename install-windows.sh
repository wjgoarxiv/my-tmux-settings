#!/usr/bin/env bash
# install-windows.sh - Windows (MSYS2 native tmux) installer
# Installs Tokyonight Night tmux config for native tmux on Windows.
#
# Run from Git Bash or MSYS2 shell.
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== my-tmux-settings installer (Windows / MSYS2 native tmux) ==="

MSYS2_ROOT="/c/msys64"
if [ ! -d "$MSYS2_ROOT" ]; then
  echo "ERROR: MSYS2 not found at $MSYS2_ROOT"
  echo "Install MSYS2 from https://www.msys2.org"
  exit 1
fi
echo "MSYS2 found at $MSYS2_ROOT"

PACMAN="$MSYS2_ROOT/usr/bin/pacman.exe"

if "$PACMAN" -Qs tmux >/dev/null 2>&1; then
  echo "MSYS2 tmux already installed"
else
  echo "Installing MSYS2 tmux..."
  "$PACMAN" -S --noconfirm tmux
  echo "MSYS2 tmux installed"
fi

# Must use MSYS2's own zsh, not Git Bash's zsh.
if "$PACMAN" -Qs zsh >/dev/null 2>&1; then
  echo "MSYS2 zsh already installed"
else
  echo "Installing MSYS2 zsh..."
  "$PACMAN" -S --noconfirm zsh
  echo "MSYS2 zsh installed"
fi

NSS_CONF="$MSYS2_ROOT/etc/nsswitch.conf"
if grep -q "db_home: windows" "$NSS_CONF" 2>/dev/null; then
  echo "MSYS2 HOME already set to Windows home"
else
  echo "Fixing MSYS2 HOME directory..."
  sed -i 's/db_home:.*/db_home: windows/' "$NSS_CONF"
  echo "MSYS2 HOME set to Windows home ($USERPROFILE)"
fi

# Remove WinGet psmux shims so UCRT64/MSYS2 never resolves tmux to psmux.
WINGET_LINK_DIR="$HOME/AppData/Local/Microsoft/WinGet/Links"
for _link in \
  "$WINGET_LINK_DIR/tmux.exe" \
  "$WINGET_LINK_DIR/tmux" \
  "$WINGET_LINK_DIR/psmux.exe"
do
  if [ -L "$_link" ] && readlink "$_link" | grep -qi psmux; then
    rm -f "$_link"
    echo "removed WinGet psmux shim: $_link"
  fi
done
unset _link

cp "$DIR/tmux-windows.conf" "$HOME/.tmux.conf"
echo "~/.tmux.conf installed (Tokyonight Night theme)"

mkdir -p "$HOME/.tmux"
cp "$DIR/scripts/sysinfo.sh" "$HOME/.tmux/sysinfo.sh"
chmod +x "$HOME/.tmux/sysinfo.sh"
echo "~/.tmux/sysinfo.sh installed (CPU/MEM widget)"

if grep -qF "alias tmux=" "$HOME/.zshrc" 2>/dev/null; then
  echo "tmux alias already in .zshrc"
else
  echo "" >> "$HOME/.zshrc"
  echo "# Native MSYS2 tmux with UTF-8 mode" >> "$HOME/.zshrc"
  echo "alias tmux='MSYS2_PATH_TYPE=inherit /c/msys64/usr/bin/tmux.exe -u'" >> "$HOME/.zshrc"
  echo "tmux alias added to .zshrc"
fi

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
    echo "Windows Terminal builtinGlyphs enabled"
  else
    echo "Windows Terminal builtinGlyphs already enabled"
  fi
else
  echo "Windows Terminal settings not found (skipping builtinGlyphs)"
fi

echo ""
echo "Set Windows Terminal font to: JetBrainsMono Nerd Font"
echo "Install: choco install -y nerd-fonts-JetBrainsMono"
echo ""
echo "IMPORTANT: Close and reopen Windows Terminal after install"
echo "to apply builtinGlyphs and font changes."
echo ""
echo "Done. Open a new terminal and run: tmux"
