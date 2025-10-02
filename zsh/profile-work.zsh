if [[ "$DEBUG_STARTUP" == "1" ]]; then
  echo ${0:A}
fi

# Profile-specific settings for work environment
# This file should be sourced BEFORE zshrc.base

# Theme selection
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugin configuration
plugins=(
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
  zsh-syntax-highlighting
  zsh-nvm
)
