#!/bin/bash
# Install shell environment: Homebrew taps, oh-my-zsh, and zsh plugins.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=0
VERBOSE=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run) DRY_RUN=1; shift ;;
    -v|--verbose) VERBOSE=1; shift ;;
    -h|--help)
      echo "Usage: $(basename "$0") [-d] [-v]"
      echo ""
      echo "Install shell environment: Homebrew taps, oh-my-zsh, and zsh plugins."
      echo ""
      echo "OPTIONS:"
      echo "  -d, --dry-run   Show what would be installed without installing"
      echo "  -v, --verbose   Show detailed output"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

cd "$SCRIPT_DIR"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/utils.sh"

[ $DRY_RUN -eq 1 ] && echo "=== DRY RUN MODE - No changes will be made ===" && echo ""

## Homebrew taps
brew_taps=(
  "buo/cask-upgrade"       # Used by brew cu command to upgrade casks
  "homebrew/cask-fonts"    # Required for font installations
)

for tap in "${brew_taps[@]}"; do
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would tap: $tap"
  else
    brew tap "$tap" 2>/dev/null || echo "  Already tapped: $tap"
  fi
done

## oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  if [ $DRY_RUN -eq 1 ]; then
    echo "[DRY RUN] Would install oh-my-zsh"
  else
    echo "Installing oh-my-zsh..."
    if [ $VERBOSE -eq 1 ]; then
      RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
      RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>&1 \
        && echo "✓ Installed oh-my-zsh" \
        || echo "Error installing oh-my-zsh"
    fi
  fi
else
  echo "oh-my-zsh already installed, skipping."
fi

## zsh plugins
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-${ZSH:-$HOME/.oh-my-zsh}/custom}"

zsh_plugins=(
  "zsh-completions|https://github.com/zsh-users/zsh-completions"
  "zsh-nvm|https://github.com/lukechilds/zsh-nvm"
  "fast-syntax-highlighting|https://github.com/zdharma-continuum/fast-syntax-highlighting"
)

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
        git clone "$plugin_url" "$plugin_path" > /dev/null 2>&1 \
          && echo "✓ Installed $plugin_name" \
          || echo "Error installing $plugin_name"
      fi
    fi
  else
    echo "$plugin_name already installed, skipping."
  fi
done
