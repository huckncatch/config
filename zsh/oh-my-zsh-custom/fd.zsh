# ==============================================================================
# FD CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# fd: fast, user-friendly alternative to find
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

if [[ -o interactive ]]; then

  # File searching
  alias ff='fd --type f --hidden --exclude .git'   # find files (including hidden, excluding .git)

  # Content searching (fd + ripgrep pipeline)
  alias gfind='fd --type f --hidden --follow --exec rg -nH'  # search in file contents with line numbers

  # File cleanup
  alias clean="fd -H -t f -e orig -x rm"           # remove .orig files (merge artifacts)

fi
