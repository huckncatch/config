# OpenWolf

@.wolf/OPENWOLF.md

This project uses OpenWolf for context management. Read and follow .wolf/OPENWOLF.md every session. Check .wolf/cerebrum.md before generating code. Check .wolf/anatomy.md before reading files.


# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Process

### Work Process

- **Check for config drift**: Run `bin/sync-backups.sh` to sync backup files between system and repository:
  - Checks `~/.config/claude/CLAUDE.md` ↔ `xdg-config/claude/CLAUDE.md`
  - Checks `~/.config/claude/settings.json` ↔ `xdg-config/claude/settings.json` (sanitized - Fastmail token omitted)
  - Checks `~/.config/claude/statusline.sh` ↔ `xdg-config/claude/statusline.sh`
  - Checks `~/.config/claude/statusline-my-jonathan.sh` ↔ `xdg-config/claude/statusline-my-jonathan.sh`
  - Checks `~/.config/claude/commands/` ↔ `xdg-config/claude/commands/` (directory)
  - Checks `~/.config/tmux/tmux.conf.local` ↔ `xdg-config/tmux/tmux.conf.local`
  - Checks `~/.config/git/config` ↔ `xdg-config/git/config`
  - Checks `~/.config/git/gitignore_global` ↔ `xdg-config/git/gitignore_global`
  - Interactively prompts to sync, skip, or view diffs
  - Run periodically or when switching between projects

## Repository Overview

This is a personal macOS configuration repository containing dotfiles, shell configurations, and automated setup scripts for provisioning new machines. The repository is designed to be cloned to `~/config` and uses a modular structure with profile-based zsh configuration.

### Documentation Files

- **NOTES.md**: Contains installation tips, configuration instructions, and manual setup steps for tools and applications that can't be fully automated. This includes things like Raycast extensions setup, application-specific configurations, Ruby gems, and macOS system tweaks. When users need to document manual setup procedures or reference instructions for tools, add them to NOTES.md.

**Rule**: Human-facing reference material (setup steps, restore commands, tool configuration instructions) belongs in NOTES.md — not in CLAUDE.md files. CLAUDE.md files are instructions for Claude Code; NOTES.md is for the user. When in doubt: if a human would need to read it to do something, it goes in NOTES.md.

## Architecture

### Zsh Configuration Loading Order

**Critical: This load order must be maintained for the system to work correctly.**

The zsh setup uses a hierarchical loading system:

1. **`~/.zshrc`** (entry point, sourced by zsh)
   - Sets `DEBUG_STARTUP=0` (set to 1 to trace file loading)
   - Sources profile-specific config (`~/.config/zsh/profile.local` or falls back to `~/config/zsh/profile-home.zsh`)
   - Sources `~/config/zsh/zshrc.base`

2. **Profile files** (define theme and plugins before oh-my-zsh init)
   - `~/.config/zsh/profile.local` - Machine-specific, created during install, **not tracked in git**
   - `zsh/profile-home.zsh` - Template for personal machines
   - `zsh/profile-work.zsh` - Template for work machines
   - `zsh/profile-base.zsh` - Shared settings sourced by all profile templates
   - Must define: `ZSH_THEME` and `plugins` array
   - Profile templates source `profile-base.zsh` for shared config (e.g., tmux plugin settings)

3. **`zsh/zshrc.base`** (shared configuration)
   - Enables Powerlevel10k instant prompt
   - Sets `ZSH_CUSTOM="$HOME/config/zsh/oh-my-zsh-custom"`
   - Initializes oh-my-zsh
   - Configures fzf, alias-finder plugin
   - Sources `~/.p10k.zsh` (Powerlevel10k theme config)

4. **Custom configs** (loaded automatically by oh-my-zsh from `$ZSH_CUSTOM`)
   - Files in `zsh/oh-my-zsh-custom/*.zsh` are sourced alphabetically
   - Naming conventions:
     - Numeric prefixes (00_, 01_, 02_) control load order when needed
     - `00_environment.zsh` - Loads first for PATH and environment variables
     - `01_aliases.zsh` - General shell aliases (not tool-specific)
     - `02_functions.zsh` - General shell functions (not tool-specific)
     - Tool-specific files (e.g., `fzf.zsh`, `git.zsh`, `homebrew.zsh`) contain ALL related configuration for that tool (environment vars, aliases, functions)

### Git Submodules

Oh-my-zsh custom plugins and themes are git submodules in `zsh/oh-my-zsh-custom/`:

- `plugins/zsh-completions`
- `plugins/zsh-nvm`
- `plugins/fast-syntax-highlighting`
- `plugins/zsh-autosuggestions`
- `plugins/zsh-syntax-highlighting`
- `plugins/tmux`
- `themes/powerlevel10k`

Oh my tmux! configuration framework is a git submodule:

