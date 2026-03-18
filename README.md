# my-tmux-settings

Catppuccin Mocha tmux configuration with powerline status bar, Nerd Font icons, and CPU/MEM widget.

Supports **macOS / WSL2 / Linux** (catppuccin plugin), **Windows native tmux** (MSYS2 + Git Bash), and **Windows psmux** (PowerShell).

---

## Platform Support

| Platform | Method | Shell | Theme |
|---|---|---|---|
| **macOS / WSL2 / Linux** | catppuccin/tmux plugin | Any | Catppuccin Mocha |
| **Windows (MSYS2 native tmux)** | Hardcoded config via Node.js | MSYS2 zsh + Git Bash configs | Catppuccin Mocha |
| **Windows (psmux)** | Hardcoded config via Node.js | PowerShell | Catppuccin Mocha |

---

## Requirements

### macOS / WSL2 / Linux
- tmux (`brew install tmux` / `apt install tmux`)
- git
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com): `brew install --cask font-jetbrains-mono-nerd-font`

### Windows (MSYS2 native tmux) — Recommended
- [Git Bash](https://git-scm.com) with zsh + oh-my-zsh + powerlevel10k
- [MSYS2](https://www.msys2.org) (for native tmux + zsh)
- [Node.js](https://nodejs.org)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com): `choco install -y nerd-fonts-JetBrainsMono`
- [Windows Terminal](https://aka.ms/terminal) with `builtinGlyphs` enabled

### Windows (psmux)
- [psmux](https://github.com/marlocarlo/psmux)
- [Node.js](https://nodejs.org)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com)

---

## Quick Install

### macOS / WSL2 / Linux
```bash
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install.sh
```

### Windows (MSYS2 native tmux) — Recommended
```bash
# Run from Git Bash
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install-windows.sh
```

### Windows (psmux)
```powershell
git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
powershell -File $HOME/my-tmux-settings/install.ps1
```

---

## What the Installers Do

### `install.sh` (macOS / Linux)
1. Installs [catppuccin/tmux](https://github.com/catppuccin/tmux) plugin
2. Copies `tmux.conf` → `~/.tmux.conf`
3. Installs `sysinfo.sh` CPU/MEM widget

### `install-windows.sh` (MSYS2 native tmux)
1. Installs MSYS2 tmux and zsh via pacman
2. Fixes MSYS2 HOME to use Windows home directory
3. Generates hardcoded Catppuccin Mocha `~/.tmux.conf` via Node.js
4. Installs `sysinfo.sh` CPU/MEM widget
5. Adds tmux alias to `.zshrc`
6. Enables Windows Terminal `builtinGlyphs`

### `install.ps1` (psmux)
1. Generates hardcoded Catppuccin Mocha `~/.tmux.conf` via Node.js
2. Installs `sysinfo.sh`

---

## Key Bindings

| Key | Action |
|---|---|
| `Ctrl+b` | Prefix |
| `Ctrl+b \|` | Split left/right |
| `Ctrl+b -` | Split top/bottom |
| `Ctrl+b h/j/k/l` | Vim-style pane navigation |
| `Ctrl+b r` | Reload config |
| `Ctrl+b z` | Zoom pane |
| `Ctrl+b d` | Detach session |

---

## Features

- **Catppuccin Mocha** color scheme across status bar, panes, and messages
- **Powerline triangle** segments with Nerd Font icons
- **CPU/MEM** widget via `sysinfo.sh` (cross-platform: macOS, Linux, Windows)
- **DEC 2026 Synchronized Output** — eliminates flicker in Claude Code and other fast-output tools
- **focus-events** enabled for better editor integration
- **Mouse** support with tuned scroll speed
- **allow-passthrough** for image/sixel protocols

---

## Customize Colors

Edit `customize/gen-config.js` — change the Catppuccin Mocha hex values at the top, then:
```bash
node customize/gen-config.js             # generic
node customize/gen-config.js --windows   # Windows MSYS2 native
node customize/gen-config.js --preview   # preview to stdout
# In tmux: Ctrl+b → r to reload
```

---

## Windows MSYS2 Native tmux — Technical Notes

Running native tmux on Windows via MSYS2 + Git Bash requires several non-obvious fixes. These are all handled by `install-windows.sh`, but documented here for reference:

| Issue | Root Cause | Fix |
|---|---|---|
| **psmux shadows tmux** | WinGet installs psmux as `tmux` in PATH | Uninstall psmux or alias tmux to MSYS2 binary |
| **Shell produces no output** | Git Bash zsh uses different MSYS2 runtime (msys-2.0.dll) than MSYS2 tmux → PTY incompatibility | Install zsh in MSYS2 via `pacman -S zsh` |
| **HOME is /home/Username** | MSYS2 default `nsswitch.conf` uses `db_home: cygwin` | Change to `db_home: windows` in `/c/msys64/etc/nsswitch.conf` |
| **Powerline chars render as blocks** | tmux `-u` flag missing; MSYS2 wcwidth wrong for PUA chars | Add `-u` flag to tmux alias |
| **Powerline chars render as slivers** | Windows Terminal uses font glyphs | Enable `builtinGlyphs: true` in Windows Terminal settings |
| **catppuccin plugin doesn't load** | `source -F "#{d:current_file}/..."` broken on MSYS2 tmux | Use hardcoded config via `gen-config.js` instead of plugin |
| **conda "Could not determine home directory"** | Windows Python doesn't understand POSIX HOME path | Set `USERPROFILE`, `HOMEDRIVE`, `HOMEPATH` in tmux.conf |
| **tmux-256color terminfo missing** | MSYS2 doesn't ship tmux-256color | Use `screen-256color` instead |
| **CRLF in plugin files** | Git clones with CRLF on Windows | Clone with `core.autocrlf=false` or sed fix |
| **Tools missing in tmux zsh** (`node`, `git`, `eza`, `nvim`, `claude`) | MSYS2 tmux doesn't fully inherit the Windows user PATH | Explicit PATH export in `.zshrc` + `MSYS2_PATH_TYPE=inherit` in tmux alias (handled by installer) |

---

## LLM Agent Installation Prompt

Paste into Claude Code / ChatGPT for guided auto-install:

```
I want to install the tmux Catppuccin Mocha config from https://github.com/wjgoarxiv/my-tmux-settings.

My environment:
- OS: [Windows with Git Bash / macOS / WSL2 / Linux]
- Shell: [zsh / bash / PowerShell]
- Terminal: [Windows Terminal / iTerm2 / other]
- Node.js: [yes/no — check: node --version]
- Git: [yes/no — check: git --version]
- MSYS2: [yes/no — check: ls /c/msys64/ or ls C:\msys64\] (Windows only)

Steps — pick the section matching your OS:

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  macOS / WSL2 / Linux
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1 — Prerequisites:  git --version && tmux -V
STEP 2 — Clone:          git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
STEP 3 — Install:        bash ~/my-tmux-settings/install.sh
  → Auto-installs: catppuccin/tmux plugin, ~/.tmux.conf, sysinfo.sh
STEP 4 — Font:           brew install --cask font-jetbrains-mono-nerd-font  (macOS)
                          Download from https://www.nerdfonts.com             (Linux)
STEP 5 — Set font in terminal app to "JetBrainsMono Nerd Font"
STEP 6 — Run: tmux

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Windows — MSYS2 native tmux (RECOMMENDED)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PREREQUISITES:
  - Git Bash with zsh + oh-my-zsh + powerlevel10k already set up
  - MSYS2 installed at C:\msys64 (https://www.msys2.org)
  - Node.js installed (node --version)
  - JetBrainsMono Nerd Font installed (choco install -y nerd-fonts-JetBrainsMono)

STEP 1 — Clone (from Git Bash):
  git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings

STEP 2 — Run installer (from Git Bash):
  bash ~/my-tmux-settings/install-windows.sh

  The installer automatically:
  a) Installs tmux + zsh in MSYS2 via pacman
  b) Fixes MSYS2 HOME directory (nsswitch.conf → db_home: windows)
  c) Generates Catppuccin Mocha ~/.tmux.conf via gen-config.js --windows
  d) Installs sysinfo.sh (CPU/MEM widget)
  e) Adds tmux alias to ~/.zshrc
  f) Enables Windows Terminal builtinGlyphs

STEP 3 — Remove psmux if installed (from PowerShell):
  winget uninstall marlocarlo.psmux

STEP 4 — Set Windows Terminal font:
  Settings → Profiles → Defaults → Appearance → Font face → "JetBrainsMono Nerd Font"

STEP 5 — CLOSE and REOPEN Windows Terminal (required for builtinGlyphs)

STEP 6 — Run: tmux

CRITICAL WINDOWS PITFALLS (the installer handles these, but know them):
  1. MUST use MSYS2's zsh (/c/msys64/usr/bin/zsh.exe), NOT Git Bash's zsh.
     Git Bash zsh uses a different msys-2.0.dll runtime → PTY mismatch → shell
     starts but produces no visible output inside tmux.
  2. MUST change MSYS2 nsswitch.conf to "db_home: windows" so HOME=/c/Users/YOU
     instead of /home/YOU. Without this, zsh can't find .zshrc, oh-my-zsh, p10k.
  3. MUST run tmux with -u flag for UTF-8 mode (powerline chars render as slivers without it).
  4. MUST enable builtinGlyphs in Windows Terminal (powerline chars render as tiny blocks without it).
  5. The catppuccin/tmux plugin's "source -F" syntax doesn't work on MSYS2 tmux.
     Use gen-config.js to generate a hardcoded config instead.
  6. MSYS2 doesn't have tmux-256color terminfo — use screen-256color.
  7. Set USERPROFILE/HOMEDRIVE/HOMEPATH in tmux.conf for Windows-native programs (conda, Python).
  8. MSYS2 tmux does NOT fully inherit the Windows user PATH. The installer adds
     MSYS2_PATH_TYPE=inherit to the tmux alias and explicit PATH entries to .zshrc.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Windows — psmux (PowerShell)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP 1 — Prerequisites:  node --version && git --version
STEP 2 — Clone:          git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
STEP 3 — Install:        powershell -File $HOME/my-tmux-settings/install.ps1
  → Generates hardcoded Catppuccin Mocha ~/.tmux.conf, installs sysinfo.sh
STEP 4 — Font:           choco install -y nerd-fonts-JetBrainsMono
STEP 5 — Set Windows Terminal font to "JetBrainsMono Nerd Font"
STEP 6 — Run: psmux

Confirm: is the Catppuccin Mocha status bar visible at the top
with powerline triangle segments, Nerd Font icons, and a CPU/MEM widget?
```

---

## Troubleshooting

**Icons show as boxes** → Font not applied. Restart terminal after font install.

**Config not updating** → `Ctrl+b r` reloads config instantly.

**Windows: shell opens but no output** → You're using Git Bash's zsh inside MSYS2 tmux. Run `install-windows.sh` to install MSYS2's own zsh.

**Windows: powerline chars are tiny slivers** → Enable `builtinGlyphs` in Windows Terminal and run tmux with `-u` flag.

**Windows: conda errors about home directory** → The config sets USERPROFILE/HOMEDRIVE/HOMEPATH. Re-run `node customize/gen-config.js --windows`.

**Claude Code flicker** → The config includes DEC 2026 Synchronized Output overrides. Make sure your tmux is 3.3a+ for full support.

**Windows: `command not found` for node/git/eza/nvim/claude inside tmux** → Re-run `install-windows.sh` to add `MSYS2_PATH_TYPE=inherit` to the tmux alias and Windows tool paths to `.zshrc`.
