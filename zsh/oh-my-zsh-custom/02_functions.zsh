echo ".../oh-my-zsh-custom/02_functions.zsh"

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

# clean () {
#     local wdir

#     wdir=$1
#     if (( $# == 0 ))
#         then wdir="."
#     fi

#     /bin/rm -i $wdir/**/\#*
#     /bin/rm -i $wdir/**/^DerivedData/*~
#     /bin/rm -i $wdir/**/*.out
#     /bin/rm -i $wdir/**/*.tmp
#     /bin/rm -i $wdir/**/*.bak
#     /bin/rm -i $wdir/**/*.save*
#     /bin/rm -i $wdir/**/core
#     /bin/rm -i $wdir/**/*.orig
# }

# autoload clean

# git_current_branch () {
# 	local ref
# 	ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
# 	local ret=$?
# 	if [[ $ret != 0 ]]
# 	then
# 		[[ $ret == 128 ]] && return
# 		ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return
# 	fi
# 	echo ${ref#refs/heads/}
# }
#
# # kill_port_proc <port>
# function kill_port_proc {
#     readonly port=${1:?"The port must be specified."}
#
#     lsof -i tcp:"$port" | grep LISTEN | awk '{print $2}'
# }
