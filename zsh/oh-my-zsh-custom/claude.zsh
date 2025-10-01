# if [[ "$DEBUG_STARTUP" == "1" ]]; then
#   echo ${0:A}
# fi

# Claude Code Configuration for Homebrew Installation
#
# When Claude Code is installed via Homebrew, these environment variables
# prevent conflicts with the native installer auto-update system.
#
# DISABLE_AUTOUPDATER: Prevents Claude from auto-updating to ~/.local/bin/claude
#   (Homebrew's auto-updater should be used instead: brew upgrade --cask claude-code)
#
# DISABLE_INSTALLATION_CHECKS: Disables startup warnings about native installation
#   that incorrectly trigger for Homebrew installations
#
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