- `xdg-config/tmux/oh-my-tmux` - Pre-configured tmux setup from <https://github.com/gpakosz/.tmux>

When modifying submodules, be aware they point to specific commits. Use `git submodule update --remote` to update.

### XDG Base Directory Compliance

Configurations follow XDG spec where supported. The `xdg-config/` directory structure mirrors `~/.config/`:

- **Git**: `xdg-config/git/config` → `~/.config/git/config`
- **Tmux**: Uses Oh my tmux! with two-file configuration:
  - `xdg-config/tmux/oh-my-tmux/.tmux.conf` (submodule) → `~/.config/tmux/tmux.conf` (symlink)
  - `xdg-config/tmux/tmux.conf.local` → `~/.config/tmux/tmux.conf.local` (user customizations)
- **Claude Code**: `xdg-config/claude/CLAUDE.md` → `~/.config/claude/CLAUDE.md`
- **Karabiner**: `xdg-config/karabiner/` → `~/.config/karabiner/`
- **ncdu**: `xdg-config/ncdu/` → `~/.config/ncdu/`

Note: Some tools (Powerlevel10k, SSH) don't support XDG paths and remain in home directory as dotfiles.

Note: Claude Code config directory is set to `~/.config/claude/` via `CLAUDE_CONFIG_DIR` (exported from `zsh/oh-my-zsh-custom/claude.zsh`). This is required for global `CLAUDE.md` instructions to be loaded.

### Tmux Configuration

