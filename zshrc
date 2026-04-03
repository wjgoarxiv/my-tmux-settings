# Enable Powerlevel10k instant prompt
# IMPORTANT: Nothing that produces console output may go above this block.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# TLS: Use Windows cert store (Node v24+) instead of disabling validation
export NODE_USE_SYSTEM_CA=1
# Codex CLI (Rust binary): corporate CA bundle for future-proofing
export CODEX_CA_CERTIFICATE="$HOME/Documents/corporate-certs/corporate-ca-bundle.pem"
# Claude Code: suppress terminal flicker
export CLAUDE_CODE_NO_FLICKER=1

export ZSH="$HOME/.oh-my-zsh"

plugins=(git)

if (setopt monitor) >/dev/null 2>&1; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
  _use_powerlevel10k=1
else
  ZSH_THEME=""
  _use_powerlevel10k=0
fi

# Make winget-installed CLIs available in Git Bash / zsh.
if [[ -d "/c/Users/Admin/AppData/Local/Microsoft/WinGet/Links" ]]; then
  export PATH="/c/Users/Admin/AppData/Local/Microsoft/WinGet/Links:$PATH"
fi

# Make native Claude Code install available in MSYS2 / UCRT64 zsh.
if [[ -d "/c/Users/Admin/.local/bin" ]]; then
  export PATH="/c/Users/Admin/.local/bin:$PATH"
fi

# Prevent BEL from triggering flash/beep in terminal.
setopt NO_BEEP

# >>> miniconda lazy-load >>>
# Defers conda init until first use (~9s → 0s at startup).
# Run `conda-init` to force immediate initialization.
_conda_exe="/c/Users/Admin/AppData/Local/miniconda3/Scripts/conda.exe"
_conda_hook_cache="${XDG_CACHE_HOME:-$HOME/.cache}/conda-zsh-hook.zsh"

conda-init() {
  unfunction conda python python3 pip conda-init 2>/dev/null
  if [[ -x "$_conda_exe" ]]; then
    # Cache hook output; regenerate only when conda.exe changes
    if [[ ! -f "$_conda_hook_cache" || "$_conda_exe" -nt "$_conda_hook_cache" ]]; then
      "$_conda_exe" shell.zsh hook 2>/dev/null > "$_conda_hook_cache"
    fi
    eval "$(< "$_conda_hook_cache")"
    # Hook already calls `conda activate 'base'` — no double activation
  fi
  unset _conda_exe _conda_hook_cache
}

if [[ -x "$_conda_exe" ]]; then
  conda()   { conda-init && conda "$@" }
  python()  { conda-init && python "$@" }
  python3() { conda-init && python3 "$@" }
  pip()     { conda-init && pip "$@" }
fi
# <<< miniconda lazy-load <<<

# Safe custom completions (overrides built-in _npm that spawns console windows)
fpath=(~/.zsh/completions $fpath)

source $ZSH/oh-my-zsh.sh

# >>> alias-portable-config aliases >>>
alias c='claude'
alias cdsp='claude --dangerously-skip-permissions'
alias g='gemini'
alias oc='opencode'
alias cx='codex'
alias cxy='codex --yolo'
# <<< alias-portable-config aliases <<<

# ── tmux with UTF-8 mode ──────────────────────────────────────
alias tmux='/usr/bin/tmux -u'

# Clean stale tmux socket to avoid 2-5s Winsock SYN retry delay on startup
pgrep -q tmux 2>/dev/null || rm -f "/tmp/tmux-$(id -u)/default"

# ── DuoNA network context (HD KSOE) ──────────────────────────
# External APIs (Claude, Codex) need the DuoNA virtual adapter.
# A local proxy on :18080 bridges non-DuoNA shells to DuoNA.
# Auto-starts when a DuoNA-hooked shell opens (e.g. VSCode terminal).
if curl -s --connect-timeout 1 -o /dev/null http://127.0.0.1:18080/ 2>/dev/null; then
  export HTTPS_PROXY=http://127.0.0.1:18080
  export HTTP_PROXY=http://127.0.0.1:18080
  export NO_PROXY=localhost,127.0.0.1
  # Make Node.js https.request() respect HTTPS_PROXY (needed for OMC HUD usage-api)
  export NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--require C:/Users/Admin/bin/proxy-bootstrap.js"
else
  # Proxy not running — try to auto-start if we're under DuoNA
  (
    _in_duona=$(powershell.exe -NoProfile -Command '
      $id=$PID
      for($i=0;$i -lt 20;$i++){
        $p=Get-CimInstance Win32_Process -Filter "ProcessId=$id" -EA 0
        if(!$p){break}
        if($p.Name -eq "DuoNA.exe"){Write-Host 1;exit}
        $id=$p.ParentProcessId
      }
      Write-Host 0
    ' 2>/dev/null | tr -d '\r\n')
    if [[ "$_in_duona" == "1" ]]; then
      # Under DuoNA: auto-start proxy (native CreateProcess preserves hooks)
      powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
        "$HOME/bin/start-duona-proxy.ps1" >/dev/null 2>&1
    elif [[ -t 1 ]]; then
      printf '\n\033[1;33m%s\033[0m\n' \
        "WARNING: DuoNA proxy not running -- API calls will fail" \
        "  Fix: Open any VSCode terminal tab once (auto-starts proxy)"
    fi
  ) &!
  # Optimistic: set proxy now, proxy will be up by the time API is called
  export HTTPS_PROXY=http://127.0.0.1:18080
  export HTTP_PROXY=http://127.0.0.1:18080
fi

# pretty-terminal: eza aliases
[[ -f ~/.pretty-terminal-eza.zsh ]] && source ~/.pretty-terminal-eza.zsh

# pretty-terminal: powerlevel10k config
if [[ ${_use_powerlevel10k:-0} -eq 1 && -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
elif [[ ${_use_powerlevel10k:-0} -eq 0 ]]; then
  PROMPT='%n@%m %~ %# '
fi
