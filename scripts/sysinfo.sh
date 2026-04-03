#!/bin/bash
# sysinfo.sh — CPU/MEM status bar widget (cross-platform)
# Optimized: uses typeperf on Windows instead of spawning PowerShell

case "$(uname -s)" in
  Darwin)
    cpu=$(top -l 1 -n 0 2>/dev/null | awk '/CPU usage/{printf "%.0f", $3}')
    mem=$(memory_pressure 2>/dev/null | awk '/percentage/{printf "%.0f", $5}')
    ;;
  Linux)
    cpu=$(awk '/^cpu /{u=$2+$4; t=$2+$4+$5; if(t>0) printf "%.0f", u/t*100}' /proc/stat 2>/dev/null)
    mem=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{if(t>0) printf "%.0f", (t-a)/t*100}' /proc/meminfo 2>/dev/null)
    ;;
  *) # Windows (MSYS2 / Git Bash) — typeperf is native and fast, no PowerShell overhead
    line=$(typeperf.exe "\Processor(_Total)\% Processor Time" "\Memory\% Committed Bytes In Use" -sc 1 2>/dev/null | sed -n '3p')
    cpu=$(echo "$line" | awk -F'","' '{gsub(/"/, "", $2); printf "%.0f", $2}')
    mem=$(echo "$line" | awk -F'","' '{gsub(/"/, "", $3); printf "%.0f", $3}')
    ;;
esac

echo "󰍛 ${cpu:-?}% 󰘚 ${mem:-?}%"
