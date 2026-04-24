#!/bin/bash
# sysinfo.sh — CPU/MEM status bar widget (cross-platform)
# Uses file cache so tmux status updates complete in microseconds
# instead of blocking 1.3s+ on typeperf.exe every refresh.

CACHE="/tmp/tmux-sysinfo.cache"
CACHE_TTL=25  # seconds

# Serve cached result if fresh — avoids spawning typeperf on every status tick
if [ -f "$CACHE" ]; then
    now=$(date +%s)
    mtime=$(stat -c %Y "$CACHE" 2>/dev/null || echo 0)
    if [ $(( now - mtime )) -lt "$CACHE_TTL" ]; then
        cat "$CACHE"
        exit 0
    fi
fi

case "$(uname -s)" in
  Darwin)
    ncpu=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)
    cpu=$(ps -A -o %cpu= 2>/dev/null | awk -v n="$ncpu" '{s+=$1} END {v=s/n; if(v>100) printf "100"; else printf "%.0f", v}')
    mem=$(memory_pressure 2>/dev/null | awk '/percentage/{printf "%.0f", $5}')
    ;;
  Linux)
    cpu=$(awk '/^cpu /{u=$2+$4; t=$2+$4+$5; if(t>0) printf "%.0f", u/t*100}' /proc/stat 2>/dev/null)
    mem=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{if(t>0) printf "%.0f", (t-a)/t*100}' /proc/meminfo 2>/dev/null)
    ;;
  *) # Windows (MSYS2 / Git Bash) — typeperf is native, no PowerShell overhead
    line=$(typeperf.exe "\Processor(_Total)\% Processor Time" "\Memory\% Committed Bytes In Use" -sc 1 2>/dev/null | sed -n '3p')
    cpu=$(echo "$line" | awk -F'","' '{gsub(/"/, "", $2); printf "%.0f", $2}')
    mem=$(echo "$line" | awk -F'","' '{gsub(/"/, "", $3); printf "%.0f", $3}')
    ;;
esac

result="󰍛 ${cpu:-?}% 󰘚 ${mem:-?}%"
echo "$result" > "$CACHE"
echo "$result"
