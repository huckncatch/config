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

# Create worktree with automatic path naming and support file sync
# Usage: gwta -b <local-branch> -a <app> [-r <remote-branch>] [-B <base-branch>]
# Creates worktree at ~/Developer/${app}_${local_branch} and syncs app-specific files
unalias gwta 2>/dev/null
gwta() {
    # Parse options using zparseopts
    local -A opts
    zparseopts -D -E -A opts -- r: b: a: B: h -help=h

    # Show help if requested
    if [[ -v opts[-h] ]]; then
        cat <<'EOF'
Usage: gwta -b <local-branch> -a <app> [-r <remote-branch>] [-B <base-branch>]

Create a git worktree with automatic path naming and support file sync.

Options:
  -b <branch>       Local branch name (required)
  -a <app>          App name for worktree path (required)
  -r <remote>       Remote branch to track (e.g., origin/feature-branch)
  -B <base>         Base branch to create from (default: current branch)
  -h, --help        Show this help message

Examples:
  # Create worktree from remote branch (local branch must not exist)
  gwta -r origin/feature -b feature -a myapp

  # Create worktree for existing local branch
  gwta -b existing-feature -a myapp

  # Create new branch from current branch
  gwta -b new-feature -a myapp

  # Create new branch from specified base
  gwta -b new-feature -a myapp -B main

  # ADO ticket branch (extracts ticket number for worktree name)
  gwta -r origin/jtm/poc/ab#123456-option_exploration -b jtm/poc/ab#123456-option_exploration -a Lobby
  # Creates: ~/Developer/Lobby_123456-option_exploration

  # Branch with slashes (extracts final component)
  gwta -b jtm/poc/temp-branch -a myapp
  # Creates: ~/Developer/myapp_temp-branch

  # Options can be in any order
  gwta -a myapp -b new-feature -B develop

Creates worktree at ~/Developer/${app}_${worktree_suffix}
- For branches with 'ab#' (ADO tickets), extracts everything after 'ab#'
- For other branches with slashes, extracts the final component after the last '/'
- For simple branch names, uses the full name

Branch behavior:
- Without -r: Uses existing local branch if it exists, otherwise creates new branch
- With -r: Local branch must not exist (creates from remote)
EOF
        return 0
    fi

    # Extract parameters
    local local_branch="${opts[-b]}"
    local app="${opts[-a]}"
    local remote_branch="${opts[-r]}"
    local base_branch="${opts[-B]}"

    # Validate required parameters
    if [[ -z "$local_branch" ]]; then
        echo "Error: local branch name (-b) is required"
        echo "Use 'gwta -h' for usage information"
        return 1
    fi

    if [[ -z "$app" ]]; then
        echo "Error: app name (-a) is required"
        echo "Use 'gwta -h' for usage information"
        return 1
    fi

    # Extract worktree suffix from branch name
    # For ADO ticket branches like 'jtm/poc/ab#123456-option_exploration'
    # Extract just '123456-option_exploration' for the worktree name
    # For other branches with slashes like 'jtm/poc/temp-branch'
    # Extract just 'temp-branch' (the part after the last slash)
    local worktree_suffix="$local_branch"
    if [[ "$local_branch" == *"ab#"* ]]; then
        # Extract everything after 'ab#'
        worktree_suffix="${local_branch##*ab#}"
    else
        # Extract everything after the last slash (or use full name if no slash)
        worktree_suffix="${local_branch##*/}"
    fi

    local worktree_path="$HOME/Developer/${app}_${worktree_suffix}"

    # Check if worktree path already exists
    if [[ -d "$worktree_path" ]]; then
        echo "Error: worktree path already exists: $worktree_path"
        return 1
    fi

    # Check if local branch already exists
    local branch_exists=0
    if git show-ref --verify --quiet refs/heads/"$local_branch"; then
        branch_exists=1
    fi

    # If using remote branch (-r), local branch must not exist
    if [[ -n "$remote_branch" && $branch_exists -eq 1 ]]; then
        echo "Error: local branch '$local_branch' already exists (cannot use with -r)"
        return 1
    fi

    # Create worktree based on mode
    if [[ -n "$remote_branch" ]]; then
        # Mode 1: Create from remote branch
        echo "Creating worktree from remote branch '$remote_branch'..."
        if ! git worktree add -b "$local_branch" "$worktree_path" "$remote_branch"; then
            echo "Error: failed to create worktree from remote branch"
            return 1
        fi
    elif [[ $branch_exists -eq 1 ]]; then
        # Mode 2: Use existing local branch
        echo "Creating worktree using existing branch '$local_branch'..."
        if ! git worktree add "$worktree_path" "$local_branch"; then
            echo "Error: failed to create worktree from existing branch"
            return 1
        fi
    else
        # Mode 3: Create new branch from base
        if [[ -z "$base_branch" ]]; then
            # Use current branch as base
            base_branch=$(git_current_branch)
            echo "Creating worktree with new branch from current branch '$base_branch'..."
        else
            echo "Creating worktree with new branch from base branch '$base_branch'..."
        fi

        if ! git worktree add -b "$local_branch" "$worktree_path" "$base_branch"; then
            echo "Error: failed to create worktree from base branch"
            return 1
        fi
    fi

    # Sync support files
    echo "Syncing support files..."
    local -a synced=() failed=()

    # Copy vscode files
    if mkdir -p "$worktree_path/.vscode" 2>/dev/null && \
       cp -r ~/Documents/Obsidian/Alaska/Development/repo_files/Common/dotvscode/* "$worktree_path/.vscode/" 2>/dev/null; then
        synced+=(".vscode/*")
    else
        failed+=(".vscode/* (common)")
    fi

    # Copy copilot-instructions.md
    if mkdir -p "$worktree_path/.github" 2>/dev/null && \
       cp ~/Documents/Obsidian/Alaska/Development/repo_files/$app/github/copilot-instructions.md "$worktree_path/.github/" 2>/dev/null; then
        synced+=(".github/copilot-instructions.md")
    else
        failed+=(".github/copilot-instructions.md ($app)")
    fi

    # Copy chatmode files
    if mkdir -p "$worktree_path/.github/chatmodes" 2>/dev/null && \
       cp -r ~/Documents/Obsidian/Alaska/Development/repo_files/Common/github/chatmodes/* "$worktree_path/.github/chatmodes/" 2>/dev/null; then
        synced+=(".github/chatmodes/*")
    else
        failed+=(".github/chatmodes/* (common)")
    fi

    # Copy instructions files
    if mkdir -p "$worktree_path/.github/instructions" 2>/dev/null && \
       cp -r ~/Documents/Obsidian/Alaska/Development/repo_files/Common/github/instructions/* "$worktree_path/.github/instructions/" 2>/dev/null; then
        synced+=(".github/instructions/*")
    else
        failed+=(".github/instructions/* (common)")
    fi

    # Copy IDETemplateMacros.plist
    for xcodeproj in "$worktree_path"/*.xcodeproj(N); do
        if [[ -d "$xcodeproj" ]]; then
            local xcodeproj_name=$(basename "$xcodeproj")
            if mkdir -p "$xcodeproj/xcshareddata" 2>/dev/null && \
               cp ~/Documents/Obsidian/Alaska/Development/repo_files/Common/IDETemplateMacros.plist "$xcodeproj/xcshareddata/" 2>/dev/null; then
                synced+=("$xcodeproj_name/xcshareddata/IDETemplateMacros.plist")
            else
                failed+=("$xcodeproj_name/xcshareddata/IDETemplateMacros.plist")
            fi
            break  # Only copy to the first .xcodeproj found
        fi
    done

    # Copy files with -src pattern (removing -src from filename)
    ## Common files
    for file in ~/Documents/Obsidian/Alaska/Development/repo_files/Common/*-src.*(N); do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local new_name=${filename/-src./\.}
            if cp "$file" "$worktree_path/$new_name" 2>/dev/null; then
                synced+=("$new_name (common)")
            else
                failed+=("$new_name (common)")
            fi
        fi
    done
    for file in ~/Documents/Obsidian/Alaska/Development/repo_files/Common/dot-*(N); do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local new_name=${filename/dot-/\.}
            if cp "$file" "$worktree_path/$new_name" 2>/dev/null; then
                synced+=("$new_name (common)")
            else
                failed+=("$new_name (common)")
            fi
        fi
    done
    ## App-specific files
    for file in ~/Documents/Obsidian/Alaska/Development/repo_files/$app/*-src.*(N); do
        if [[ -f "$file" ]]; then
            local filename=$(basename "$file")
            local new_name=${filename/-src./\.}
            if cp "$file" "$worktree_path/$new_name" 2>/dev/null; then
                synced+=("$new_name ($app)")
            else
                failed+=("$new_name ($app)")
            fi
        fi
    done

    # Print sync summary
    echo ""
    if (( ${#synced} > 0 )); then
        echo "Synced (${#synced}):"
        for item in "${synced[@]}"; do
            echo "  + $item"
        done
    fi
    if (( ${#failed} > 0 )); then
        echo "Failed (${#failed}):"
        for item in "${failed[@]}"; do
            echo "  - $item"
        done
    fi

    echo ""
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
