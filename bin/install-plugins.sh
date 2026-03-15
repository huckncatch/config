#!/bin/bash
# Install Claude Code plugins listed in xdg-config/claude/settings.json.
# Reads enabledPlugins and installs each one. Safe to run on existing installs.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -d|--dry-run) DRY_RUN=1; shift ;;
    -h|--help)
      echo "Usage: $(basename "$0") [-d]"
      echo ""
      echo "  -d, --dry-run  Show what would be installed without installing"
      exit 0
      ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

SETTINGS="$SCRIPT_DIR/xdg-config/claude/settings.json"

if [ ! -f "$SETTINGS" ]; then
  echo "Error: settings.json not found at $SETTINGS"
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed"
  exit 1
fi

if ! command -v claude &> /dev/null; then
  echo "Error: claude is not installed or not in PATH"
  exit 1
fi

echo "Installing Claude Code plugins..."
echo ""

plugins=$(jq -r '.enabledPlugins | to_entries[] | select(.value == true) | .key' "$SETTINGS")

if [ -z "$plugins" ]; then
  echo "No plugins found in settings.json"
  exit 0
fi

installed=0
failed=0

while IFS= read -r plugin; do
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [DRY RUN] Would install: $plugin"
  else
    echo "  Installing $plugin..."
    if claude plugin install "$plugin" 2>/dev/null; then
      echo "  ✓ $plugin"
      installed=$((installed + 1))
    else
      echo "  ⚠ Failed: $plugin"
      failed=$((failed + 1))
    fi
  fi
done <<< "$plugins"

echo ""
if [ "$DRY_RUN" -eq 0 ]; then
  echo "Done. Installed: $installed, Failed: $failed"
fi
