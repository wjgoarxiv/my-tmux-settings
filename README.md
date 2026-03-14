# my-tmux-settings

Dracula-themed tmux configuration.
Supports **Windows (psmux)** and **macOS / WSL2 / Linux** with platform-specific installers.

---

## Platform Support

| Platform | Method | Theme |
|---|---|---|
| **Windows (psmux)** | PPM plugin (recommended) or Node.js fallback | psmux-theme-dracula |
| **macOS / WSL2 / Linux** | Hardcoded Dracula config | No plugin dependency |

---

## Requirements

### Windows (psmux)
- [psmux](https://github.com/marlocarlo/psmux)
- [Node.js](https://nodejs.org) (for fallback installer)
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com): `choco install -y nerd-fonts-JetBrainsMono`
- Set font in Windows Terminal: `Settings → Profiles → Appearance → Font face`

### macOS / WSL2 / Linux
- tmux (`brew install tmux` / `apt install tmux`)
- git
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com): `brew install --cask font-jetbrains-mono-nerd-font`

---

## Quick Install

### Windows — PPM Plugin (Recommended)
```powershell
# Install PPM (psmux plugin manager)
git clone https://github.com/marlocarlo/psmux-plugins.git "$env:TEMP\psmux-plugins"
Copy-Item "$env:TEMP\psmux-plugins\ppm" "$env:USERPROFILE\.psmux\plugins\ppm" -Recurse
Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force

# Install Dracula theme via Prefix + I after adding to ~/.psmux.conf:
#   set -g @plugin 'psmux-plugins/psmux-theme-dracula'
```

Or use **tmuxpanel** (`winget install marlocarlo.tmuxpanel`) to browse and install themes with a TUI.

### Windows — Node.js Fallback
```powershell
git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
node $HOME/my-tmux-settings/customize/gen-config.js
```

### macOS / WSL2 / Linux
```bash
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install.sh
```

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

## Customize Colors (Windows)

Edit `customize/gen-config.js` — change hex values at the top, then:
```powershell
node customize/gen-config.js
# in psmux: Ctrl+b → r
```

---

## LLM Agent Installation Prompt

Paste into Claude / ChatGPT for one-shot auto-install:

```
I want to install the tmux Dracula config from https://github.com/wjgoarxiv/my-tmux-settings.

My environment:
- OS: [Windows / macOS / WSL2 / Linux]
- Shell: [PowerShell / bash / zsh]
- Terminal: [Windows Terminal / iTerm2 / other]
- Node.js: [yes/no — check: node --version]
- Git: [yes/no — check: git --version]

Steps:

STEP 1 — Verify prerequisites
  Windows: node --version && git --version
  macOS/Linux: git --version && tmux -V

STEP 2 — Clone the repo
  Windows:      git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
  macOS/Linux:  git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings

STEP 3 — Install
  Windows (PPM): Install PPM plugin manager, then add psmux-theme-dracula plugin
  Windows (fallback): node $HOME/my-tmux-settings/customize/gen-config.js
  macOS/Linux:  bash ~/my-tmux-settings/install.sh

STEP 4 — Install JetBrainsMono Nerd Font
  Windows:  choco install -y nerd-fonts-JetBrainsMono
  macOS:    brew install --cask font-jetbrains-mono-nerd-font

STEP 5 — Set font in terminal
  Windows Terminal: Settings → Profiles → Appearance → Font face → "JetBrainsMono Nerd Font"
  iTerm2: Preferences → Profiles → Text → Font → "JetBrainsMono Nerd Font Mono"

STEP 6 — Start tmux
  Windows: psmux
  macOS/Linux: tmux

Confirm: is the Dracula status bar visible at the bottom?
```

---

## Troubleshooting

**Icons show boxes** → Font not applied. Restart terminal after font install.

**Config not updating** → `Ctrl+b r` reloads config instantly.

**Windows: plugin not loading** → This repo uses hardcoded colors on Windows (no bash needed). Run `node customize/gen-config.js` to regenerate.
