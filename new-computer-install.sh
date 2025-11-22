#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Parse command line options
DRY_RUN=0
VERBOSE=0
UPDATE_MODE=0

show_usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Provision a new macOS machine with dotfiles, configurations, and applications.

OPTIONS:
  -d, --dry-run    Show what would be installed without actually installing
  -u, --update     Update mode: sync changed config files only, skip installations
  -v, --verbose    Show detailed output during installation
  -h, --help       Show this help message

EXAMPLES:
  $(basename "$0")              # Run normal installation
  $(basename "$0") --dry-run    # Preview what would be installed
  $(basename "$0") --update     # Update configs after git pull
  $(basename "$0") -u -v        # Update with verbose output
  $(basename "$0") -d -v        # Preview with verbose output

EOF
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -u|--update)
      UPDATE_MODE=1
      shift
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      show_usage
      exit 1
      ;;
  esac
done

if [ $DRY_RUN -eq 1 ]; then
  echo "=== DRY RUN MODE - No changes will be made ==="
  echo ""
fi

# Prerequisites
# This script assumes you have Homebrew installed.
# If you don't have Homebrew installed, run:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Or visit https://brew.sh/

# Initialize Homebrew environment if not already in PATH
# This handles fresh Homebrew installations where shellenv hasn't been run yet
if ! command -v brew &> /dev/null; then
  # Try common Homebrew installation locations
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  else
    echo "Error: Homebrew is not installed. Please install it first."
    echo "Visit https://brew.sh/ for installation instructions."
    echo ""
    echo "Note: After installing Homebrew, you can skip the 'Next Steps' about"
    echo "adding brew shellenv to .zprofile - this script will handle it."
    exit 1
  fi
fi

# Check if we're in the config repository directory
if [ ! -f "./new-computer-install.sh" ]; then
  echo "Error: This script must be run from the config repository directory."
  exit 1
fi

#############################################################################
# HELPER FUNCTIONS
#############################################################################
_read_package_list() {
  local file="$1"
  local packages=()

  if [ ! -f "$file" ]; then
    echo "Warning: Package list file not found: $file" >&2
    return 1
  fi

  # Read file line by line, stripping comments and blank lines
  while IFS= read -r line || [ -n "$line" ]; do
    # Strip inline comments (everything after #)
    line="${line%%#*}"
    # Trim whitespace
    line="$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    # Skip empty lines
    [ -n "$line" ] && packages+=("$line")
  done < "$file"

  # Return packages as newline-separated list
  printf '%s\n' "${packages[@]}"
}

_prompt_install() {
  local response
  read -r -p "$1 (y/n): " response
  if [[ $response == [Yy] || $response == "yes" ]]; then
      echo "yes"
    else
      echo "no"
    fi
}

_brew_list_does_not_contain() {
  local brew_list_output
  brew_list_output=$(brew list 2>/dev/null)
  # echo "Checking if $@ is in the brew list..."
  if [[ $brew_list_output != *"$@"* ]]; then
    # echo "yes"
    return 0
  else
    # echo "no"
    return 1
  fi
}

_should_install() {
  if _brew_list_does_not_contain "$@"; then
    proceed=$(_prompt_install "Install $@?")
    if [[ "$proceed" == "yes" ]]; then
      return 0
    else
      return 1
    fi
  else
    echo "$@ already installed, gonna skip that."
    return 1
  fi
}

brew_install() {
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would install: $@"
  else
    echo "Installing $@..."
    if [ $VERBOSE -eq 1 ]; then
      brew install "$@" || {
        echo "  ⚠ Error installing $@"
        return 0  # Continue with other packages
      }
    else
      local error_output
      error_output=$(brew install "$@" 2>&1) || {
        echo "  ⚠ Error installing $@"
        echo "  Last 5 lines of output:"
        echo "$error_output" | tail -5
        return 0  # Continue with other packages
      }
      echo "  ✓ Installed $@"
    fi
  fi
}

_files_differ() {
  local src="$1"
  local dest="$2"

  # If dest doesn't exist, files differ
  [ ! -f "$dest" ] && return 0

  # Compare file contents
  if ! diff -q "$src" "$dest" > /dev/null 2>&1; then
    return 0  # Files differ
  else
    return 1  # Files identical
  fi
}

