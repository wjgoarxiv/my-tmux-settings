/**
 * gen-config.js — Generates ~/.tmux.conf with Dracula theme
 * Requires Node.js. Works on macOS, Linux, and Windows (psmux).
 *
 * Usage:
 *   node gen-config.js              → writes to ~/.tmux.conf
 *   node gen-config.js --preview    → prints to stdout only
 */

const L = '\uE0B6';  // ( rounded left cap  [Nerd Font U+E0B6]
const R = '\uE0B4';  // ) rounded right cap [Nerd Font U+E0B4]

// ── Dracula color palette ──────────────────────────────────────────
const bg      = '#282a36';
const gray    = '#44475a';
const purple  = '#bd93f9';
const green   = '#50fa7b';
const cyan    = '#8be9fd';
const orange  = '#ffb86c';
const fg      = '#f8f8f2';
const comment = '#6272a4';

// ── Helper: build a rounded pill segment ──────────────────────────
const pill = (pillBg, textFg, content) =>
  `#[fg=${pillBg},bg=${bg}]${L}#[fg=${textFg},bg=${pillBg}]${content}#[fg=${pillBg},bg=${bg}]${R}`;

// ── Status bar layout ─────────────────────────────────────────────
const statusLeft  = pill(green,   bg,  '  #S ') + ' ';
const winInactive = pill(gray,    fg,  ' #W ');
const winActive   = pill(purple,  bg,  ' #W ');
const statusRight =
  pill(comment, fg, '  #{b:pane_current_path} ') +
  '  ' +
  pill(orange,  bg, '  #(whoami) ') +
  '  ' +
  pill(cyan,    bg, '  #H ');

// ── Config template ───────────────────────────────────────────────
const conf = `# ================================================================
# my-tmux-settings — Dracula theme
# Compatible: macOS (tmux) + Windows (psmux/PowerShell)
# Font required: JetBrainsMono Nerd Font  https://www.nerdfonts.com
# Repo: https://github.com/wjgoarxiv/my-tmux-settings
# ================================================================

# Prefix key (C-b is tmux default — same on Mac and Windows)
set -g prefix C-b
bind C-b send-prefix

# Pane borders
set -g pane-border-style "fg=${gray}"
set -g pane-active-border-style "fg=${purple}"

# Message bar
set -g message-style "bg=${gray},fg=${fg}"
set -g message-command-style "bg=${gray},fg=${fg}"

# ── Status bar (TOP) ──────────────────────────────────────────────
set -g status on
set -g status-interval 5
set -g status-position top
set -g status-style "bg=${bg},fg=${fg}"
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
# Reload config
bind r source-file ~/.tmux.conf \\; display "  Config reloaded!"

# Intuitive split keys
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

# Vim-style pane navigation
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
  console.log(`✓ Written to ${dest}`);
  console.log('  Reload: tmux source ~/.tmux.conf   (or restart tmux)');
}
