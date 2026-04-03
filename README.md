# my-tmux-settings

Tokyonight Night tmux configuration with powerline status bar, Nerd Font icons, and CPU/MEM widget.

Supports **macOS / WSL2 / Linux** and **Windows native tmux** (MSYS2). Self-contained — no plugins required.

---

## Platform Support

| Platform | Config | Shell | Theme |
|---|---|---|---|
| **macOS / WSL2 / Linux** | `tmux.conf` | Any | Tokyonight Night |
| **Windows (MSYS2 native tmux)** | `tmux-windows.conf` | MSYS2 zsh | Tokyonight Night |
| **Windows (psmux)** | `tmux-windows.conf` | PowerShell | Tokyonight Night |

---

## Requirements

### macOS / WSL2 / Linux
- tmux (`brew install tmux` / `apt install tmux`)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com): `brew install --cask font-jetbrains-mono-nerd-font`

### Windows (MSYS2 native tmux) — Recommended
- [MSYS2](https://www.msys2.org) (for native tmux + zsh)
- zsh + oh-my-zsh + powerlevel10k (in MSYS2)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com): `choco install -y nerd-fonts-JetBrainsMono`
- [Windows Terminal](https://aka.ms/terminal) with `builtinGlyphs` enabled

---

## Quick Install

### macOS / WSL2 / Linux
```bash
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install.sh
```

### Windows (MSYS2 native tmux) — Recommended
```bash
# Run from Git Bash or MSYS2 shell
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install-windows.sh
```

### Windows (psmux)
```powershell
git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
powershell -File $HOME/my-tmux-settings/install.ps1
```

---

## What's Included

### Config Files
- **`tmux.conf`** — Tokyonight Night for Mac/Linux/WSL2
- **`tmux-windows.conf`** — Tokyonight Night for Windows MSYS2 (includes Windows env vars, `escape-time 10`)
- **`zshrc`** — Reference `.zshrc` with lazy-load conda, DuoNA proxy auto-detect, P10k, and AI CLI aliases

### Scripts
- **`scripts/sysinfo.sh`** — Cross-platform CPU/MEM widget (uses `typeperf` on Windows instead of PowerShell for speed)

### Installers
- **`install.sh`** — Mac/Linux (copies config + sysinfo)
- **`install-windows.sh`** — Windows MSYS2 (installs tmux/zsh via pacman, fixes HOME, copies config, enables builtinGlyphs)
- **`install.ps1`** — Windows psmux (copies config + sysinfo)

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

- **Tokyonight Night** color scheme across status bar, panes, and messages
- **Powerline triangle** segments with Nerd Font icons
- **CPU/MEM** widget via `sysinfo.sh` (cross-platform: macOS, Linux, Windows)
- **DEC 2026 Synchronized Output** — eliminates flicker in Claude Code and other fast-output tools
- **focus-events** enabled for better editor integration
- **Mouse** support with tuned scroll speed
- **allow-passthrough** for image/sixel protocols

### zshrc Highlights
- **Lazy-load conda** — defers ~9s of conda init until first use
- **DuoNA proxy auto-detection** — bridges corporate network for external API access
- **AI CLI aliases** — `c`=claude, `cx`=codex, `g`=gemini, `oc`=opencode
- **P10k instant prompt** — visible prompt before zsh finishes loading

---

## Tokyonight Night Palette

| Color | Hex | Usage |
|---|---|---|
| Background | `#1a1b26` | Status bar bg |
| Foreground | `#c0caf5` | Text |
| Blue | `#7aa2f7` | Active pane/window, sysinfo segment |
| Green | `#9ece6a` | Session name |
| Orange | `#ff9e64` | App segment, activity |
| Purple | `#bb9af7` | Copy mode |
| Yellow | `#e0af68` | Command mode |
| Dark blue | `#3b4261` | Pane borders, segment bg |
| Muted | `#565f89` | Directory segment |

---

## Windows MSYS2 Native tmux — Technical Notes

Running native tmux on Windows via MSYS2 requires several non-obvious fixes. These are all handled by `install-windows.sh`, but documented here for reference:

| Issue | Root Cause | Fix |
|---|---|---|
| **psmux shadows tmux** | WinGet installs psmux as `tmux` in PATH | Uninstall psmux or alias tmux to MSYS2 binary |
| **Shell produces no output** | Git Bash zsh uses different MSYS2 runtime (msys-2.0.dll) than MSYS2 tmux | Install zsh in MSYS2 via `pacman -S zsh` |
| **HOME is /home/Username** | MSYS2 default `nsswitch.conf` uses `db_home: cygwin` | Change to `db_home: windows` |
| **Powerline chars render as blocks** | tmux `-u` flag missing | Add `-u` flag to tmux alias |
| **Powerline chars render as slivers** | Windows Terminal uses font glyphs | Enable `builtinGlyphs: true` in WT settings |
| **conda "Could not determine home directory"** | Windows Python doesn't understand POSIX HOME | Set `USERPROFILE`, `HOMEDRIVE`, `HOMEPATH` in tmux.conf |
| **Claude Code flicker in tmux** | Missing synchronized output support | Add DEC 2026 Sync terminal overrides |
| **Slow zsh startup (~14s)** | conda.exe spawned 3x at startup (double activation) | Lazy-load conda, cache hook output |

---

## Troubleshooting

**Icons show as boxes** — Font not applied. Restart terminal after font install.

**Config not updating** — `Ctrl+b r` reloads config instantly.

**Windows: shell opens but no output** — You're using Git Bash's zsh inside MSYS2 tmux. Run `install-windows.sh` to install MSYS2's own zsh.

**Windows: powerline chars are tiny slivers** — Enable `builtinGlyphs` in Windows Terminal and run tmux with `-u` flag.

**Windows: conda errors about home directory** — The Windows config sets `USERPROFILE`/`HOMEDRIVE`/`HOMEPATH`. Re-run `install-windows.sh`.

**Claude Code flicker** — The config includes DEC 2026 Synchronized Output overrides. Make sure your tmux is 3.3a+ for full support. Also set `CLAUDE_CODE_NO_FLICKER=1` in your shell.

**Slow zsh startup** — See `zshrc` for lazy-load conda pattern. The key fix: `conda.exe shell.zsh hook` already activates base — don't call `conda activate base` again.
