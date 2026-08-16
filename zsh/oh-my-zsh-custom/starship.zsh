# Starship prompt
# Only active when ZSH_THEME="" (profile opts out of oh-my-zsh theming)
# Config: ~/.config/starship.toml (backed up to xdg-config/starship.toml)
if [[ -z "$ZSH_THEME" ]] && command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi
