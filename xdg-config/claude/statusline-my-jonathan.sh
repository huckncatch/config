#!/bin/bash

# StatusLine command for Claude Code
# Converts the my-jonathan zsh theme to Claude Code status line
# Input: JSON with session info via stdin

input=$(cat)

# Extract values from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
time_now=$(date +%H:%M:%S)

# Get git info if in a git repo
git_info=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_info=" on $(printf '\033[32m')${branch}$(printf '\033[0m')"
        
        # Check for changes (simplified version of git_prompt_status)
        if ! git diff --quiet 2>/dev/null; then
            git_info="${git_info}$(printf '\033[34m') ✹$(printf '\033[0m')"
        fi
        if ! git diff --cached --quiet 2>/dev/null; then
            git_info="${git_info}$(printf '\033[32m') ✚$(printf '\033[0m')"
        fi
        if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
            git_info="${git_info}$(printf '\033[36m') ✭$(printf '\033[0m')"
        fi
    fi
fi

# Shorten path similar to %~ in zsh (replace home with ~)
display_path="${current_dir/#$HOME/\~}"

# Build the prompt with colors matching my-jonathan theme
# Cyan for structure, green for path, yellow for time, cyan for user@host
printf '\033[36m─(\033[32m%s\033[36m)─────(\033[36m%s\033[37m@\033[32m%s\033[36m)─\n' \
    "$display_path" \
    "$(whoami)" \
    "$(hostname -s)"

printf '\033[36m─(\033[33m%s\033[36m%s)─> \033[0m' \
    "$time_now" \
    "$git_info"
