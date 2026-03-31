/**
 * gen-config.js — Generates ~/.tmux.conf with Tokyonight Night theme
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

// ── Tokyonight Night palette ────────────────────────────────────
// https://github.com/folke/tokyonight.nvim
const bg      = '#1a1b26';
const dark    = '#16161e';
const fg      = '#c0caf5';
const comment = '#565f89';
const gutter  = '#3b4261';
const surface = '#3b4261';
const overlay = '#9aa5ce';
const subtext = '#a9b1d6';
const blue    = '#7aa2f7';
const cyan    = '#7dcfff';
const green   = '#9ece6a';
const orange  = '#ff9e64';
const violet  = '#bb9af7';
const red     = '#f7768e';
const yellow  = '#e0af68';

// ── Status bar layout (powerline triangles) ─────────────────────
const statusLeft =
  `#[fg=${dark},bg=${green}] ${ICON_SESS} #S #[fg=${green},bg=${bg}]${TR} `;

const winInactive =
  `#[fg=${overlay},bg=${bg}]${TL}#[fg=${dark},bg=${overlay}] #I ` +
  `#[fg=${overlay},bg=${gutter}]${TR}#[fg=${fg},bg=${gutter}] #W ` +
  `#[fg=${gutter},bg=${bg}]${TR}`;

const winActive =
  `#[fg=${blue},bg=${bg}]${TL}#[fg=${dark},bg=${blue}] #I ` +
  `#[fg=${blue},bg=${surface}]${TR}#[fg=${fg},bg=${surface}] #W ` +
  `#[fg=${surface},bg=${bg}]${TR}`;

const statusRight =
  `#[fg=${comment},bg=${bg}]${TL}#[fg=${fg},bg=${comment}] ${ICON_DIR} ` +
  `#[fg=${comment},bg=${gutter}]${TR}#[fg=${fg},bg=${gutter}] #{b:pane_current_path} ` +
  `#[fg=${gutter},bg=${bg}]${TR}` +
  ` #[fg=${orange},bg=${bg}]${TL}#[fg=${dark},bg=${orange}] ${ICON_APP} ` +
  `#[fg=${orange},bg=${gutter}]${TR}#[fg=${fg},bg=${gutter}] #{pane_current_command} ` +
  `#[fg=${gutter},bg=${bg}]${TR}` +
  ` #[fg=${blue},bg=${bg}]${TL}#[fg=${dark},bg=${blue}] ${ICON_CPU} ` +
  `#[fg=${blue},bg=${gutter}]${TR}#[fg=${fg},bg=${gutter}] #(~/.tmux/sysinfo.sh) ` +
  `#[fg=${gutter},bg=${bg}]${TR}`;

// ── Platform-specific settings ──────────────────────────────────
const defaultShell = isWindows
  ? `set -g default-shell "/c/msys64/usr/bin/zsh.exe"`
  : `# set -g default-shell "/usr/bin/zsh"  # uncomment to override`;

const windowsEnv = isWindows
  ? `
# ── Windows environment ──────────────────────────────────────────
set-environment -g MSYS2_PATH_TYPE "inherit"
set-environment -g USERPROFILE "C:\\\\Users\\\\${require('os').userInfo().username}"
set-environment -g HOMEDRIVE "C:"
set-environment -g HOMEPATH "\\\\Users\\\\${require('os').userInfo().username}"`
  : '';

// MSYS2 doesn't have tmux-256color terminfo
const termSetting = isWindows
  ? `set -g default-terminal "screen-256color"\nset -ga terminal-overrides ",*256color*:Tc"`
  : `set -g default-terminal "tmux-256color"\nset -ga terminal-overrides ",xterm-256color:Tc"`;

// Synchronized output — terminal-features is the modern tmux (3.3a+) mechanism
const termFeatures = isWindows
  ? `set -ga terminal-features ",xterm-256color:Sync"\nset -ga terminal-features ",screen-256color:Sync"`
  : `set -ga terminal-features ",xterm-256color:Sync"\nset -ga terminal-features ",tmux-256color:Sync"`;

// ── Config template ─────────────────────────────────────────────
const conf = `# ================================================================
# my-tmux-settings — Tokyonight Night theme
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
set -g pane-border-style "fg=${gutter}"
set -g pane-active-border-style "fg=${blue}"

# Message bar
set -g message-style "bg=${blue},fg=${dark},bold"
set -g message-command-style "bg=${yellow},fg=${dark},bold"
set -g mode-style "bg=${violet},fg=${fg}"

# ── Status bar ───────────────────────────────────────────────────
set -g status-interval 5
set -g status-position top
set -g status-style "bg=${bg},fg=${fg}"
set -g status-left-length 100
set -g status-right-length 100

set -g status-left "${statusLeft}"
set -g status-right "${statusRight}"

set -g window-status-format "${winInactive}"
set -g window-status-current-format "${winActive}"
set -g window-status-separator " "
set -g window-status-activity-style "fg=${orange},bg=${bg}"

# ── Colors ────────────────────────────────────────────────────────
${termSetting}

# ── Synchronized Output (DEC 2026) — eliminates Claude Code flicker ──
set -ga terminal-overrides ",*:Sync"
${termFeatures}

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
${isWindows
  ? `bind | run-shell '/c/msys64/usr/bin/tmux.exe split-window -h -e "TMUX_CWD=#{@cwd}"'
bind - run-shell '/c/msys64/usr/bin/tmux.exe split-window -v -e "TMUX_CWD=#{@cwd}"'
bind '"' run-shell '/c/msys64/usr/bin/tmux.exe split-window -v -e "TMUX_CWD=#{@cwd}"'
bind % run-shell '/c/msys64/usr/bin/tmux.exe split-window -h -e "TMUX_CWD=#{@cwd}"'`
  : `bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"`}
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
