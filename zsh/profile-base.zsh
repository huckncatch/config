# ==============================================================================
# PROFILE BASE - SHARED CONFIGURATION
# ==============================================================================
#
# PURPOSE:
# Contains settings shared across all profile templates (home/work).
# Sourced by profile-home.zsh and profile-work.zsh before their specific config.
#
# WHAT TO DEFINE:
# - Environment variables that apply to all machines
# - Plugin configuration that must load before oh-my-zsh
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "  ${0:A}"

# Homebrew environment (must be early to add /opt/homebrew/bin to PATH)
# This is required on Apple Silicon Macs for Homebrew-installed tools
eval "$(/opt/homebrew/bin/brew shellenv)"

# Tmux plugin configuration (must be set before oh-my-zsh loads)
export ZSH_TMUX_AUTOREFRESH=true    # Auto-refresh SSH_AUTH_SOCK in long-running sessions
export ZSH_TMUX_UNICODE=true        # Enable unicode support
