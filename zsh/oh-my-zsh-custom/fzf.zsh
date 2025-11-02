# ==============================================================================
# FZF CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Configures fzf (fuzzy finder) key bindings and default options
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Default search command (uses fd for better performance and hidden file support)
# --type f: only files (not directories)
# --hidden: include hidden files (starting with .)
# --follow: follow symlinks
# --exclude .git: don't search .git directories
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Alternative fd commands for different use cases
# To use: FZF_DEFAULT_COMMAND=$FZF_FD_ALL fzf
export FZF_FD_FILES='fd --type f --hidden --follow --exclude .git'           # files + hidden (default)
export FZF_FD_FILES_NO_HIDDEN='fd --type f --follow --exclude .git'          # files, no hidden
export FZF_FD_DIRS='fd --type d --hidden --follow --exclude .git'            # directories + hidden
export FZF_FD_DIRS_NO_HIDDEN='fd --type d --follow --exclude .git'           # directories, no hidden
export FZF_FD_ALL='fd --hidden --follow --exclude .git'                      # files + dirs + hidden
export FZF_FD_ALL_NO_HIDDEN='fd --follow --exclude .git'                     # files + dirs, no hidden

# Key bindings for executing files with different editors
# Ctrl+O: Open in VS Code, Ctrl+B: Open in BBEdit
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort,ctrl-b:execute(bbedit {})+abort'"

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# FZF helper functions for different search modes
# These override FZF_DEFAULT_COMMAND temporarily for specific use cases

fzf-files() {
    # Search only files (including hidden), no directories
    FZF_DEFAULT_COMMAND=$FZF_FD_FILES fzf "$@"
}

fzf-files-no-hidden() {
    # Search only files, excluding hidden files
    FZF_DEFAULT_COMMAND=$FZF_FD_FILES_NO_HIDDEN fzf "$@"
}

fzf-dirs() {
    # Search only directories (including hidden)
    FZF_DEFAULT_COMMAND=$FZF_FD_DIRS fzf "$@"
}

fzf-dirs-no-hidden() {
    # Search only directories, excluding hidden
    FZF_DEFAULT_COMMAND=$FZF_FD_DIRS_NO_HIDDEN fzf "$@"
}

fzf-all() {
    # Search both files and directories (including hidden)
    FZF_DEFAULT_COMMAND=$FZF_FD_ALL fzf "$@"
}

fzf-all-no-hidden() {
    # Search both files and directories, excluding hidden
    FZF_DEFAULT_COMMAND=$FZF_FD_ALL_NO_HIDDEN fzf "$@"
}

