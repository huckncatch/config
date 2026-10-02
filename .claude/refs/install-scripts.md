# Installation Script Architecture

The `new-computer-install.sh` script performs automated setup. Functions are organized into library files in the `lib/` directory.

## Library Structure

- **`lib/utils.sh`**: Common helpers (`show_usage`, `_sync_file`, `_files_differ`, `_sync_directory_selective`, `_prompt_install`)
- **`lib/brew.sh`**: Homebrew operations (`_read_package_list`, `brew_install`, `_should_install`, `_brew_list_does_not_contain`)
- **`lib/copy.sh`**: File copy functions (`copy_zsh_config`, `copy_xdg_config`, `apply_chezmoi`, `install_tmux_config`)

## Key Installation Functions

- `copy_zsh_config()`: Copies zshrc and creates profile
- `apply_chezmoi()`: Runs `chezmoi --source "$SCRIPT_DIR" apply` (or `diff` under `--dry-run`) for files under `home/`; skips with a warning if chezmoi is not installed. In `new-computer-install.sh` it runs after package installation so chezmoi is available
- `copy_xdg_config()`: Copies XDG-compliant config directories
- `install_tmux_config()`: Creates Oh my tmux! symlink at `~/.config/tmux/tmux.conf`
- `brew_install()`: Interactive package installation with error handling that continues on failures

## Script Behavior

- Uses `set -euo pipefail` for safety, but `brew install` failures don't stop execution
- Supports `--dry-run` and `--verbose` flags
- Auto-initializes Homebrew environment if needed

## Config Sync (bin/sync-config.sh)

Replaces the old `--update` flag. Syncs changed config files from repo to system with timestamped backups; skips all installations. XDG config preservation rules:

- **Claude** (`~/.config/claude/`): Syncs `CLAUDE.md` and `settings.json`; preserves `projects/`, `todos/`, `hooks/`, `commands/`, `plugins/`, `statsig/`
- **Karabiner**: Syncs `karabiner.json`; preserves `assets/`
- **Tmux**: Preserves `oh-my-tmux/` submodule symlink (`tmux.conf.local` is chezmoi-managed)
- **chezmoi** (`home/`): git, Ghostty, Starship, bat, ncdu, `tmux.conf.local`, dotfiles, `~/.ssh/config` via `apply_chezmoi`

Skips entirely: `~/.config/zsh/profile.local` (drift detection runs).

## Shell Environment (bin/install-shell.sh)

Installs Homebrew taps, oh-my-zsh, and zsh plugins. Can be run independently.

## Package Installation (bin/install-packages.sh)

Installs Homebrew formulae, casks, pinned casks, and fonts interactively. Can be run independently.
