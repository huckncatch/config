#!/bin/bash
# Utility functions for the install script
# Provides logging, file sync, and common helper functions

# Show usage information
show_usage() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Provision a new macOS machine with dotfiles, configurations, and applications.

OPTIONS:
  -d, --dry-run    Show what would be installed without actually installing
  -v, --verbose    Show detailed output during installation
  -h, --help       Show this help message

EXAMPLES:
  $(basename "$0")              # Run normal installation
  $(basename "$0") --dry-run    # Preview what would be installed
  $(basename "$0") -d -v        # Preview with verbose output

EOF
}

# Prompt user for yes/no response
_prompt_install() {
  local response
  read -r -p "$1 (y/n): " response
  if [[ $response == [Yy] || $response == "yes" ]]; then
      echo "yes"
    else
      echo "no"
    fi
}

# Check if two files differ
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

# Sync a single file with backup
_sync_file() {
  local src="$1"
  local dest="$2"
  local mode="${3:-}"  # Optional: file permissions

  if ! _files_differ "$src" "$dest"; then
    [ "$VERBOSE" -eq 1 ] && echo "  ✓ $dest unchanged" || true
    return 0
  fi

  local action="Updated"
  [ -e "$dest" ] || action="Created"

  if [ "$DRY_RUN" -eq 1 ]; then
    if [ "$action" = "Created" ]; then
      echo "  [DRY RUN] Would create: $dest"
    else
      echo "  [DRY RUN] Would update: $dest"
    fi
    return 0
  fi

  # Backup existing file with timestamp
  if [ -f "$dest" ]; then
    local backup
    backup="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$dest" "$backup"
    echo "  ⚠ Backed up: $backup"
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"

  # Copy file
  cp "$src" "$dest"

  # Set permissions if specified
  [ -n "$mode" ] && chmod "$mode" "$dest"

  echo "  ✓ $action: $dest"
}

# Sync directory with selective preservation
_sync_directory_selective() {
  local src_dir="$1"
  local dest_dir="$2"
  local preserve_patterns="$3"  # Patterns to preserve (space-separated)

  # Per-file lines name full paths; the header only adds context in verbose mode
  if [ "$VERBOSE" -eq 1 ]; then
    if [ -n "$preserve_patterns" ]; then
      echo "  Syncing $dest_dir (preserving: $preserve_patterns)"
    else
      echo "  Syncing $dest_dir"
    fi
  fi

  # Find all files in source directory
  find "$src_dir" -type f | while read -r src_file; do
    # Get relative path
    rel_path="${src_file#"$src_dir"/}"
    dest_file="$dest_dir/$rel_path"

    # Check if file matches preserve pattern
    local should_preserve=0
    for pattern in $preserve_patterns; do
      # shellcheck disable=SC2254  # intentional glob matching in case pattern
      case "$rel_path" in
        $pattern)
          should_preserve=1
          [ "$VERBOSE" -eq 1 ] && echo "  ⊘ Preserving: $rel_path" || true
          break
          ;;
      esac
    done

    # Skip if should preserve
    [ "$should_preserve" -eq 1 ] && continue

    # Sync the file
    _sync_file "$src_file" "$dest_file"
  done
}

# Check that 1Password can resolve every op:// reference in a chezmoi template.
# Prints what failed and how to fix it; never prints secret values.
# Returns 0 only if every reference resolves. With "connection" as the second
# argument, stops after checking op can see an account (no Touch ID prompt).
_check_1password() {
  local template="$1"
  local mode="${2:-}"
  local ref err failed=0

  if ! command -v op > /dev/null 2>&1; then
    echo "  ✗ 1Password CLI (op) not installed"
    echo "      → macOS: brew install --cask 1password-cli  (Linux: see NOTES.md → chezmoi)"
    return 1
  fi

  if [ -z "$(op account list 2> /dev/null)" ]; then
    echo "  ✗ op cannot see any 1Password account"
    echo "      → Is the 1Password app running and unlocked?"
    echo "      → 1Password → Settings → Developer → \"Integrate with 1Password CLI\" enabled?"
    return 1
  fi

  [ "$mode" = "connection" ] && return 0

  while IFS= read -r ref; do
    if ! err=$(op read "$ref" 2>&1 > /dev/null); then
      echo "  ✗ $ref"
      echo "      op: $err"
      failed=1
    fi
  done < <(command grep -o 'op://[^"]*' "$template")

  if [ "$failed" -eq 1 ]; then
    echo "      → Fix the item/field in 1Password, or the reference in ${template#"$SCRIPT_DIR"/}"
    echo "        (1Password: right-click field → Copy Secret Reference)"
    return 1
  fi

  echo "  ✓ 1Password: all secret references resolve"
}
