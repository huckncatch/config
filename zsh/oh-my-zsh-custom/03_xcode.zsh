# Finds a deletes the Build directory in DerivedData
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
alias dbd=delete_build_dir
