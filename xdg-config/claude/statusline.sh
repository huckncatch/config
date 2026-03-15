#!/bin/bash
# Claude Code Status Line
# Shows: Model | Context% | Directory | Uptime | Cost

# Read JSON input from stdin
input=$(cat)

# Extract values using jq
MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd')
COST=$(printf "%.2f" "$COST")

# Calculate context usage percentage
USAGE=$(echo "$input" | jq '.context_window.current_usage')
if [ "$USAGE" != "null" ]; then
    INPUT_TOKENS=$(echo "$USAGE" | jq '.input_tokens // 0')
    CACHE_CREATE=$(echo "$USAGE" | jq '.cache_creation_input_tokens // 0')
    CACHE_READ=$(echo "$USAGE" | jq '.cache_read_input_tokens // 0')
    CURRENT_TOKENS=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
    PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    PERCENT_FREE=$((100 - PERCENT_USED))
else
    PERCENT_USED=0
    PERCENT_FREE=100
fi

# ANSI color codes
ORANGE='\033[38;5;208m'
RED='\033[31m'
YELLOW='\033[33m'
GREEN='\033[32m'
CYAN='\033[36m'
GRAY='\033[90m'
RESET='\033[0m'

# Get OS uptime
get_os_uptime() {
    local boot_time
    boot_time=$(sysctl -n kern.boottime | awk '{print $4}' | sed 's/,//')
    local current_time
    current_time=$(date +%s)
    local uptime_seconds=$((current_time - boot_time))

    local days=$((uptime_seconds / 86400))
    local hours=$(((uptime_seconds % 86400) / 3600))
    local minutes=$(((uptime_seconds % 3600) / 60))

    if [ $days -gt 0 ]; then
        printf "%dd %dh" $days $hours
    elif [ $hours -gt 0 ]; then
        printf "%dh %dm" $hours $minutes
    else
        printf "%dm" $minutes
    fi
}

UPTIME=$(get_os_uptime)

# Get directory basename
DIR_NAME="${CURRENT_DIR##*/}"

# Context color based on usage (warning indicators)
if [ $PERCENT_USED -ge 80 ]; then
    CONTEXT_COLOR=$RED
    WARNING="⚠ "
elif [ $PERCENT_USED -ge 60 ]; then
    CONTEXT_COLOR=$YELLOW
    WARNING=""
else
    CONTEXT_COLOR=$GREEN
    WARNING=""
fi

# Build status line
STATUS="${ORANGE}${MODEL}${RESET}"
STATUS="${STATUS} ${GRAY}|${RESET} ${WARNING}${CONTEXT_COLOR}${PERCENT_USED}%${RESET}${GRAY}/${RESET}${PERCENT_FREE}% free"
STATUS="${STATUS} ${GRAY}|${RESET} ${CYAN}${DIR_NAME}${RESET}"
STATUS="${STATUS} ${GRAY}|${RESET} ${UPTIME}"
STATUS="${STATUS} ${GRAY}|${RESET} \$${COST}"

echo -e "$STATUS"
