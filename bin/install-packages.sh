#!/bin/bash
# Install Homebrew packages: formulae, casks, pinned casks, and fonts.
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
      echo "Install Homebrew packages: formulae, casks, pinned casks, and fonts."
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
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/brew.sh"

[ $DRY_RUN -eq 1 ] && echo "=== DRY RUN MODE - No changes will be made ===" && echo ""

## Homebrew formulae
echo "Check formulae..."
packages=()
for package in $(_read_package_list "./homebrew/formulae.zsh"); do
  packages+=("$package")
done

packages_to_install=()
for formula in "${packages[@]}"; do
  if _should_install "$formula"; then
    packages_to_install+=("$formula")
  fi
done

if [ ${#packages_to_install[@]} -gt 0 ]; then
  echo ""
  echo "Installing ${#packages_to_install[@]} selected packages..."
  for formula in "${packages_to_install[@]}"; do
    brew_install "$formula"
  done
else
  echo "No packages selected for installation."
fi

## Homebrew casks
echo ""
echo "Check apps..."
applications=()
for app in $(_read_package_list "./homebrew/casks.zsh"); do
  applications+=("$app")
done

apps_to_install=()
for cask in "${applications[@]}"; do
  if _should_install "$cask"; then
    apps_to_install+=("$cask")
  fi
done

if [ ${#apps_to_install[@]} -gt 0 ]; then
  echo ""
  echo "Installing ${#apps_to_install[@]} selected applications..."
  for cask in "${apps_to_install[@]}"; do
    brew_install "$cask"
  done
else
  echo "No applications selected for installation."
fi

## Pinned casks (specific versions to avoid paid upgrades)
echo "Installing pinned cask versions..."
for app in ./homebrew/pinned_casks/*.rb; do
  if [ -e "$app" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would install $(basename "$app" .rb)"
    else
      echo "  Installing $(basename "$app" .rb)..."
      if [ $VERBOSE -eq 1 ]; then
        brew install --cask "$app" \
          && echo "    ✓ Installed $(basename "$app" .rb)" \
          || echo "    ⚠ Error installing $(basename "$app" .rb)"
      else
        brew install --cask "$app" > /dev/null 2>&1 \
          && echo "    ✓ Installed $(basename "$app" .rb)" \
          || echo "    ⚠ Error installing $(basename "$app" .rb)"
      fi
    fi
  fi
done

## Fonts
if [ $DRY_RUN -eq 1 ]; then
  echo "[DRY RUN] Would install: font-monaspace"
else
  if [ $VERBOSE -eq 1 ]; then
    brew install font-monaspace \
      && echo "✓ Installed font-monaspace" \
      || echo "⚠ Error installing font-monaspace"
  else
    brew install font-monaspace > /dev/null 2>&1 \
      && echo "✓ Installed font-monaspace" \
      || echo "⚠ Error installing font-monaspace"
  fi
fi
