/**
 * gen-config.js — Generates ~/.tmux.conf with Catppuccin Mocha theme
 * No TPM, no bash required. Works on macOS, Linux, Windows (psmux).
 * Requires Node.js.
 *
 * Usage:
 *   node gen-config.js              → writes to ~/.tmux.conf
 *   node gen-config.js --preview    → prints to stdout only
 */

const L = '\uE0B6';  // ( rounded left cap  [Nerd Font U+E0B6]
const R = '\uE0B4';  // ) rounded right cap [Nerd Font U+E0B4]

// ── Catppuccin Mocha palette ───────────────────────────────────────
// https://github.com/catppuccin/catppuccin#-palette
const base    = '#1e1e2e';
const mantle  = '#181825';
const surface0= '#313244';
const surface1= '#45475a';
const text    = '#cdd6f4';
const subtext1= '#bac2de';
const mauve   = '#cba6f7';
const green   = '#a6e3a1';
const blue    = '#89b4fa';
const sapphire= '#74c7ec';
const teal    = '#94e2d5';
const peach   = '#fab387';
const pink    = '#f5c2e7';
const sky     = '#89dceb';

// ── Helper: build a rounded pill segment ──────────────────────────
const pill = (pillBg, textFg, content) =>
  `#[fg=${pillBg},bg=${base}]${L}#[fg=${textFg},bg=${pillBg}]${content}#[fg=${pillBg},bg=${base}]${R}`;

// ── Status bar layout (matches catppuccin official screenshot) ────
const statusLeft  = ' ';  // window tabs handle this
const winInactive = pill(surface0, subtext1, ' #I  #W ');
const winActive   = pill(mauve,    base,     ' #I  #W ');
const statusRight =
  pill(teal,   base, '  #{b:pane_current_path} ') +
  '  ' +
  pill(sky,    base, '  #{pane_current_command} ') +
  '  ' +
  pill(green,  base, '  #S ') +
  '  ' +
  pill(peach,  base, '  %H:%M  %d-%b-%y ');

// ── Config template ───────────────────────────────────────────────
const conf = `# ================================================================
# my-tmux-settings — Catppuccin Mocha theme
# Compatible: macOS (tmux) + Windows (psmux/PowerShell)
# Font: JetBrainsMono Nerd Font  https://www.nerdfonts.com
# Repo: https://github.com/wjgoarxiv/my-tmux-settings
# ================================================================

# Prefix key
set -g prefix C-b
bind C-b send-prefix

# Pane borders
set -g pane-border-style "fg=${surface1}"
set -g pane-active-border-style "fg=${mauve}"

# Message bar
set -g message-style "bg=${surface0},fg=${text}"
set -g message-command-style "bg=${surface0},fg=${text}"

# ── Status bar (TOP) ──────────────────────────────────────────────
set -g status on
set -g status-interval 5
set -g status-position bottom
set -g status-style "bg=${base},fg=${text}"
set -g status-left-length 40
set -g status-right-length 160

set -g status-left "${statusLeft}"
set -g status-right "${statusRight}"

set -g window-status-format "${winInactive}"
set -g window-status-current-format "${winActive}"
set -g window-status-separator " "

# ── Colors ────────────────────────────────────────────────────────
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# ── General ───────────────────────────────────────────────────────
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g history-limit 10000
set -s escape-time 0

# ── Key bindings ──────────────────────────────────────────────────
bind r source-file ~/.tmux.conf \\; display "  Config reloaded!"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
`;

// ── Write or preview ──────────────────────────────────────────────
const preview = process.argv.includes('--preview');
if (preview) {
  process.stdout.write(conf);
} else {
  const os   = require('os');
  const fs   = require('fs');
  const path = require('path');
  const dest = path.join(os.homedir(), '.tmux.conf');
  fs.writeFileSync(dest, conf, 'utf8');
  console.log(`Written to ${dest}`);
}
