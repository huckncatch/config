# ==============================================================================
# HOMEBREW CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Contains Homebrew-specific aliases and functions
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Exclude CLAUDECODE to prevent aliases from persisting in snapshots (see 01_aliases.zsh)
if [[ -o interactive ]]; then
  alias bi='brew info'
  alias bs='brew search'
  alias blc='brew list --cask'
  alias bis='brew install'
  alias bcu='brew cu --all'
  alias bus='brew uninstall'
  alias btr='brew deps --tree'

  ## brew plugin overrides
  alias bubo='brew update && brew outdated --formulae'
  alias bup='brew upgrade --formulae'
  alias bubc='brew upgrade --formulae && brew cleanup'
  unalias bugbc
  unalias bubug
  unalias bcubo
  unalias bcubc
fi
