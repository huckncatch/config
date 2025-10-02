# git
if [[ "$DEBUG_STARTUP" == "1" ]]; then
  echo ${0:A}
fi

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
