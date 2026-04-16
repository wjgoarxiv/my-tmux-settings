# Enable Powerlevel10k instant prompt
# IMPORTANT: Nothing that produces console output may go above this block.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export NODE_USE_SYSTEM_CA=1
export CODEX_CA_CERTIFICATE="$HOME/Documents/corporate-certs/corporate-ca-bundle.pem"
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

# Native Claude Code install in MSYS2 / UCRT64 zsh.
if [[ -d "/c/Users/Admin/.local/bin" ]]; then
  export PATH="/c/Users/Admin/.local/bin:$PATH"
fi

# Native npm global CLIs in MSYS2 / UCRT64 zsh.
if [[ -d "/c/Users/Admin/AppData/Roaming/npm" ]]; then
  export PATH="/c/Users/Admin/AppData/Roaming/npm:$PATH"
fi

setopt NO_BEEP

# >>> miniconda lazy-load >>>
_conda_exe="/c/Users/Admin/AppData/Local/miniconda3/Scripts/conda.exe"
_conda_hook_cache="${XDG_CACHE_HOME:-$HOME/.cache}/conda-zsh-hook.zsh"

conda-init() {
  unfunction conda python python3 pip conda-init 2>/dev/null
  if [[ -x "$_conda_exe" ]]; then
    if [[ ! -f "$_conda_hook_cache" || "$_conda_exe" -nt "$_conda_hook_cache" ]]; then
      "$_conda_exe" shell.zsh hook 2>/dev/null > "$_conda_hook_cache"
    fi
    eval "$(< "$_conda_hook_cache")"
  fi
  unset _conda_exe _conda_hook_cache
}

if [[ -x "$_conda_exe" ]]; then
  conda()   { conda-init && conda "$@" ;}
  python()  { conda-init && python "$@" ;}
  python3() { conda-init && python3 "$@" ;}
  pip()     { conda-init && pip "$@" ;}
fi
# <<< miniconda lazy-load <<<

fpath=(~/.zsh/completions $fpath)

source "$ZSH/oh-my-zsh.sh"

alias c='claude'
alias cdsp='claude --dangerously-skip-permissions'
alias g='gemini'
alias oc='opencode'
alias cx='codex'
alias cxy='codex --yolo'

# Pin tmux to the MSYS2 binary. Do not route UCRT64 zsh through WinGet psmux.
alias tmux='MSYS2_PATH_TYPE=inherit /c/msys64/usr/bin/tmux.exe -u'

# Clean only a genuinely stale tmux socket.
if [[ -e "/tmp/tmux-$(id -u)/default" ]]; then
  /c/msys64/usr/bin/tmux.exe -u ls >/dev/null 2>&1 || rm -f "/tmp/tmux-$(id -u)/default"
fi

# DuoNA network context (HD KSOE)
if curl -s --connect-timeout 1 -o /dev/null http://127.0.0.1:18080/ 2>/dev/null; then
  export HTTPS_PROXY=http://127.0.0.1:18080
  export HTTP_PROXY=http://127.0.0.1:18080
  export NO_PROXY=localhost,127.0.0.1
  export NODE_OPTIONS="${NODE_OPTIONS:+$NODE_OPTIONS }--require C:/Users/Admin/bin/proxy-bootstrap.js"
else
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
      powershell.exe -NoProfile -ExecutionPolicy Bypass -File \
        "$HOME/bin/start-duona-proxy.ps1" >/dev/null 2>&1
    elif [[ -t 1 ]]; then
      printf '\n\033[1;33m%s\033[0m\n' \
        "WARNING: DuoNA proxy not running -- API calls will fail" \
        "  Fix: Open any VSCode terminal tab once (auto-starts proxy)"
    fi
  ) &!
  export HTTPS_PROXY=http://127.0.0.1:18080
  export HTTP_PROXY=http://127.0.0.1:18080
fi

[[ -f ~/.pretty-terminal-eza.zsh ]] && source ~/.pretty-terminal-eza.zsh

if [[ ${_use_powerlevel10k:-0} -eq 1 && -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
elif [[ ${_use_powerlevel10k:-0} -eq 0 ]]; then
  PROMPT='%n@%m %~ %# '
fi
