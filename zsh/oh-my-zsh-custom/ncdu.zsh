# ==============================================================================
# NCDU CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# ncdu: interactive disk usage analyzer (NCurses Disk Usage)
# Config: ~/.config/ncdu/config (XDG)
# Skipped in VS Code terminals: ncdu is a full TUI that blocks
# non-interactive callers (Claude Code, Copilot, etc.)
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

if [[ -o interactive ]]; then

  if [[ "$TERM_PROGRAM" != "vscode" ]]; then
    alias du='ncdu'                                # interactive disk usage (config: ~/.config/ncdu/config)
  fi

fi
