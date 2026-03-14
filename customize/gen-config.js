/**
 * gen-config.js — Generates ~/.tmux.conf with Dracula theme
 * No TPM, no bash required. Works on macOS, Linux, Windows (psmux).
 * Requires Node.js.
 *
 * Usage:
 *   node gen-config.js              → writes to ~/.tmux.conf
 *   node gen-config.js --preview    → prints to stdout only
 */

const L = '\uE0B6';  // ( rounded left cap  [Nerd Font U+E0B6]
const R = '\uE0B4';  // ) rounded right cap [Nerd Font U+E0B4]

// ── Dracula palette ──────────────────────────────────────────────
// https://draculatheme.com/contribute#color-palette
const bg      = '#282a36';
const curLine = '#44475a';
const fg      = '#f8f8f2';
const comment = '#6272a4';
const cyan    = '#8be9fd';
const green   = '#50fa7b';
const orange  = '#ffb86c';
const pink    = '#ff79c6';
const purple  = '#bd93f9';
const red     = '#ff5555';
const yellow  = '#f1fa8c';

// ── Helper: build a rounded pill segment ──────────────────────────
const pill = (pillBg, textFg, content) =>
  `#[fg=${pillBg},bg=${bg}]${L}#[fg=${textFg},bg=${pillBg}]${content}#[fg=${pillBg},bg=${bg}]${R}`;

// ── Status bar layout ────────────────────────────────────────────
const statusLeft  = pill(green, bg, ' #S ') + ' ';
const winInactive = `#[fg=${comment}] #I #W `;
const winActive   = `${L}#[bg=${purple},fg=${fg},bold] #I #W #[fg=${purple},bg=${bg}]${R}`.replace(L, `#[fg=${purple},bg=${bg}]${L}`);
const winSep      = `#[fg=${curLine}]|`;
const statusRight =
  pill(curLine, cyan, ' %H:%M ') +
  ' ' +
  pill(comment, orange, ' %a ') +
  ' ' +
  pill(purple,  fg,   ' %d-%b ');

// ── Config template ───────────────────────────────────────────────
const conf = `# ================================================================
# my-tmux-settings — Dracula theme
# Compatible: macOS (tmux) + Windows (psmux/PowerShell)
# Font: JetBrainsMono Nerd Font  https://www.nerdfonts.com
# Repo: https://github.com/wjgoarxiv/my-tmux-settings
# ================================================================

# Prefix key
set -g prefix C-b
bind C-b send-prefix

# Pane borders
set -g pane-border-style "fg=${curLine}"
set -g pane-active-border-style "fg=${purple}"

# Message bar
set -g message-style "bg=${curLine},fg=${fg}"
set -g message-command-style "bg=${curLine},fg=${fg}"
set -g mode-style "bg=${purple},fg=${fg}"

# ── Status bar ───────────────────────────────────────────────────
set -g status on
set -g status-interval 5
set -g status-position bottom
set -g status-justify left
set -g status-style "bg=${bg},fg=${fg}"
set -g status-left-length 50
set -g status-right-length 80

set -g status-left "${statusLeft}"
set -g status-right "${statusRight}"

set -g window-status-format "${winInactive}"
set -g window-status-current-format "${winActive}"
set -g window-status-separator "${winSep}"
set -g window-status-activity-style "fg=${orange},bg=${bg}"

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
