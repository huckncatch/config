# ==============================================================================
# XCODE/SWIFT CONFIGURATION
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
#
# Contains Xcode and Swift development-specific functions and aliases
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Swiftly - Swift toolchain version manager
# https://github.com/swiftlang/swiftly
if [[ -f "$HOME/.swiftly/env.sh" ]]; then
  . "$HOME/.swiftly/env.sh"
fi

# Finds and deletes the Build directory in DerivedData
function delete_build_dir() {
  local derived_data_path=$(xcodebuild -scheme Unified_Debug-Staging -showBuildSettings 2>&1 | tee /dev/null | grep -m 1 "BUILT_PRODUCTS_DIR" | sed -E 's/^[^=]+=\s*(.+Products.*)$/\1/' | sed -E 's|(.*Unified-[a-z0-9]+/Build).*|\1|')
  if [ -d "$derived_data_path" ]; then
    rm -rf "$derived_data_path"
    echo "Deleted DerivedData folder: $derived_data_path"
  else
    echo "DerivedData folder not found: $derived_data_path"
  fi
}

autoload delete_build_dir

# Exclude CLAUDECODE to prevent aliases from persisting in snapshots (see 01_aliases.zsh)
if [[ -o interactive && -z "$CLAUDECODE" ]]; then
  alias dbd=delete_build_dir
  alias xcr='sudo xcode-select --switch /Applications/Xcode.app'
  alias xcb='sudo xcode-select --switch /Applications/Xcode-beta.app'
fi
