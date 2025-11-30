#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

#############################################################################
# GLOBAL VARIABLES
#############################################################################

# Parse command line options
DRY_RUN=0
VERBOSE=0
UPDATE_MODE=0

#############################################################################
# SOURCE LIBRARY FILES
#############################################################################

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source helper libraries
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/brew.sh"
source "$SCRIPT_DIR/lib/copy.sh"

#############################################################################
# ARGUMENT PARSING
#############################################################################

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

#############################################################################
# PREREQUISITES
#############################################################################

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
    eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
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
# PHASE 2: SHELL ENVIRONMENT SETUP
#############################################################################

install_shell_environment() {
  if [ $UPDATE_MODE -eq 1 ]; then
    echo ""
    echo "Skipping shell environment setup (update mode)"
    echo ""
    return 0
  fi

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
}

#############################################################################
# PHASE 3: PACKAGE INSTALLATION
#############################################################################

install_packages() {
  if [ $UPDATE_MODE -eq 1 ]; then
    echo "Skipping package installation (update mode)"
    echo ""
    return 0
  fi

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
}

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
  install_tmux_config

  # Phase 2: Shell environment setup
  install_shell_environment

  # Phase 3: Package installation
  install_packages

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
