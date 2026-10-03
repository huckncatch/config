#!/bin/bash
# File copying functions for the install script
# Handles XDG config, chezmoi-managed files, and Oh my tmux!

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
          "tmux")
            # Only the oh-my-tmux submodule is left here (tmux.conf.local is chezmoi-managed);
            # its symlink is handled by install_tmux_config
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

  # Pass 1: everything except secrets.zsh (home/.chezmoiignore leaves it out unless
  # CHEZMOI_INCLUDE_SECRETS is set), showing diffs
  if [ -z "$(chezmoi --source "$SCRIPT_DIR" status)" ]; then
    echo "  ✓ chezmoi-managed files up to date"
  elif [ "$DRY_RUN" -eq 1 ]; then
    chezmoi --source "$SCRIPT_DIR" diff --no-pager
  else
    chezmoi --source "$SCRIPT_DIR" apply --verbose
  fi

  # Pass 2: secrets.zsh, rendered from 1Password. Reading 1Password prompts for Touch ID,
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

# Install Oh my tmux! configuration
install_tmux_config() {
  echo "Setting up Oh my tmux! configuration..."

  # Define paths
  local tmux_source="$HOME/config/xdg-config/tmux/oh-my-tmux/.tmux.conf"
  local tmux_target="$HOME/.config/tmux/tmux.conf"

  # Check if source exists
  if [ ! -f "$tmux_source" ]; then
    echo "  ⚠ Warning: Oh my tmux! not found at $tmux_source"
    echo "  Run: git submodule update --init --recursive"
    return 1
  fi

  # Remove existing file if it's not a symlink
  if [ -f "$tmux_target" ] && [ ! -L "$tmux_target" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  [DRY RUN] Would remove existing $tmux_target (not a symlink)"
    else
      echo "  Removing existing $tmux_target (not a symlink)"
      rm "$tmux_target"
    fi
  fi

  # Create or update symlink
  if [ -L "$tmux_target" ]; then
    # Check if symlink points to correct location
    local current_target
    current_target=$(readlink "$tmux_target")
    if [ "$current_target" = "$tmux_source" ]; then
      echo "  ✓ Symlink already correct: $tmux_target → $tmux_source"
    else
      if [ "$DRY_RUN" -eq 1 ]; then
        echo "  [DRY RUN] Would update symlink: $tmux_target → $tmux_source"
      else
        echo "  Updating symlink: $tmux_target → $tmux_source"
        rm "$tmux_target"
        ln -s "$tmux_source" "$tmux_target"
      fi
    fi
  else
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  [DRY RUN] Would create symlink: $tmux_target → $tmux_source"
    else
      echo "  Creating symlink: $tmux_target → $tmux_source"
      ln -s "$tmux_source" "$tmux_target"
    fi
  fi
}
