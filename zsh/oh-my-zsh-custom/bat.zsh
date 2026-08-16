# ==============================================================================
# BAT CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# bat: syntax-highlighting replacement for cat
# Skipped in VS Code terminals: bat wraps output with headers/paging that
# confuses agent output parsing (Claude Code, Copilot, etc.)
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

if [[ -o interactive ]]; then

  if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    if command -v bat &>/dev/null; then
      alias cat='bat'                              # syntax-highlighted output with line numbers
    elif command -v batcat &>/dev/null; then
      alias bat='batcat'                           # Ubuntu: apt installs bat as batcat
      alias cat='batcat'
    fi
  fi

fi
