#!/bin/sh
# File copying functions for the install script
# Handles zsh config, dotfiles, XDG config, and Claude settings

# Copy zsh configuration files
copy_zsh_config() {
  echo "Setting up zsh configuration..."

  # In update mode, just sync the zshrc file
  if [ $UPDATE_MODE -eq 1 ]; then
    _sync_file "./zsh/zshrc" "$HOME/.zshrc"
    echo "  ⊘ Skipping profile (update mode preserves local profile)"

    # Profile drift detection
    if [ -f "$HOME/.config/zsh/profile.local" ]; then
      local drift_found=0
      if diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-home.zsh" > /dev/null 2>&1; then
        echo "  ✓ Profile matches home template"
      elif diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-work.zsh" > /dev/null 2>&1; then
        echo "  ✓ Profile matches work template"
      else
        echo "  ⚠ Profile drift detected: ~/.config/zsh/profile.local differs from both templates"
        drift_found=1
      fi
    fi

    return 0
  fi

  # Copy main zshrc to home directory
  if [ -f "$HOME/.zshrc" ]; then
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would back up existing ~/.zshrc to ~/.zshrc.backup"
    else
      echo "  Backing up existing ~/.zshrc to ~/.zshrc.backup"
      cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi
  fi

  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would copy zshrc to ~/.zshrc"
  else
    cp "./zsh/zshrc" "$HOME/.zshrc" || { echo "Error: Failed to copy zshrc"; exit 1; }
    echo "  Copied zshrc to ~/.zshrc"
  fi

  # Create ~/.config/zsh directory if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.config/zsh"
  else
    mkdir -p "$HOME/.config/zsh"
  fi

  # Prompt for profile selection and create profile.local
  local profile_source
  if [ -f "$HOME/.config/zsh/profile.local" ]; then
    echo "  Profile already exists at ~/.config/zsh/profile.local, skipping."

    # Profile drift detection (also run in normal mode)
    if diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-home.zsh" > /dev/null 2>&1; then
      echo "  ✓ Profile matches home template"
    elif diff -q "$HOME/.config/zsh/profile.local" "./zsh/profile-work.zsh" > /dev/null 2>&1; then
      echo "  ✓ Profile matches work template"
    else
      echo "  ⚠ Profile drift detected: ~/.config/zsh/profile.local differs from both templates"
    fi
  else
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would prompt for profile selection and create ~/.config/zsh/profile.local"
    else
      personal=$(_prompt_install "Personal/Home config?")
      if [[ "$personal" == "yes" ]]; then
        echo "  Creating home profile..."
        profile_source="./zsh/profile-home.zsh"
      else
        echo "  Creating work profile..."
        profile_source="./zsh/profile-work.zsh"
      fi

      cp "$profile_source" "$HOME/.config/zsh/profile.local" || { echo "Error: Failed to copy profile"; exit 1; }
      echo "  Created ~/.config/zsh/profile.local"
    fi
  fi
}

# Copy dotfiles to home directory
copy_dotfiles() {
  echo "Copying dotfiles..."

  for item in ./dotfiles/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")

      # Special handling for SSH config
      if [ "$itemname" = "ssh-config" ]; then
        if [ $UPDATE_MODE -eq 1 ]; then
          echo "  ⊘ Skipping SSH config in update mode (manual merge recommended)"
          continue
        fi

        if [ -f "$HOME/.ssh/config" ]; then
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.ssh/config to ~/.ssh/config.backup"
          else
            echo "  Backing up existing ~/.ssh/config to ~/.ssh/config.backup"
            cp "$HOME/.ssh/config" "$HOME/.ssh/config.backup"
          fi
        fi
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy SSH config to ~/.ssh/config"
        else
          echo "  Copying SSH config to ~/.ssh/config"
          mkdir -p "$HOME/.ssh"
          chmod 700 "$HOME/.ssh"
          cp "$item" "$HOME/.ssh/config"
          chmod 600 "$HOME/.ssh/config"
        fi
      else
        # Use smart sync in update mode
        if [ $UPDATE_MODE -eq 1 ]; then
          _sync_file "$item" "$HOME/.$itemname"
        else
          if [ -f "$HOME/.$itemname" ]; then
            if [ $DRY_RUN -eq 1 ]; then
              echo "  [DRY RUN] Would back up existing ~/.$itemname to ~/.$itemname.backup"
            else
              echo "  Backing up existing ~/.$itemname to ~/.$itemname.backup"
              cp "$HOME/.$itemname" "$HOME/.$itemname.backup"
            fi
          fi
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would copy $itemname to ~/.$itemname"
          else
            echo "  Copying $itemname to ~/.$itemname"
            cp "$item" "$HOME/.$itemname"
          fi
        fi
      fi
    fi
  done
}

