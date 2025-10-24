# ==============================================================================
# PROFILE TEMPLATE - WORK ENVIRONMENT
# ==============================================================================
#
# TEMPLATE FILE: Tracked in git as a reference configuration
# INSTALLED TO: ~/.config/zsh/profile.local during new-computer-install.sh
#
# PURPOSE:
# Defines machine-specific settings that must be loaded BEFORE oh-my-zsh
# initialization (theme and plugins). This allows different machines to use
# different themes or plugin sets while sharing the same base configuration.
#
# CUSTOMIZATION:
# - DO NOT edit this template for machine-specific changes
# - Edit ~/.config/zsh/profile.local instead (not tracked in git)
# - This template serves as a starting point for work machines
#
# WHAT TO DEFINE:
# - ZSH_THEME: The oh-my-zsh theme to use
# - plugins: Array of oh-my-zsh plugins to load
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "  ${0:A}"

# Machine profile marker for conditional configuration
export MACHINE_PROFILE="work"

# Theme
ZSH_THEME="my-jonathan"

# Load P10k configuration if it exists
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Plugins
plugins=(
  zsh-nvm
  profiles
  alias-finder
  bbedit
  brew
  git
  gitfast
  git-prompt
  iterm2
  npm
  sudo
  tmux
  vscode
  zsh-autosuggestions
  fast-syntax-highlighting
)
