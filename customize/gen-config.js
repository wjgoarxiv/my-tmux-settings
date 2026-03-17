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

// ── Catppuccin Mocha palette ──────────────────────────────────────
// https://github.com/catppuccin/catppuccin
const base     = '#1e1e2e';
const mantle   = '#181825';
const surface0 = '#313244';
const surface1 = '#45475a';
const overlay0 = '#6c7086';
const text     = '#cdd6f4';
const subtext0 = '#a6adc8';
const blue     = '#89b4fa';
const green    = '#a6e3a1';
const peach    = '#fab387';
const pink     = '#f5c2e7';
const mauve    = '#cba6f7';
const red      = '#f38ba8';
const yellow   = '#f9e2af';
const lavender = '#b4befe';
const teal     = '#94e2d5';

// ── Helper: build a rounded pill segment ──────────────────────────
const pill = (pillBg, textFg, content) =>
  `#[fg=${pillBg},bg=${base}]${L}#[fg=${textFg},bg=${pillBg}]${content}#[fg=${pillBg},bg=${base}]${R}`;

// ── Status bar layout ────────────────────────────────────────────
const statusLeft  = pill(green, base, ' #S ') + ' ';
const winInactive = `#[fg=${overlay0}] #I #W `;
const winActive   = `${L}#[bg=${mauve},fg=${text},bold] #I #W #[fg=${mauve},bg=${base}]${R}`.replace(L, `#[fg=${mauve},bg=${base}]${L}`);
const winSep      = `#[fg=${surface1}]|`;
const statusRight =
  pill(surface1, blue, ' %H:%M ') +
  ' ' +
  pill(overlay0, peach, ' %a ') +
  ' ' +
  pill(mauve, text, ' %d-%b ') +
  ' ' +
  `#[fg=${blue},bg=${base}] #(~/.tmux/sysinfo.sh) `;

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
set -g mode-style "bg=${mauve},fg=${text}"

# ── Status bar ───────────────────────────────────────────────────
set -g status on
set -g status-interval 5
set -g status-position bottom
set -g status-justify left
set -g status-style "bg=${base},fg=${text}"
set -g status-left-length 50
set -g status-right-length 80

set -g status-left "${statusLeft}"
set -g status-right "${statusRight}"

set -g window-status-format "${winInactive}"
set -g window-status-current-format "${winActive}"
set -g window-status-separator "${winSep}"
set -g window-status-activity-style "fg=${peach},bg=${base}"

# ── Colors ────────────────────────────────────────────────────────
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# ── Synchronized Output (DEC 2026) — eliminates Claude Code flicker ──
set -ga terminal-overrides ",*:Sync"
set -ga terminal-features ",xterm-256color:Sync"
set -ga terminal-features ",tmux-256color:Sync"

# ── General ───────────────────────────────────────────────────────
set -g mouse on
set -g focus-events on
set -g allow-passthrough on
# Do NOT pass TERM from outer shell — let tmux set it correctly
set-environment -g TERM_PROGRAM "tmux"
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
setw -g automatic-rename off
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
