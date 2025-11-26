#!/bin/bash
# Sync backup files between system locations and repository

set -euo pipefail

# File pairs: system_path:repo_path
FILE_PAIRS=(
  "$HOME/.claude/settings.json:claude/settings.json"
  "$HOME/.claude.json:claude/claude.json"
  "$HOME/.config/claude/CLAUDE.md:xdg-config/claude/CLAUDE.md"
)

# Get script directory and change to repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT" || exit 1

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

synced_count=0
skipped_count=0

echo "Checking backup files for drift..."
echo ""

for pair in "${FILE_PAIRS[@]}"; do
  IFS=':' read -r system_file repo_file <<< "$pair"

  # Check if system file exists
  if [[ ! -f "$system_file" ]]; then
    echo -e "${YELLOW}⚠ System file not found: $system_file${NC}"
    echo "  (skipping)"
    echo ""
    skipped_count=$((skipped_count + 1))
    continue
  fi

  # Check if repo file exists
  if [[ ! -f "$repo_file" ]]; then
    echo -e "${YELLOW}⚠ Repo file not found: $repo_file${NC}"
    echo "  System file exists at: $system_file"
    echo ""
    skipped_count=$((skipped_count + 1))
    continue
  fi

  # Check if files differ
  if diff -q "$system_file" "$repo_file" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} $repo_file (in sync)"
    continue
  fi

  # Files differ - show details
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${RED}✗${NC} Files differ: $repo_file"
  echo ""

  # Show modification times and sizes
  system_mtime=$(ls -l "$system_file" | awk '{print $6, $7, $8}')
  repo_mtime=$(ls -l "$repo_file" | awk '{print $6, $7, $8}')
  system_size=$(wc -c < "$system_file" | tr -d ' ')
  repo_size=$(wc -c < "$repo_file" | tr -d ' ')

  echo "  System: $system_file"
  echo "    Modified: $system_mtime"
  echo "    Size: $system_size bytes"
  echo ""
  echo "  Repo:   $repo_file"
  echo "    Modified: $repo_mtime"
  echo "    Size: $repo_size bytes"
  echo ""

  # Prompt for action
  while true; do
    echo "Options:"
    echo "  [s] Sync from system to repo (copy system → repo)"
    echo "  [r] Sync from repo to system (copy repo → system)"
    echo "  [d] Show full diff"
    echo "  [k] Skip this file"
    echo ""
    read -r -p "Choice: " choice

    case "$choice" in
      s|S)
        cp "$system_file" "$repo_file"
        echo -e "${GREEN}✓ Copied system → repo${NC}"
        synced_count=$((synced_count + 1))
        break
        ;;
      r|R)
        cp "$repo_file" "$system_file"
        echo -e "${GREEN}✓ Copied repo → system${NC}"
        synced_count=$((synced_count + 1))
        break
        ;;
      d|D)
        echo ""
        diff -u "$repo_file" "$system_file" || true
        echo ""
        ;;
      k|K)
        echo "Skipped."
        skipped_count=$((skipped_count + 1))
        break
        ;;
      *)
        echo "Invalid choice. Please enter s, r, d, or k."
        ;;
    esac
  done

  echo ""
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "Summary:"
echo "  Synced: $synced_count"
echo "  Skipped: $skipped_count"
echo ""