# Copy XDG config files
copy_xdg_config() {
  echo "Copying XDG config files..."

  # Create ~/.config if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.config"
  else
    mkdir -p "$HOME/.config"
  fi

  # Track unknown configs for final summary
  local unknown_configs=()

  # Copy each directory from xdg-config/ to ~/.config/
  for item in ./xdg-config/*; do
    if [ -e "$item" ]; then
      itemname=$(basename "$item")

      if [ $UPDATE_MODE -eq 1 ]; then
        # Define preservation patterns per config directory
        case "$itemname" in
          "claude")
            # Preserve everything except CLAUDE.md and settings.json
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "local/* projects/* statsig/* todos/* hooks/*"
            ;;
          "karabiner")
            # Preserve automatic backups and assets
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "automatic_backups/* assets/*"
            ;;
          "git"|"tmux"|"ncdu")
            # These are safe to fully sync
            _sync_directory_selective "$item" "$HOME/.config/$itemname" ""
            ;;
          *)
            echo "  ⚠ Unknown config: $itemname (skipping in update mode)"
            unknown_configs+=("$itemname")
            ;;
        esac
      else
        # Normal mode: backup and copy entire directory
        if [ -e "$HOME/.config/$itemname" ]; then
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would back up existing ~/.config/$itemname to ~/.config/$itemname.backup"
          else
            echo "  Backing up existing ~/.config/$itemname to ~/.config/$itemname.backup"
            cp -r "$HOME/.config/$itemname" "$HOME/.config/$itemname.backup"
          fi
        fi
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy directory $itemname to ~/.config/"
        else
          echo "  Copying directory $itemname to ~/.config/"
          cp -r "$item" "$HOME/.config/"
        fi
      fi
    fi
  done

  # Display unknown configs summary if any
  if [ ${#unknown_configs[@]} -gt 0 ] && [ $UPDATE_MODE -eq 1 ]; then
    echo ""
    echo "  Unknown configs skipped in update mode:"
    for config in "${unknown_configs[@]}"; do
      echo "    - $config"
    done
    echo "  To update these, run without --update flag or add them to copy_xdg_config()"
  fi
}

# Copy Claude Code user settings to ~/.claude/
# This is separate from XDG config because ~/.claude/ doesn't follow XDG spec
copy_claude_settings() {
  echo "Copying Claude Code user settings..."

  # Create ~/.claude if it doesn't exist
  if [ $DRY_RUN -eq 1 ]; then
    echo "  [DRY RUN] Would create directory ~/.claude"
  else
    mkdir -p "$HOME/.claude"
  fi

  # Copy settings.json from claude/ to ~/.claude/
  local source_file="./claude/settings.json"
  local target_file="$HOME/.claude/settings.json"

  if [ -f "$source_file" ]; then
    if [ $UPDATE_MODE -eq 1 ]; then
      # In update mode, use smart sync
      if [ -f "$target_file" ]; then
        if ! diff -q "$source_file" "$target_file" > /dev/null 2>&1; then
          local backup_name="settings.json.backup.$(date +%Y%m%d_%H%M%S)"
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would backup $target_file to $HOME/.claude/$backup_name"
            echo "  [DRY RUN] Would update $target_file"
          else
            echo "  Backing up $target_file to $HOME/.claude/$backup_name"
            cp "$target_file" "$HOME/.claude/$backup_name"
            echo "  Updating $target_file"
            cp "$source_file" "$target_file"
          fi
        else
          [ $VERBOSE -eq 1 ] && echo "  $target_file unchanged, skipping" || true
        fi
      else
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy settings.json to ~/.claude/"
        else
          echo "  Copying settings.json to ~/.claude/"
          cp "$source_file" "$target_file"
        fi
      fi
    else
      # Normal mode: backup and copy
      if [ -f "$target_file" ]; then
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would back up existing $target_file"
        else
          echo "  Backing up existing $target_file"
          cp "$target_file" "$target_file.backup"
        fi
      fi
      if [ $DRY_RUN -eq 1 ]; then
        echo "  [DRY RUN] Would copy settings.json to ~/.claude/"
      else
        echo "  Copying settings.json to ~/.claude/"
        cp "$source_file" "$target_file"
      fi
    fi
  else
    echo "  ⚠ Warning: $source_file not found, skipping"
  fi
}
