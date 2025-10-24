# ==============================================================================
# GIT CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Contains git-specific aliases and functions
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Exclude CLAUDECODE to prevent aliases from persisting in snapshots (see 01_aliases.zsh)
if [[ -o interactive ]]; then
  alias gt='git tag'
  alias gpot='git push origin "$(git_current_branch)" && git push origin --tags'
  alias gfst='git fetch && git status'
  alias gfasb='git fetch --all --prune && git status --short --branch'
  alias grs.='git restore .'
  alias gsw-='git switch -'
  alias gbd!='git branch -D `git_previous_branch`'
fi

# switch to main branch, delete old branch
# git switch clean
function gswclm() {
  gsw `git_main_branch`
  gfa
  gl
  gbd `git_previous_branch`
}
compdef _git gswclm=git-switch

autoload gswclm

# switch to new branch, delete old branch
# git switch clean
function gswcl() {
  readonly nwb=${1:?"Must specify a branch name."}
  local cwb
  cwb=`git_current_branch`
  gsw `git_main_branch`
  gfa
  gl
  gsw $nwb
  gbd $cwb
}
compdef _git gswcl=git-switch

autoload gswcl

# ==============================================================================
# WORK-SPECIFIC GIT FUNCTION OVERRIDES
# ==============================================================================
# Override oh-my-zsh git plugin aliases to handle branch names with # symbols
# (e.g., JPG/AB#1398231-Simulator_camera_crash_fix)
#
# These must be defined AFTER oh-my-zsh initialization (which happens after
# profile loading), so they're placed here in the custom directory rather than
# in the profile file.

if [[ "$MACHINE_PROFILE" == "work" ]]; then
  unalias gsw 2>/dev/null
  function _gsw_impl() {
    git switch "$*"
  }
  alias gsw='noglob _gsw_impl'

  unalias gswc 2>/dev/null
  function _gswc_impl() {
    git switch --create "$*"
  }
  alias gswc='noglob _gswc_impl'
fi
