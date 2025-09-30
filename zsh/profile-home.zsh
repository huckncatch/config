if [[ "$DEBUG_STARTUP" == "1" ]]; then
  echo ${0:A}
fi

# Profile-specific settings for home environment
# This file should be sourced BEFORE zshrc.base

# Theme selection
ZSH_THEME="my-jonathan"

# Plugin configuration
plugins=(
  zsh-nvm
  profiles
  alias-finder
  bbedit
  brew
  common-aliases
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
