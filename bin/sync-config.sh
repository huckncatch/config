#!/bin/bash
# Sync configuration files from repository to system.
# Run after git pull to apply updated dotfiles and configs.
# Creates timestamped backups before overwriting any changed file.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
export DRY_RUN=0
export VERBOSE=0
export UPDATE_MODE=1  # Always update/sync mode — smart diff, no blind overwrite

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run) export DRY_RUN=1; shift ;;
    -v|--verbose) export VERBOSE=1; shift ;;
    -h|--help)
      echo "Usage: $(basename "$0") [-d] [-v]"
      echo ""
      echo "Sync configuration files from repository to system."
      echo "Creates timestamped backups for any changed files."
      echo ""
      echo "OPTIONS:"
      echo "  -d, --dry-run   Show what would change without applying"
      echo "  -v, --verbose   Show unchanged files too"
      echo ""
      echo "EXAMPLE:"
      echo "  cd ~/config && git pull && bin/sync-config.sh"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

cd "$SCRIPT_DIR"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/utils.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/copy.sh"

[ "$DRY_RUN" -eq 1 ] && echo "=== DRY RUN MODE - No changes will be made ===" && echo ""

echo "============================================================================="
echo "  Syncing configuration files"
echo "============================================================================="
echo ""

copy_zsh_config
copy_dotfiles
copy_xdg_config
install_tmux_config

echo ""
echo "============================================================================="
echo "  Sync complete"
echo "============================================================================="
echo ""
echo "Changed files backed up with timestamps."
echo "Review: ls -lt ~/*.backup.* ~/.config/*/*.backup.* 2>/dev/null | head -20"
echo ""
