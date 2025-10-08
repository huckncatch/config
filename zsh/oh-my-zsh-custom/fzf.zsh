# ==============================================================================
# FZF CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Configures fzf (fuzzy finder) key bindings and default options
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Default search command (uses ag - The Silver Searcher)
export FZF_DEFAULT_COMMAND='ag -g ""'

# Key bindings for executing files with different editors
# Ctrl+O: Open in VS Code, Ctrl+B: Open in BBEdit
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort,ctrl-b:execute(bbedit {})+abort'"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
