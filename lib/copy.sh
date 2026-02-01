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
      [ $should_ignore -eq 1 ] && continue

      if [ $UPDATE_MODE -eq 1 ]; then
        # Define preservation patterns per config directory
        case "$itemname" in
          "claude")
            # Preserve everything except CLAUDE.md and settings.json
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "local/* projects/* statsig/* todos/* hooks/*"
            ;;
          "karabiner")
            # Preserve assets only (automatic_backups are machine-generated)
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "assets/*"
            ;;
          "tmux")
            # Preserve oh-my-tmux submodule (symlink is managed by install_tmux_config)
            _sync_directory_selective "$item" "$HOME/.config/$itemname" \
              "oh-my-tmux/*"
            ;;
          *)
            # Default: full sync with no preservation
            _sync_directory_selective "$item" "$HOME/.config/$itemname" ""
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
}

# Copy Claude Code configuration to ~/.claude.json
# This includes MCP servers, install method, and user preferences
copy_claude_settings() {
  echo "Copying Claude Code configuration..."

  # Copy .claude.json from claude/ to ~/
  local source_file="./claude/claude.json"
  local target_file="$HOME/.claude.json"

  if [ -f "$source_file" ]; then
    if [ $UPDATE_MODE -eq 1 ]; then
      # In update mode, use smart sync
      if [ -f "$target_file" ]; then
        if ! diff -q "$source_file" "$target_file" > /dev/null 2>&1; then
          local backup_name=".claude.json.backup.$(date +%Y%m%d_%H%M%S)"
          if [ $DRY_RUN -eq 1 ]; then
            echo "  [DRY RUN] Would backup $target_file to $HOME/$backup_name"
            echo "  [DRY RUN] Would update $target_file"
          else
            echo "  Backing up $target_file to $HOME/$backup_name"
            cp "$target_file" "$HOME/$backup_name"
            echo "  Updating $target_file"
            cp "$source_file" "$target_file"
          fi
        else
          [ $VERBOSE -eq 1 ] && echo "  $target_file unchanged, skipping" || true
        fi
      else
        if [ $DRY_RUN -eq 1 ]; then
          echo "  [DRY RUN] Would copy claude.json to ~/.claude.json"
        else
          echo "  Copying claude.json to ~/.claude.json"
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
        echo "  [DRY RUN] Would copy claude.json to ~/.claude.json"
      else
        echo "  Copying claude.json to ~/.claude.json"
        cp "$source_file" "$target_file"
      fi
    fi
  else
    echo "  ⚠ Warning: $source_file not found, skipping"
  fi
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
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would remove existing $tmux_target (not a symlink)"
    else
      echo "  Removing existing $tmux_target (not a symlink)"
      rm "$tmux_target"
    fi
  fi

  # Create or update symlink
  if [ -L "$tmux_target" ]; then
    # Check if symlink points to correct location
    local current_target=$(readlink "$tmux_target")
    if [ "$current_target" = "$tmux_source" ]; then
      echo "  ✓ Symlink already correct: $tmux_target → $tmux_source"
    else
      if [ $DRY_RUN -eq 1 ]; then
        echo "  [DRY RUN] Would update symlink: $tmux_target → $tmux_source"
      else
        echo "  Updating symlink: $tmux_target → $tmux_source"
        rm "$tmux_target"
        ln -s "$tmux_source" "$tmux_target"
      fi
    fi
  else
    if [ $DRY_RUN -eq 1 ]; then
      echo "  [DRY RUN] Would create symlink: $tmux_target → $tmux_source"
    else
      echo "  Creating symlink: $tmux_target → $tmux_source"
      ln -s "$tmux_source" "$tmux_target"
    fi
  fi
}
