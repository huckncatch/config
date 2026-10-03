#!/bin/bash
# File copying functions for the install script
# Handles XDG config and chezmoi-managed files

# Copy XDG config files
copy_xdg_config() {
  echo "Copying XDG config files..."

  # Create ~/.config if it doesn't exist
  if [ ! -d "$HOME/.config" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  [DRY RUN] Would create directory ~/.config"
    else
      mkdir -p "$HOME/.config"
    fi
  fi

  # Read ignored configs from file
  local ignored_configs=()
  local ignored_file="./xdg-config-ignored.txt"
  if [ -f "$ignored_file" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
      # Skip comments and empty lines
      [[ "$line" =~ ^#.*$ ]] && continue
      [[ -z "$line" ]] && continue
      ignored_configs+=("$line")
    done < "$ignored_file"
  fi

  # Copy each directory from xdg-config/ to ~/.config/
  for item in ./xdg-config/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")

      # Check if this config should be ignored
      local should_ignore=0
      if [ ${#ignored_configs[@]} -gt 0 ]; then
        for ignored in "${ignored_configs[@]}"; do
          if [ "$itemname" = "$ignored" ]; then
            echo "  ⊘ Ignoring: $itemname (in ignored list)"
            should_ignore=1
            break
          fi
        done
      fi
      [ "$should_ignore" -eq 1 ] && continue

      if [ "$UPDATE_MODE" -eq 1 ]; then
        # Define preservation patterns per config directory
        case "$itemname" in
          "claude")
            # Live files are authored by Claude (memory, settings) and the repo copy is
            # sanitized, so repo → system would revert newer edits. sync-backups.sh owns
            # this directory in both directions.
            echo "  ⊘ Skipping $itemname (system is source of truth; use bin/sync-backups.sh)"
            ;;
          "karabiner")
            # Preserve assets only (automatic_backups are machine-generated)
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "assets/*"
            ;;
          *)
            # Default: full sync with no preservation
            _sync_directory_selective "$item" "$HOME/.config/$itemname" ""
            ;;
        esac
      else
        # Normal mode: backup and copy entire directory
        if [ -e "$HOME/.config/$itemname" ]; then
          if [ "$DRY_RUN" -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.config/$itemname to ~/.config/$itemname.backup"
          else
            echo "  Backing up existing ~/.config/$itemname to ~/.config/$itemname.backup"
            cp -r "$HOME/.config/$itemname" "$HOME/.config/$itemname.backup"
          fi
        fi
        if [ "$DRY_RUN" -eq 1 ]; then
          echo "  [DRY RUN] Would copy directory $itemname to ~/.config/"
        else
          echo "  Copying directory $itemname to ~/.config/"
          cp -r "$item" "$HOME/.config/"
        fi
      fi
    fi
  done
}

# Apply chezmoi-managed files (source state: home/ in this repo, via .chezmoiroot)
apply_chezmoi() {
  echo "Applying chezmoi-managed files..."

  if ! command -v chezmoi > /dev/null 2>&1; then
    echo "  ⚠ chezmoi not installed; skipping (brew install chezmoi, then re-run bin/sync-config.sh)"
    return 0
  fi

  # Externals live under ~/config/zsh/, so chezmoi manages ~/config itself and would
  # replace a symlinked ~/config with a plain directory
  if [ -L "$HOME/config" ]; then
    echo "  ✗ ~/config is a symlink; chezmoi would replace it with a directory. Skipping."
    echo "      → Clone the repo directly to ~/config"
    return 0
  fi

  # Fresh machine: create ~/.config/chezmoi/chezmoi.toml from home/.chezmoi.toml.tmpl
  if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/chezmoi/chezmoi.toml" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  [DRY RUN] Would run chezmoi init (creates ~/.config/chezmoi/chezmoi.toml)"
    else
      chezmoi init --source "$SCRIPT_DIR" && echo "  ✓ Created ~/.config/chezmoi/chezmoi.toml"
    fi
  fi

  # Pass 1: files, showing diffs. Excludes externals (pass 2) and secrets.zsh
  # (pass 3; home/.chezmoiignore leaves it out unless CHEZMOI_INCLUDE_SECRETS is set)
  if [ -z "$(chezmoi --source "$SCRIPT_DIR" status --exclude=externals)" ]; then
    echo "  ✓ chezmoi-managed files up to date"
  elif [ "$DRY_RUN" -eq 1 ]; then
    chezmoi --source "$SCRIPT_DIR" diff --no-pager --exclude=externals
  else
    chezmoi --source "$SCRIPT_DIR" apply --verbose --exclude=externals
  fi

  # Pass 2: pinned externals (home/.chezmoiexternal.toml), summarized rather than diffed
  local ext_changes
  ext_changes=$(chezmoi --source "$SCRIPT_DIR" status --include=externals | wc -l | tr -d ' ')
  if [ "$ext_changes" -eq 0 ]; then
    echo "  ✓ Externals up to date (zsh plugins, Oh my tmux!)"
  elif [ "$DRY_RUN" -eq 1 ]; then
    echo "  [DRY RUN] Would update externals: $ext_changes path(s) (zsh plugins, Oh my tmux!)"
  else
    chezmoi --source "$SCRIPT_DIR" apply --include=externals \
      && echo "  ✓ Updated externals: $ext_changes path(s) (zsh plugins, Oh my tmux!)" \
      || echo "  ✗ Updating externals failed (see chezmoi error above)"
  fi

  # Pass 3: secrets.zsh, rendered from 1Password. Reading 1Password prompts for Touch ID,
  # so dry-run only checks that op can reach the account
  local template="$SCRIPT_DIR/home/dot_config/zsh/private_secrets.zsh.tmpl"
  if [ "$DRY_RUN" -eq 1 ]; then
    _check_1password "$template" connection \
      && echo "  ✓ 1Password CLI connected (references not checked in dry-run)"
    return 0
  fi

  # On any failed reference, keep the last good secrets.zsh
  if ! _check_1password "$template"; then
    echo "  ⚠ ~/.config/zsh/secrets.zsh left unchanged"
    return 0
  fi

  # Never with a diff, which would print secret values.
  # --force: the file is generated, so overwrite without chezmoi's "changed since" prompt
  CHEZMOI_INCLUDE_SECRETS=1 chezmoi --source "$SCRIPT_DIR" apply --force "$HOME/.config/zsh/secrets.zsh" \
    && echo "  ✓ ~/.config/zsh/secrets.zsh rendered from 1Password (contents not shown)" \
    || echo "  ✗ Rendering ~/.config/zsh/secrets.zsh failed (see chezmoi error above)"
}
