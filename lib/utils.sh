#!/bin/sh
# Utility functions for the install script
# Provides logging, file sync, and common helper functions

# Show usage information
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

# Sync directory with selective preservation
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