_sync_file() {
  local src="$1"
  local dest="$2"
  local mode="${3:-}"  # Optional: file permissions

  if ! _files_differ "$src" "$dest"; then
    [ $VERBOSE -eq 1 ] && echo "  ✓ $dest unchanged"
    return 0
  fi

  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would update: $dest"
    return 0
  fi

  # Backup existing file with timestamp
  if [ -f "$dest" ]; then
    local backup="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$dest" "$backup"
    echo "  ⚠ Backed up: $backup"
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"

  # Copy file
  cp "$src" "$dest"

  # Set permissions if specified
  [ -n "$mode" ] && chmod "$mode" "$dest"

  echo "  ✓ Updated: $dest"
}

_sync_directory_selective() {
  local src_dir="$1"
  local dest_dir="$2"
  local preserve_patterns="$3"  # Patterns to preserve (space-separated)

  if [ -n "$preserve_patterns" ]; then
    echo "  Syncing $dest_dir (preserving: $preserve_patterns)"
  else
    echo "  Syncing $dest_dir"
  fi

  # Find all files in source directory
  find "$src_dir" -type f | while read -r src_file; do
    # Get relative path
    rel_path="${src_file#$src_dir/}"
    dest_file="$dest_dir/$rel_path"

    # Check if file matches preserve pattern
    local should_preserve=0
    for pattern in $preserve_patterns; do
      case "$rel_path" in
        $pattern)
          should_preserve=1
          [ $VERBOSE -eq 1 ] && echo "  ⊘ Preserving: $rel_path"
          break
          ;;
      esac
    done

    # Skip if should preserve
    [ $should_preserve -eq 1 ] && continue

    # Sync the file
    _sync_file "$src_file" "$dest_file"
  done
}

#############################################################################
# PHASE 1: CONFIGURATION FILES
#############################################################################

