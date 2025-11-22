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

# Prevent auto-updates to ~/.local/bin/claude (use Homebrew instead)
# Install Method Configuration:
#   Claude Code stores settings in ~/.claude.json (not ~/.config/claude/settings.json)
#   For Homebrew installations, ensure these fields are set in ~/.claude.json:
#   {
#     "installMethod": "homebrew",
#     "autoUpdates": false
#   }
#
export DISABLE_AUTOUPDATER=1
export DISABLE_INSTALLATION_CHECKS=1