Tmux uses **Oh my tmux!** (<https://github.com/gpakosz/.tmux>), a pre-configured tmux framework with a two-file configuration system:

**Main Configuration** (read-only, from submodule):

- **Submodule**: `xdg-config/tmux/oh-my-tmux/.tmux.conf`
- **System**: `~/.config/tmux/tmux.conf` (symlink to submodule)
- Never modify this file directly; it receives updates from the upstream project

**User Customizations**:

- **Repository**: `xdg-config/tmux/tmux.conf.local`
- **System**: `~/.config/tmux/tmux.conf.local`
- All personal settings and overrides go here (vi mode, mouse settings, key bindings, etc.)

**Installation**:
The `install_tmux_config()` function creates the symlink during installation. To update Oh my tmux!:

```bash
git submodule update --remote xdg-config/tmux/oh-my-tmux
```

**Backup Tracking**:
Only `tmux.conf.local` is tracked by `bin/sync-backups.sh`. The main config symlink is regenerated on install.

### Claude Code Configuration

Claude Code uses `~/.config/claude/` as its config directory (set via `CLAUDE_CONFIG_DIR` in `claude.zsh`). Config files are backed up to `xdg-config/claude/` and must be kept in sync via `bin/sync-backups.sh`. Never commit API tokens (`settings.json` backup omits the Fastmail token). MCP servers are stored in `~/.config/claude/.claude.json` — not backed up; see NOTES.md to restore.

## Installation Script Architecture

The `new-computer-install.sh` script performs automated setup in a specific order. Functions are organized into library files in the `lib/` directory:

### Library Structure

- **`lib/utils.sh`**: Common helpers (`show_usage`, `_sync_file`, `_files_differ`, `_sync_directory_selective`, `_prompt_install`)
- **`lib/brew.sh`**: Homebrew operations (`_read_package_list`, `brew_install`, `_should_install`, `_brew_list_does_not_contain`)
- **`lib/copy.sh`**: File copy functions (`copy_zsh_config`, `copy_dotfiles`, `copy_xdg_config`, `install_tmux_config`)

### Key Installation Functions

- `copy_zsh_config()`: Copies zshrc and creates profile
- `copy_dotfiles()`: Handles dotfiles with SSH config special case (sets permissions 700/600)
- `copy_xdg_config()`: Copies XDG-compliant config directories
- `install_tmux_config()`: Creates Oh my tmux! symlink at `~/.config/tmux/tmux.conf`
- `brew_install()`: Interactive package installation with error handling that continues on failures

### Installation Script Flow

The script performs these operations in order:

1. Initializes Homebrew environment (auto-detects and runs `brew shellenv` if needed)
2. Validates Homebrew installation
3. Copies zsh configuration → `~/.zshrc` (backs up existing)
4. Creates profile (`~/.config/zsh/profile.local`) from home/work template
5. Copies dotfiles → `~/.<filename>` (SSH config gets special permissions)
6. Copies XDG configs → `~/.config/`
7. Creates Oh my tmux! symlink at `~/.config/tmux/tmux.conf`
8. Installs oh-my-zsh (with `RUNZSH=no KEEP_ZSHRC=yes` to preserve zshrc)
9. Installs zsh plugins to `$ZSH_CUSTOM/plugins/`
10. Installs Homebrew packages (interactive, continues on failures)
11. Installs pinned casks from `homebrew/pinned_casks/*.rb`

### Script Behavior

- Uses `set -euo pipefail` for safety, but `brew install` failures don't stop execution
- Supports `--dry-run` and `--verbose` flags
- Auto-initializes Homebrew environment if needed

### Config Sync (bin/sync-config.sh)

Replaces the old `--update` flag. Syncs changed config files from repo to system with timestamped backups; skips all installations. XDG config preservation rules:

- **Claude** (`~/.config/claude/`): Syncs `CLAUDE.md` and `settings.json`; preserves `projects/`, `todos/`, `hooks/`, `commands/`, `plugins/`, `statsig/`
- **Karabiner**: Syncs `karabiner.json`; preserves `assets/`
- **Tmux**: Syncs `tmux.conf.local`; preserves `oh-my-tmux/` submodule symlink
- **Git/ncdu**: Full sync

Skips entirely: `~/.config/zsh/profile.local` (drift detection runs), `~/.ssh/config`.

### Shell Environment (bin/install-shell.sh)

Installs Homebrew taps, oh-my-zsh, and zsh plugins. Can be run independently.

### Package Installation (bin/install-packages.sh)

Installs Homebrew formulae, casks, pinned casks, and fonts interactively. Can be run independently.

## File Editing Guidelines

When editing files in this repository:

1. **Preserve install script logic**: The `new-computer-install.sh` script uses `set -euo pipefail` for safety, but all `brew install` calls must handle errors gracefully with `||` or `&&` to prevent script exit. Never change error handling patterns without understanding the implications.

2. **Maintain zsh load order**: Profile must be sourced before zshrc.base (which initializes oh-my-zsh). Any changes to the loading sequence will break the shell configuration.

3. **Keep XDG structure consistent**: Files in `xdg-config/` should match their expected `~/.config/` structure. The directory hierarchy must be preserved exactly.

4. **Test profile selection**: Ensure both home and work profiles define required variables (`ZSH_THEME`, `plugins`). Missing these will cause oh-my-zsh initialization to fail.

5. **Keep Claude config in sync**: When changing Claude Code configuration files:
   - **Global CLAUDE.md**: `~/.config/claude/CLAUDE.md` (active) → `xdg-config/claude/CLAUDE.md` (backup)
   - **User settings**: `~/.config/claude/settings.json` (active) → `xdg-config/claude/settings.json` (sanitized backup — omit Fastmail token)
   - **Statusline scripts**: `~/.config/claude/statusline*.sh` → `xdg-config/claude/statusline*.sh`
   - **Custom commands**: `~/.config/claude/commands/` → `xdg-config/claude/commands/`

   Use `bin/sync-backups.sh` to sync. Never commit API tokens. Note: `~/.claude.json` is not backed up (OAuth tokens + ephemeral caches; re-authenticate after re-imaging).

6. **Preserve SSH security**: SSH config must always set directory permissions to 700 and file permissions to 600. This is enforced in `copy_dotfiles()`.

7. **Homebrew package additions**: When adding packages to `new-computer-install.sh`, add them to the appropriate array (`packages` for formulae, `applications` for casks). All installations use `brew_install` which handles errors gracefully.

8. **Numeric prefixes in custom zsh files**: Files in `zsh/oh-my-zsh-custom/` with numeric prefixes (00_, 01_, 02_) control load order. Only use numeric prefixes when load order matters (e.g., environment variables must load before functions that use them).

9. **Run shellcheck on shell scripts**: After modifying `new-computer-install.sh` or any `.zsh` files, run `shellcheck <file>` to catch common issues. The install script should pass shellcheck with minimal exceptions.

## Common Patterns

### Adding Environment Variables

Add to `zsh/oh-my-zsh-custom/00_environment.zsh` (the `00_` prefix ensures it loads first).

### Adding Aliases or Functions

- General aliases: `zsh/oh-my-zsh-custom/01_aliases.zsh`
- General functions: `zsh/oh-my-zsh-custom/02_functions.zsh`
- **Tool-specific: All aliases and functions for a tool must be kept together in that tool's file** (e.g., all fzf aliases/functions in `fzf.zsh`, all git aliases/functions in `git.zsh`, all homebrew aliases/functions in `homebrew.zsh`). Never split tool-related configuration across multiple files.

### Modifying Installation Script

When adding new installation steps:

1. Add the function if needed
2. Call it in the main flow (after the "Installation flow" comment)
3. Ensure proper error handling (don't break the script on failures)
4. Test with `--dry-run` flag first

### Adding Homebrew Packages

- Add formulae (command-line tools) to `homebrew/formulae.zsh`
- Add casks (GUI applications) to `homebrew/casks.zsh`

`bin/install-packages.sh` reads both files via `_read_package_list` and prompts before installing each.