copy_zsh_config() {
  echo "Setting up zsh configuration..."

  # In update mode, just sync the zshrc file
  if [ $UPDATE_MODE -eq 1 ]; then
    _sync_file "./zsh/zshrc" "$HOME/.zshrc"
    echo "  ⊘ Skipping profile (update mode preserves local profile)"

    # Profile drift detection
    if [ -f "$HOME/.config/zsh/profile.local" ]; then
      local drift_found=0
      if diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-home.zsh" > /dev/null 2>&1; then
        echo "  ✓ Profile matches home template"
      elif diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-work.zsh" > /dev/null 2>&1; then
        echo "  ✓ Profile matches work template"
      else
        echo "  ⚠ Profile drift detected: ~/.config/zsh/profile.local differs from both templates"
        drift_found=1
      fi
    fi

    return 0
  fi

  # Copy main zshrc to home directory
  if [ -f "$HOME/.zshrc" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would back up existing ~/.zshrc to ~/.zshrc.backup"
    else
      echo "  Backing up existing ~/.zshrc to ~/.zshrc.backup"
      cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
  fi

  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would copy zshrc to ~/.zshrc"
  else
    cp "./zsh/zshrc" "$HOME/.zshrc" || { echo "Error: Failed to copy zshrc"; exit 1; }
    echo "  Copied zshrc to ~/.zshrc"
  fi

  # Create ~/.config/zsh directory if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.config/zsh"
  else
    mkdir -p "$HOME/.config/zsh"
  fi

  # Prompt for profile selection and create profile.local
  local profile_source
  if [ -f "$HOME/.config/zsh/profile.local" ]; then
    echo "  Profile already exists at ~/.config/zsh/profile.local, skipping."

    # Profile drift detection (also run in normal mode)
    if diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-home.zsh" > /dev/null 2>&1; then
      echo "  ✓ Profile matches home template"
    elif diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-work.zsh" > /dev/null 2>&1; then
      echo "  ✓ Profile matches work template"
    else
      echo "  ⚠ Profile drift detected: ~/.config/zsh/profile.local differs from both templates"
    fi
  else
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would prompt for profile selection and create ~/.config/zsh/profile.local"
    else
      personal=$(_prompt_install "Personal/Home config?")
      if [[ "$personal" == "yes" ]]; then
        echo "  Creating home profile..."
        profile_source="./zsh/profile-home.zsh"
      else
        echo "  Creating work profile..."
        profile_source="./zsh/profile-work.zsh"
      fi

      cp "$profile_source" "$HOME/.config/zsh/profile.local" || { echo "Error: Failed to copy profile"; exit 1; }
      echo "  Created ~/.config/zsh/profile.local"
    fi
  fi
}

# Copy dotfiles to home directory
copy_dotfiles() {
  echo "Copying dotfiles..."

  for item in ./dotfiles/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")

      # Special handling for SSH config
      if [ "$itemname" = "ssh-config" ]; then
        if [ $UPDATE_MODE -eq 1 ]; then
          echo "  ⊘ Skipping SSH config in update mode (manual merge recommended)"
          continue
        fi

        if [ -f "$HOME/.ssh/config" ]; then
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.ssh/config to ~/.ssh/config.backup"
          else
            echo "  Backing up existing ~/.ssh/config to ~/.ssh/config.backup"
            cp "$HOME/.ssh/config" "$HOME/.ssh/config.backup"
          fi
        fi
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy SSH config to ~/.ssh/config"
        else
          echo "  Copying SSH config to ~/.ssh/config"
          mkdir -p "$HOME/.ssh"
          chmod 700 "$HOME/.ssh"
          cp "$item" "$HOME/.ssh/config"
          chmod 600 "$HOME/.ssh/config"
        fi
      else
        # Use smart sync in update mode
        if [ $UPDATE_MODE -eq 1 ]; then
          _sync_file "$item" "$HOME/.$itemname"
        else
          if [ -f "$HOME/.$itemname" ]; then
            if [ $DRY_RUN -eq 1 ]; then
              echo "  [DRY RUN] Would back up existing ~/.$itemname to ~/.$itemname.backup"
            else
              echo "  Backing up existing ~/.$itemname to ~/.$itemname.backup"
              cp "$HOME/.$itemname" "$HOME/.$itemname.backup"
            fi
          fi
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would copy $itemname to ~/.$itemname"
          else
            echo "  Copying $itemname to ~/.$itemname"
            cp "$item" "$HOME/.$itemname"
          fi
        fi
      fi
    fi
  done
}

# Copy XDG config files
copy_xdg_config() {
  echo "Copying XDG config files..."

  # Create ~/.config if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.config"
  else
    mkdir -p "$HOME/.config"
  fi

  # Track unknown configs for final summary
  local unknown_configs=()

  # Copy each directory from xdg-config/ to ~/.config/
  for item in ./xdg-config/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")

      if [ $UPDATE_MODE -eq 1 ]; then
        # Define preservation patterns per config directory
        case "$itemname" in
          "claude")
            # Preserve everything except CLAUDE.md and settings.json
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "local/* projects/* statsig/* todos/* hooks/*"
            ;;
          "karabiner")
            # Preserve automatic backups and assets
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "automatic_backups/* assets/*"
            ;;
          "git"|"tmux"|"ncdu")
            # These are safe to fully sync
            _sync_directory_selective "$item" "$HOME/.config/$itemname" ""
            ;;
          *)
            echo "  ⚠ Unknown config: $itemname (skipping in update mode)"
            unknown_configs+=("$itemname")
            ;;
        esac
      else
        # Normal mode: backup and copy entire directory
        if [ -e "$HOME/.config/$itemname" ]; then
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.config/$itemname to ~/.config/$itemname.backup"
          else
            echo "  Backing up existing ~/.config/$itemname to ~/.config/$itemname.backup"
            cp -r "$HOME/.config/$itemname" "$HOME/.config/$itemname.backup"
          fi
        fi
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy directory $itemname to ~/.config/"
        else
          echo "  Copying directory $itemname to ~/.config/"
          cp -r "$item" "$HOME/.config/"
        fi
      fi
    fi
  done

  # Display unknown configs summary if any
  if [ ${#unknown_configs[@]} -gt 0 ] && [ $UPDATE_MODE -eq 1 ]; then
    echo ""
    echo "  Unknown configs skipped in update mode:"
    for config in "${unknown_configs[@]}"; do
      echo "    - $config"
    done
    echo "  To update these, run without --update flag or add them to copy_xdg_config()"
  fi
}

# Copy Claude Code user settings to ~/.claude/
# This is separate from XDG config because ~/.claude/ doesn't follow XDG spec
copy_claude_settings() {
  echo "Copying Claude Code user settings..."

  # Create ~/.claude if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.claude"
  else
    mkdir -p "$HOME/.claude"
  fi

  # Copy settings.json from claude/ to ~/.claude/
  local source_file="./claude/settings.json"
  local target_file="$HOME/.claude/settings.json"

  if [ -f "$source_file" ]; then
    if [ $UPDATE_MODE -eq 1 ]; then
      # In update mode, use smart sync
      if [ -f "$target_file" ]; then
        if ! diff -q "$source_file" "$target_file" > /dev/null 2>&1; then
          local backup_name="settings.json.backup.$(date +%Y%m%d_%H%M%S)"
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would backup $target_file to $HOME/.claude/$backup_name"
            echo "  [DRY RUN] Would update $target_file"
          else
            echo "  Backing up $target_file to $HOME/.claude/$backup_name"
            cp "$target_file" "$HOME/.claude/$backup_name"
            echo "  Updating $target_file"
            cp "$source_file" "$target_file"
          fi
        else
          [ $VERBOSE -eq 1 ] && echo "  $target_file unchanged, skipping"
        fi
      else
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy settings.json to ~/.claude/"
        else
          echo "  Copying settings.json to ~/.claude/"
          cp "$source_file" "$target_file"
        fi
      fi
    else
      # Normal mode: backup and copy
      if [ -f "$target_file" ]; then
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would back up existing $target_file"
        else
          echo "  Backing up existing $target_file"
          cp "$target_file" "$target_file.backup"
        fi
      fi
      if [ $DRY_RUN -eq 1 ]; then
        echo "  [DRY RUN] Would copy settings.json to ~/.claude/"
      else
        echo "  Copying settings.json to ~/.claude/"
        cp "$source_file" "$target_file"
      fi
    fi
  else
    echo "  ⚠ Warning: $source_file not found, skipping"
  fi
}

#############################################################################
# PHASE 2: SHELL ENVIRONMENT SETUP
#############################################################################

if [ $UPDATE_MODE -eq 0 ]; then
  ## Homebrew taps
  # Tap all required repositories before installing packages
  brew_taps=(
    "buo/cask-upgrade"          # Used by brew cu command to upgrade casks
    "homebrew/cask-fonts"       # Required for font installations
  )

  for tap in "${brew_taps[@]}"; do
    if [ $DRY_RUN -eq 1 ]; then
      echo "[DRY RUN] Would tap: $tap"
    else
      brew tap "$tap" 2>/dev/null || echo "  Already tapped: $tap"
    fi
  done

  ## oh-my-zsh installation
  # Installs without changing default shell or running zsh after installation
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "[DRY RUN] Would install oh-my-zsh"
    else
      echo "Installing oh-my-zsh..."
      if [ $VERBOSE -eq 1 ]; then
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      else
        RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1 && echo "✓ Installed oh-my-zsh" || echo "Error installing oh-my-zsh"
      fi
    fi
  else
    echo "oh-my-zsh already installed, skipping."
  fi

  ## zsh plugins installation
  ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"

  # Define plugins as "name|repository_url"
  zsh_plugins=(
    "zsh-completions|https://github.com/zsh-users/zsh-completions"
    "zsh-nvm|https://github.com/lukechilds/zsh-nvm"
    "fast-syntax-highlighting|https://github.com/zdharma-continuum/fast-syntax-highlighting"
  )

  # Install each plugin
  for plugin_spec in "${zsh_plugins[@]}"; do
    plugin_name="${plugin_spec%%|*}"
    plugin_url="${plugin_spec##*|}"
    plugin_path="$ZSH_CUSTOM_DIR/plugins/$plugin_name"

    if [ ! -d "$plugin_path" ]; then
      if [ $DRY_RUN -eq 1 ]; then
        echo "[DRY RUN] Would install $plugin_name"
      else
        echo "Installing $plugin_name..."
        if [ $VERBOSE -eq 1 ]; then
          git clone "$plugin_url" "$plugin_path"
        else
          git clone "$plugin_url" "$plugin_path" > /dev/null 2>&1 && echo "✓ Installed $plugin_name" || echo "Error installing $plugin_name"
        fi
      fi
    else
      echo "$plugin_name already installed, skipping."
    fi
  done
else
  echo ""
  echo "Skipping shell environment setup (update mode)"
  echo ""
fi

#############################################################################
# PHASE 3: PACKAGE INSTALLATION
#############################################################################

if [ $UPDATE_MODE -eq 0 ]; then
  ## Homebrew packages
  # https://formulae.brew.sh/formula/
  echo "Check formulae..."

  # Read packages from external file into array
  packages=()
  for package in $(_read_package_list "./homebrew/formulae.zsh"); do
    packages+=("$package")
  done

  # Gather package selections
  packages_to_install=()
  for formula in "${packages[@]}"
  do
    if _should_install "$formula"; then
      packages_to_install+=("$formula")
    fi
  done

  # Install selected packages
  if [ ${#packages_to_install[@]} -gt 0 ]; then
    echo ""
    echo "Installing ${#packages_to_install[@]} selected packages..."
    for formula in "${packages_to_install[@]}"
    do
      brew_install "$formula"
    done
  else
    echo "No packages selected for installation."
  fi

  ## Homebrew cask applications
  # https://formulae.brew.sh/cask/
  echo ""
  echo "Check apps..."

  # Read applications from external file into array
  applications=()
  for app in $(_read_package_list "./homebrew/casks.zsh"); do
    applications+=("$app")
  done

  # Gather application selections
  apps_to_install=()
  for cask in "${applications[@]}"
  do
    if _should_install "$cask"; then
      apps_to_install+=("$cask")
    fi
  done

  # Install selected applications
  if [ ${#apps_to_install[@]} -gt 0 ]; then
    echo ""
    echo "Installing ${#apps_to_install[@]} selected applications..."
    for cask in "${apps_to_install[@]}"
    do
      brew_install "$cask"
    done
  else
    echo "No applications selected for installation."
  fi

  ## Pinned applications (specific versions to avoid paid upgrades)
  echo "Installing pinned cask versions..."
  for app in ./homebrew/pinned_casks/*.rb; do
    if [ -e "$app" ]; then
      if [ $DRY_RUN -eq 1 ]; then
        echo "  [DRY RUN] Would install $(basename "$app" .rb)"
      else
        echo "  Installing $(basename "$app" .rb)..."
        if [ $VERBOSE -eq 1 ]; then
          brew install --cask "$app" && echo "    ✓ Installed $(basename "$app" .rb)" || echo "    ⚠ Error installing $(basename "$app" .rb)"
        else
          brew install --cask "$app" > /dev/null 2>&1 && echo "    ✓ Installed $(basename "$app" .rb)" || echo "    ⚠ Error installing $(basename "$app" .rb)"
        fi
      fi
    fi
  done

  ## Fonts
  # https://github.com/githubnext/monaspace
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would install: font-monaspace"
  else
    if [ $VERBOSE -eq 1 ]; then
      brew install font-monaspace && echo "✓ Installed font-monaspace" || echo "⚠ Error installing font-monaspace"
    else
      brew install font-monaspace > /dev/null 2>&1 && echo "✓ Installed font-monaspace" || echo "⚠ Error installing font-monaspace"
    fi
  fi
else
  echo "Skipping package installation (update mode)"
  echo ""
fi

#############################################################################
# MAIN INSTALLATION ORCHESTRATOR
#############################################################################
main() {
  # Display mode banner
  if [ $UPDATE_MODE -eq 1 ]; then
    echo ""
    echo "============================================================================="
    echo "  UPDATE MODE - Syncing configuration files only"
    echo "============================================================================="
    echo ""
  fi

  # Phase 1: Configuration files (foundation)
  copy_zsh_config
  copy_dotfiles
  copy_xdg_config
  copy_claude_settings

  # Phase 2: Shell environment setup
  # (oh-my-zsh, plugins, taps already executed inline above)

  # Phase 3: Package installation
  # (packages, applications, pinned casks, fonts already executed inline above)

  # Phase 4: Post-installation notes
  echo ""
  echo "============================================================================="
  if [ $UPDATE_MODE -eq 1 ]; then
    echo "  Configuration Update Complete"
    echo "============================================================================="
    echo ""
    echo "Configuration files have been synced from the repository."
    echo ""
    echo "Changed files have been backed up with timestamps."
    echo "Review changes with:"
    echo "  ls -lt ~/*.backup.* ~/.config/*/*.backup.* 2>/dev/null | head -20"
    echo ""
    echo "To view a specific backup diff:"
    echo "  diff <original_file> <backup_file>"
  else
    echo "  Installation Complete"
    echo "============================================================================="
    echo ""
    echo "Manual steps remaining:"
    echo ""
    echo "1. Mac App Store apps (see homebrew/mas-apps.zsh)"
    echo ""
    echo "2. Raycast Extensions: https://www.raycast.com/extensions"
    echo "   - toothpick (Bluetooth connections)"
    echo "   - apple-notes (search/create notes)"
    echo "   - color-picker (pick and organize colors)"
    echo "   - obsidian (control Obsidian)"
    echo "   - kill-process (terminate by CPU/memory)"
    echo "   - raindrop-io (search bookmarks)"
    echo "   - audio-device (switch audio devices)"
    echo "   - coffee (prevent sleep)"
  fi
  echo ""
}

# Run main installation
main
