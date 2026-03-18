/**
 * gen-config.js — Generates ~/.tmux.conf with Catppuccin Mocha theme
 * No TPM, no bash required. Works on macOS, Linux, Windows (psmux & MSYS2 native).
 * Requires Node.js.
 *
 * Usage:
 *   node gen-config.js              → writes to ~/.tmux.conf (generic)
 *   node gen-config.js --windows    → writes Windows MSYS2 native tmux config
 *   node gen-config.js --preview    → prints to stdout only
 */

const isWindows = process.argv.includes('--windows');

// ── Powerline separators ────────────────────────────────────────
// Use triangle separators — most universally rendered with builtinGlyphs
const TL = '\uE0B2';  // left-pointing triangle
const TR = '\uE0B0';  // right-pointing triangle

// ── Nerd Font icons ─────────────────────────────────────────────
const ICON_SESS = '\uF489';   // nf-oct-terminal
const ICON_DIR  = '\uF07B';   // fa-folder
const ICON_APP  = '\uF120';   // fa-terminal
const ICON_CPU  = '\uF2DB';   // fa-microchip

// ── Catppuccin Mocha palette ────────────────────────────────────
// https://github.com/catppuccin/catppuccin
const base     = '#1e1e2e';
const mantle   = '#181825';
const crust    = '#11111b';
const surface0 = '#313244';
const surface1 = '#45475a';
const overlay0 = '#6c7086';
const overlay2 = '#9399b2';
const text     = '#cdd6f4';
const subtext0 = '#a6adc8';
const blue     = '#89b4fa';
const green    = '#a6e3a1';
const peach    = '#fab387';
const pink     = '#f5c2e7';
const mauve    = '#cba6f7';
const red      = '#f38ba8';
const maroon   = '#eba0ac';
const yellow   = '#f9e2af';
const lavender = '#b4befe';
const teal     = '#94e2d5';
const rosewater= '#f5e0dc';

// ── Status bar layout (powerline triangles) ─────────────────────
const statusLeft =
  `#[fg=${crust},bg=${green}] ${ICON_SESS} #S #[fg=${green},bg=${mantle}]${TR} `;

const winInactive =
  `#[fg=${overlay2},bg=${mantle}]${TL}#[fg=${crust},bg=${overlay2}] #I ` +
  `#[fg=${overlay2},bg=${surface0}]${TR}#[fg=${text},bg=${surface0}] #W ` +
  `#[fg=${surface0},bg=${mantle}]${TR}`;

const winActive =
  `#[fg=${mauve},bg=${mantle}]${TL}#[fg=${crust},bg=${mauve}] #I ` +
  `#[fg=${mauve},bg=${surface1}]${TR}#[fg=${text},bg=${surface1}] #W ` +
  `#[fg=${surface1},bg=${mantle}]${TR}`;

const statusRight =
  `#[fg=${rosewater},bg=${mantle}]${TL}#[fg=${crust},bg=${rosewater}] ${ICON_DIR} ` +
  `#[fg=${rosewater},bg=${surface0}]${TR}#[fg=${text},bg=${surface0}] #{b:pane_current_path} ` +
  `#[fg=${surface0},bg=${mantle}]${TR}` +
  ` #[fg=${maroon},bg=${mantle}]${TL}#[fg=${crust},bg=${maroon}] ${ICON_APP} ` +
  `#[fg=${maroon},bg=${surface0}]${TR}#[fg=${text},bg=${surface0}] #{pane_current_command} ` +
  `#[fg=${surface0},bg=${mantle}]${TR}` +
  ` #[fg=${blue},bg=${mantle}]${TL}#[fg=${crust},bg=${blue}] ${ICON_CPU} ` +
  `#[fg=${blue},bg=${surface0}]${TR}#[fg=${text},bg=${surface0}] #(~/.tmux/sysinfo.sh) ` +
  `#[fg=${surface0},bg=${mantle}]${TR}`;

// ── Platform-specific settings ──────────────────────────────────
const defaultShell = isWindows
  ? `set -g default-shell "/c/msys64/usr/bin/zsh.exe"`
  : `# set -g default-shell "/usr/bin/zsh"  # uncomment to override`;

const windowsEnv = isWindows
  ? `
# ── Windows environment (for conda/Python compatibility) ─────────
set-environment -g USERPROFILE "C:\\\\Users\\\\${require('os').userInfo().username}"
set-environment -g HOMEDRIVE "C:"
set-environment -g HOMEPATH "\\\\Users\\\\${require('os').userInfo().username}"`
  : '';

// MSYS2 doesn't have tmux-256color terminfo
const termSetting = isWindows
  ? `set -g default-terminal "screen-256color"\nset -ga terminal-overrides ",*256color*:Tc"`
  : `set -g default-terminal "tmux-256color"\nset -ga terminal-overrides ",xterm-256color:Tc"`;

// ── Config template ─────────────────────────────────────────────
const conf = `# ================================================================
# my-tmux-settings — Catppuccin Mocha theme
# ${isWindows ? 'Windows (MSYS2 native tmux + Git Bash zsh)' : 'macOS / Linux / WSL2'}
# Font: JetBrainsMono Nerd Font  https://www.nerdfonts.com
# Repo: https://github.com/wjgoarxiv/my-tmux-settings
# ================================================================

# Prefix key
set -g prefix C-b
bind C-b send-prefix

# ── Shell ────────────────────────────────────────────────────────
${defaultShell}
${windowsEnv}

# Pane borders
set -g pane-border-style "fg=${surface1}"
set -g pane-active-border-style "fg=${mauve}"

# Message bar
set -g message-style "bg=${surface0},fg=${text}"
set -g message-command-style "bg=${surface0},fg=${text}"
set -g mode-style "bg=${mauve},fg=${text}"

# ── Status bar ───────────────────────────────────────────────────
set -g status-interval 5
set -g status-position bottom
set -g status-style "bg=${mantle},fg=${text}"
set -g status-left-length 100
set -g status-right-length 100

set -g status-left "${statusLeft}"
set -g status-right "${statusRight}"

set -g window-status-format "${winInactive}"
set -g window-status-current-format "${winActive}"
set -g window-status-separator " "
set -g window-status-activity-style "fg=${peach},bg=${mantle}"

# ── Colors ────────────────────────────────────────────────────────
${termSetting}

# ── Synchronized Output (DEC 2026) — eliminates Claude Code flicker ──
set -ga terminal-overrides ",*:Sync"

# ── General ───────────────────────────────────────────────────────
set -g mouse on
set -g focus-events on
set -g allow-passthrough on
set-environment -g TERM_PROGRAM "tmux"
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
setw -g automatic-rename off
set -g history-limit 10000
set -s escape-time 0

# Scroll speed
bind-key -T copy-mode-vi WheelUpPane send-keys -X -N 2 scroll-up
bind-key -T copy-mode-vi WheelDownPane send-keys -X -N 2 scroll-down

# ── Key bindings ──────────────────────────────────────────────────
bind r source-file ~/.tmux.conf \\; display "  Config reloaded!"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
`;

// ── Write or preview ────────────────────────────────────────────
const preview = process.argv.includes('--preview');
if (preview) {
  process.stdout.write(conf);
} else {
  const os   = require('os');
  const fs   = require('fs');
  const path = require('path');
  const dest = path.join(os.homedir(), '.tmux.conf');
  fs.writeFileSync(dest, conf, 'utf8');
  console.log(`Written to ${dest}` + (isWindows ? ' (Windows mode)' : ''));
}
