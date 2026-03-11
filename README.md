# my-tmux-settings

Dracula-themed tmux configuration — works on **macOS** (tmux) and **Windows** (psmux + PowerShell).

**Status bar layout (top):**
```
  session    win1    win2          current-folder    user    hostname
```

---

## Requirements

| | macOS | Windows |
|---|---|---|
| tmux | `brew install tmux` | `winget install psmux` |
| Node.js | `brew install node` | `winget install OpenJS.NodeJS` |
| Font | `brew install --cask font-jetbrains-mono-nerd-font` | `choco install -y nerd-fonts-JetBrainsMono` |

Set your terminal font to **JetBrainsMono Nerd Font** after installing.

---

## Quick Install

### macOS / Linux
```bash
git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
bash ~/my-tmux-settings/install.sh
```

### Windows (PowerShell)
```powershell
git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings
node $HOME/my-tmux-settings/customize/gen-config.js
```

Then set **JetBrainsMono Nerd Font** in Windows Terminal:
`Settings → Profiles → Appearance → Font face`

---

## Key Bindings

| Key | Action |
|---|---|
| `Ctrl+b` | Prefix key |
| `Ctrl+b \|` | Split pane left/right |
| `Ctrl+b -` | Split pane top/bottom |
| `Ctrl+b h/j/k/l` | Navigate panes (vim-style) |
| `Ctrl+b r` | Reload config instantly |
| `Ctrl+b z` | Zoom pane (fullscreen toggle) |
| `Ctrl+b d` | Detach session |
| `Ctrl+b [` | Scroll mode (q to exit) |

---

## Customize Colors

Edit `customize/gen-config.js` and change the color variables, then re-run:

```bash
# macOS/Linux
node customize/gen-config.js && tmux source ~/.tmux.conf

# Windows (PowerShell)
node customize\gen-config.js
# then in psmux: Ctrl+b → r
```

Dracula palette:

| Name | Hex | Used for |
|---|---|---|
| Background | `#282a36` | Status bar base |
| Purple | `#bd93f9` | Active window tab |
| Green | `#50fa7b` | Session name |
| Cyan | `#8be9fd` | Hostname |
| Orange | `#ffb86c` | Username |
| Comment | `#6272a4` | Time / date |

---

## 🤖 LLM Agent Installation Prompt

Paste the block below into **Claude**, **ChatGPT**, or any AI assistant to auto-install in one shot:

---

```
I want to install the tmux Dracula configuration from https://github.com/wjgoarxiv/my-tmux-settings on my machine.

My environment:
- OS: [macOS / Windows]
- Shell: [zsh/bash / PowerShell]
- Terminal: [iTerm2 / Windows Terminal / other]
- Node.js: [yes/no — check: node --version]
- Git: [yes/no — check: git --version]

Please execute the following steps one by one, showing me the commands to run and verifying each step:

STEP 1 — Check prerequisites
  Run: node --version && git --version
  If either is missing, tell me how to install it for my OS before continuing.

STEP 2 — Clone the repo
  macOS/Linux:  git clone https://github.com/wjgoarxiv/my-tmux-settings ~/my-tmux-settings
  Windows:      git clone https://github.com/wjgoarxiv/my-tmux-settings $HOME/my-tmux-settings

STEP 3 — Generate ~/.tmux.conf
  macOS/Linux:  bash ~/my-tmux-settings/install.sh
  Windows:      node $HOME/my-tmux-settings/customize/gen-config.js

STEP 4 — Verify the config was created
  macOS/Linux:  head -5 ~/.tmux.conf
  Windows:      Get-Content $HOME/.tmux.conf | Select-Object -First 5

STEP 5 — Install JetBrainsMono Nerd Font
  macOS:    brew install --cask font-jetbrains-mono-nerd-font
  Windows:  choco install -y nerd-fonts-JetBrainsMono
            (no choco? download from https://www.nerdfonts.com/font-downloads)

STEP 6 — Set font in terminal
  Windows Terminal: Settings → Profiles → Appearance → Font face → "JetBrainsMono Nerd Font"
  iTerm2:           Preferences → Profiles → Text → Font → "JetBrainsMono Nerd Font Mono"

STEP 7 — Start or reload tmux
  New session:  tmux
  Reload:       tmux source ~/.tmux.conf   OR inside tmux: Ctrl+b → r

After all steps, confirm: is the Dracula pill-shaped status bar visible at the top?
If icons show as □□, the font is not applied — remind me to restart the terminal after font install.
```

---

## Troubleshooting

**Icons show as □□ or ??**
→ Font not set or terminal not restarted. Set **JetBrainsMono Nerd Font** and restart the terminal.

**Colors look wrong**
```bash
echo $TERM   # should be: screen-256color or xterm-256color
```

**Config not applying after edit**
```
Ctrl+b  →  r     # reloads ~/.tmux.conf instantly
```

**Windows: `Ctrl+b I` does nothing**
→ This config does NOT use TPM. Run `gen-config.js` to install — no plugin manager needed.
