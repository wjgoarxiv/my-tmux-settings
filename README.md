# my-tmux-settings

Tokyonight Night tmux configuration with powerline status bar, Nerd Font icons, and a CPU/MEM widget.

Supports macOS, WSL2, Linux, and Windows native tmux via MSYS2. Self-contained, with no plugins required.

---

## Platform Support

| Platform | Config | Shell | Theme |
|---|---|---|---|
| macOS / WSL2 / Linux | `tmux.conf` | Any | Tokyonight Night |
| Windows (MSYS2 native tmux) | `tmux-windows.conf` | MSYS2 zsh | Tokyonight Night |
| Windows (psmux) | `tmux-windows.conf` | PowerShell | Tokyonight Night |

---

## Requirements

### macOS / WSL2 / Linux
- tmux (`brew install tmux` or `apt install tmux`)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com)

### Windows (MSYS2 native tmux) - Recommended
- [MSYS2](https://www.msys2.org)
- MSYS2 `tmux` and `zsh`
- oh-my-zsh + powerlevel10k inside MSYS2
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com)
- [Windows Terminal](https://aka.ms/terminal) with `builtinGlyphs` enabled

---

## Quick Install

### macOS / WSL2 / Linux
```bash
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install.sh
```

### Windows (MSYS2 native tmux) - Recommended
```bash
# Run from Git Bash or MSYS2 shell
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install-windows.sh
```

### Windows (psmux, only if you explicitly want psmux)
```powershell
git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
powershell -File $HOME/my-tmux-settings/install.ps1
```

---

## What's Included

### Config Files
- `tmux.conf`: Tokyonight Night for macOS, Linux, and WSL2
- `tmux-windows.conf`: Tokyonight Night for Windows MSYS2
- `zshrc`: Reference `.zshrc` with lazy-load conda, DuoNA proxy autodetect, P10k, and AI CLI aliases

### Scripts
- `scripts/sysinfo.sh`: Cross-platform CPU/MEM widget

### Installers
- `install.sh`: macOS and Linux installer
- `install-windows.sh`: Windows MSYS2 installer
- `install.ps1`: Windows psmux installer

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

- Tokyonight Night color scheme across status bar, panes, and messages
- Powerline triangle segments with Nerd Font icons
- CPU/MEM widget via `sysinfo.sh`
- DEC 2026 synchronized output support to reduce fast-output flicker
- `focus-events` enabled
- Mouse support with tuned scroll speed
- `allow-passthrough` enabled

### zshrc Highlights
- Lazy-load conda to avoid heavy startup cost
- DuoNA proxy autodetect
- AI CLI aliases: `c`, `cx`, `g`, `oc`
- P10k instant prompt
- MSYS2 tmux pinning for UCRT64 zsh

---

## Windows MSYS2 Native tmux Notes

Running native tmux on Windows via MSYS2 requires a few non-obvious fixes. The installer handles these automatically.

If you are not intentionally using psmux, remove it. Leaving the WinGet `psmux` shim installed can silently shadow MSYS2 tmux and break OMX, Codex, and detached-session behavior.

| Issue | Root Cause | Fix |
|---|---|---|
| psmux shadows tmux | WinGet installs `psmux` as `tmux.exe` under `%LOCALAPPDATA%\\Microsoft\\WinGet\\Links` | Remove the WinGet shim and pin `tmux` to `/c/msys64/usr/bin/tmux.exe -u` |
| Shell produces no output | Git Bash zsh uses a different MSYS2 runtime than MSYS2 tmux | Install `zsh` in MSYS2 via `pacman -S zsh` |
| HOME is `/home/Username` | MSYS2 default `nsswitch.conf` uses `db_home: cygwin` | Change to `db_home: windows` |
| Powerline chars render as blocks | tmux `-u` flag missing | Add `-u` flag to the tmux alias |
| Powerline chars render as slivers | Windows Terminal falls back to font glyph shaping | Enable `builtinGlyphs: true` |
| Conda cannot determine home directory | Windows Python does not understand POSIX HOME | Set `USERPROFILE`, `HOMEDRIVE`, and `HOMEPATH` in tmux config |
| Claude Code flicker in tmux | Missing synchronized output support | Add DEC 2026 sync terminal overrides |
| Detached sessions die unexpectedly | Blind stale-socket cleanup removes live tmux sockets | Probe with `tmux ls` before deleting the socket |

---

## Troubleshooting

**Icons show as boxes**  
The font is not applied. Restart the terminal after installing the font.

**Windows: shell opens but no output**  
You are using Git Bash's zsh inside MSYS2 tmux. Use `install-windows.sh` so tmux launches MSYS2's own zsh.

**Windows: OMX / Codex shows `psmux: no server running on session 'default'`**  
Your shell is still finding WinGet `psmux` instead of MSYS2 tmux. Remove `%LOCALAPPDATA%\\Microsoft\\WinGet\\Links\\tmux.exe` and use the repo's `tmux` alias, which pins `/c/msys64/usr/bin/tmux.exe -u`.

**Windows: powerline chars are tiny slivers**  
Enable `builtinGlyphs` in Windows Terminal and run tmux with `-u`.

**Windows: conda errors about home directory**  
Re-run `install-windows.sh`.

**Claude Code flicker**  
Make sure tmux is 3.3a+ and keep `CLAUDE_CODE_NO_FLICKER=1` in your shell.

**Slow zsh startup**  
Use the lazy-load conda pattern in `zshrc`. Do not double-activate `base`.
