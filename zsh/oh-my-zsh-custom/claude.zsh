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
#   The installMethod is configured in xdg-config/claude/settings.json
#   and gets copied to ~/.config/claude/settings.json during new machine setup
#   by the new-computer-install.sh script (via the copy_xdg_config function).
#
#   The settings.json contains:
#   {
#     "installMethod": "homebrew",
#     "autoUpdates": false,
#     "autoUpdatesProtectedForNative": false
#   }
#
export DISABLE_AUTOUPDATER=1
export DISABLE_INSTALLATION_CHECKS=1
