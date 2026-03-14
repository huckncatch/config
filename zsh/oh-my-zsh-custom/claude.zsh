# ==============================================================================
# CLAUDE CODE CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Configures Claude Code for Homebrew installation to prevent conflicts with
# the native installer auto-update system
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Use XDG-compliant config directory instead of the default ~/.claude/
# This makes Claude Code read CLAUDE.md global instructions from ~/.config/claude/CLAUDE.md
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

# Prevent auto-updates to ~/.local/bin/claude (use Homebrew instead)
export DISABLE_AUTOUPDATER=1
export DISABLE_INSTALLATION_CHECKS=1
