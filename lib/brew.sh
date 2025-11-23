#!/bin/sh
# Homebrew-related functions for the install script
# Handles package installation, taps, and brew list operations

# Read package list from file
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

# Check if package is not in brew list
_brew_list_does_not_contain() {
  local brew_list_output
  brew_list_output=$(brew list 2>/dev/null)
  if [[ $brew_list_output != *"$@"* ]]; then
    return 0
  else
    return 1
  fi
}

# Check if package should be installed (not installed + user confirms)
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

# Install a package with error handling
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
