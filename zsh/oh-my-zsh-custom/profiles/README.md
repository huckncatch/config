# oh-my-zsh profiles

## Overview

This directory contains machine-specific runtime configuration files that are automatically loaded by the Profiles plugin based on hostname. These files work in conjunction with the profile template system to provide comprehensive profile management.

## Dual-Profile System Architecture

The zsh configuration uses two complementary profile systems:

### 1. Profile Templates (Pre-oh-my-zsh)

**Purpose:** Define theme and plugins that must be set BEFORE oh-my-zsh initialization

**Files:**
- `zsh/profile-home.zsh` - Template for personal machines
- `zsh/profile-work.zsh` - Template for work machines
- `~/.config/zsh/profile.local` - Active profile (not tracked in git)

**What they define:**
- `ZSH_THEME` - Theme selection
- `plugins` - oh-my-zsh plugins array
- `MACHINE_PROFILE` - Environment marker ("home" or "work")

**When loaded:** Sourced by `~/.zshrc` BEFORE `zsh/zshrc.base` initializes oh-my-zsh

### 2. Hostname-Based Profiles (During oh-my-zsh)

**Purpose:** Machine-specific runtime configuration loaded DURING oh-my-zsh initialization

**Files:** This directory (`zsh/oh-my-zsh-custom/profiles/`)

**What they define:**
- Machine-specific environment variables (e.g., `SSH_AUTH_SOCK`)
- Custom paths (e.g., `DOTFILES`, `ZSH_TMUX_CONFIG`)
- Runtime configuration that doesn't affect oh-my-zsh initialization

**When loaded:** Automatically loaded by the Profiles plugin based on hostname

**File naming:** Files are named after the machine's hostname (as shown by `hostname` command)

## Adding a New Hostname-Based Profile

To add machine-specific runtime configuration:

1. **Determine the hostname**:

    ```sh
    hostname
    ```

2. **Create the profile file** named after the hostname:

    ```sh
    touch ~/config/zsh/oh-my-zsh-custom/profiles/<hostname>
    ```

3. **Add machine-specific configuration** (examples):

    ```sh
    # SSH agent configuration
    export SSH_AUTH_SOCK='~/Library/Group Containers/...'

    # Custom paths
    export DOTFILES='${HOME}/src/dotfiles'
    export ZSH_TMUX_CONFIG='${HOME}/config/tmux.conf'

    # Optional: Debug marker
    [[ "$DEBUG_STARTUP" == "1" ]] && echo ${0:A}
    ```

4. **Commit to repository** to make it available across machine setups

The Profiles plugin will automatically load this file based on hostname during shell initialization.

## Load Order

1. `~/.zshrc` - Entry point
2. `~/.config/zsh/profile.local` - Sets theme and plugins
3. `~/config/zsh/zshrc.base` - Initializes oh-my-zsh
4. **Profiles plugin loads** `~/config/zsh/oh-my-zsh-custom/profiles/<hostname>`
5. Other oh-my-zsh custom files load alphabetically
