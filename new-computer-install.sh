#!/bin/bash
# Provision a new macOS machine with dotfiles, configurations, and applications.
# For config sync only (after git pull), use: bin/sync-config.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export DRY_RUN=0
export VERBOSE=0
export UPDATE_MODE=0  # Fresh install: backup and overwrite

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run) export DRY_RUN=1; shift ;;
    -v|--verbose) export VERBOSE=1; shift ;;
    -h|--help)
      echo "Usage: $(basename "$0") [-d] [-v]"
      echo ""
      echo "Provision a new macOS machine: copies configs, installs shell and packages."
      echo "To sync configs on an existing machine, use: bin/sync-config.sh"
      echo ""
      echo "OPTIONS:"
      echo "  -d, --dry-run   Show what would be installed without actually installing"
      echo "  -v, --verbose   Show detailed output during installation"
      echo ""
      echo "EXAMPLES:"
      echo "  $(basename "$0")           # Full installation"
      echo "  $(basename "$0") --dry-run # Preview what would be installed"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

# Build flags array to forward to sub-scripts
FLAGS=()
[ "$DRY_RUN" -eq 1 ] && FLAGS+=("--dry-run")
[ "$VERBOSE" -eq 1 ] && FLAGS+=("--verbose")

#############################################################################
# PREREQUISITES
#############################################################################

# Initialize Homebrew environment if not already in PATH
if ! command -v brew &> /dev/null; then
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
    exit 1
  fi
fi

if [ ! -f "$SCRIPT_DIR/new-computer-install.sh" ]; then
  echo "Error: This script must be run from the config repository directory."
  exit 1
fi

cd "$SCRIPT_DIR"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/utils.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/copy.sh"

[ "$DRY_RUN" -eq 1 ] && echo "=== DRY RUN MODE - No changes will be made ===" && echo ""

#############################################################################
# PHASE 1: CONFIGURATION FILES
#############################################################################

copy_zsh_config
copy_dotfiles
copy_xdg_config
install_tmux_config

#############################################################################
# PHASE 2: SHELL ENVIRONMENT
#############################################################################

"$SCRIPT_DIR/bin/install-shell.sh" "${FLAGS[@]+"${FLAGS[@]}"}"

#############################################################################
# PHASE 3: PACKAGES
#############################################################################

"$SCRIPT_DIR/bin/install-packages.sh" "${FLAGS[@]+"${FLAGS[@]}"}"

#############################################################################
# PHASE 4: CLAUDE PLUGINS
#############################################################################

"$SCRIPT_DIR/bin/install-plugins.sh" "${FLAGS[@]+"${FLAGS[@]}"}"

#############################################################################
# PHASE 5: POST-INSTALL NOTES
#############################################################################

echo ""
echo "============================================================================="
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
echo ""
