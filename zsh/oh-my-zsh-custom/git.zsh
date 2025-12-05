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

# Create worktree from remote branch with automatic path naming and support file sync
# Usage: gwta <remote-branch-name> <local-branch-name> <app>
# Creates worktree at ~/Development/${app}_${local_branch} and syncs app-specific files
unalias gwta 2>/dev/null
gwta() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
        echo "Usage: gwta <remote-branch-name> <local-branch-name> <app>"
        return 1
    fi

    local remote_branch=$1
    local local_branch=$2
    local app=$3
    local worktree_path="$HOME/Developer/${app}_${local_branch}"

    # Check if worktree path already exists
    if [ -d "$worktree_path" ]; then
        echo "Error: worktree path already exists: $worktree_path"
        return 1
    fi

    # Check if local branch already exists
    if git show-ref --verify --quiet refs/heads/"$local_branch"; then
        echo "Error: local branch '$local_branch' already exists"
        return 1
    fi

    # Create worktree
    if ! git worktree add -b "$local_branch" "$worktree_path" "$remote_branch"; then
        echo "Error: failed to create worktree"
        return 1
    fi

    # Sync support files
    echo "Syncing support files..."

    # Copy copilot-instructions.md
    mkdir`` -p "$worktree_path/.github" || echo "Failed to create .github directory"
    cp ~/Documents/Obsidian/Alaska/Development/repo_files/$app/github/copilot-instructions.md "$worktree_path/.github/" || echo "Failed to copy copilot-instructions.md"

    # Copy chatmode files
    mkdir -p "$worktree_path/.github/chatmodes" || echo "Failed to create chatmodes directory"
    cp -r ~/Documents/Obsidian/Alaska/Development/repo_files/Common/github/chatmodes/* "$worktree_path/.github/chatmodes/" || echo "Failed to copy chatmode files"

    # Copy IDETemplateMacros.plist
    for xcodeproj in "$worktree_path"/*.xcodeproj; do
        if [ -d "$xcodeproj" ]; then
            mkdir -p "$xcodeproj/xcshareddata" || echo "Failed to create xcshareddata directory in $xcodeproj"
            cp ~/Documents/Obsidian/Alaska/Development/repo_files/Common/IDETemplateMacros.plist "$xcodeproj/xcshareddata/" || echo "Failed to copy IDETemplateMacros.plist to $xcodeproj"
            break  # Only copy to the first .xcodeproj found
        fi
    done

    # Copy files with -src pattern (removing -src from filename)
    for file in ~/Documents/Obsidian/Alaska/Development/repo_files/$app/*-src.*; do
        if [ -f "$file" ]; then
            local filename=$(basename "$file")
            local new_name=${filename/-src./\.}
            cp "$file" "$worktree_path/$new_name" || echo "Failed to copy $file"
        fi
    done

    echo "Worktree ready at $worktree_path"
}
compdef _git gwta=git-worktree
autoload gwta

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
