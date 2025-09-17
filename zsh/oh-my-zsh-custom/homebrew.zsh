# homebrew
if [[ "$DEBUG_STARTUP" == "1" ]]; then
  echo ${0:A}
fi

alias bi='brew info'
alias bs='brew search'
alias blc='brew list --cask'
alias bis='brew install'
alias bcu='brew cu --all'
## brew plugin overrides
alias bubo='brew update && brew outdated --formulae'
alias bup='brew upgrade --formulae'
alias bubc='brew upgrade --formulae && brew cleanup'
unalias bugbc
unalias bubug
unalias bcubo
unalias bcubc
