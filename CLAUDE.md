# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Process

### Work Process

- **Check for config drift**: Run `bin/sync-backups.sh` (syncs Claude config, tmux, git, ghostty, starship between `~/.config/` and `xdg-config/`). Run periodically or when switching projects.

## Repository Overview

This is a personal macOS configuration repository containing dotfiles, shell configurations, and automated setup scripts for provisioning new machines. The repository is designed to be cloned to `~/config` and uses a modular structure with profile-based zsh configuration.

### Documentation Files

- **NOTES.md**: Contains installation tips, configuration instructions, and manual setup steps for tools and applications that can't be fully automated. This includes things like Raycast extensions setup, application-specific configurations, Ruby gems, and macOS system tweaks. When users need to document manual setup procedures or reference instructions for tools, add them to NOTES.md.

**Rule**: Human-facing reference material (setup steps, restore commands, tool configuration instructions) belongs in NOTES.md — not in CLAUDE.md files. CLAUDE.md files are instructions for Claude Code; NOTES.md is for the user. When in doubt: if a human would need to read it to do something, it goes in NOTES.md.

## Architecture

### Zsh Configuration Loading Order

Load order is critical — breaking it breaks the shell. Read `.claude/refs/zsh-loading.md` when modifying any zsh config files or submodules.

### XDG Base Directory Compliance

Configurations follow XDG spec where supported. The `xdg-config/` directory structure mirrors `~/.config/`:

- **Git**: `xdg-config/git/config` → `~/.config/git/config`
- **Tmux**: Uses Oh my tmux! with two-file configuration:
  - `xdg-config/tmux/oh-my-tmux/.tmux.conf` (submodule) → `~/.config/tmux/tmux.conf` (symlink)
  - `xdg-config/tmux/tmux.conf.local` → `~/.config/tmux/tmux.conf.local` (user customizations)
- **Claude Code**: `xdg-config/claude/CLAUDE.md` → `~/.config/claude/CLAUDE.md`
- **Ghostty**: `xdg-config/ghostty/config` → `~/.config/ghostty/config`
- **Starship**: `xdg-config/starship.toml` → `~/.config/starship.toml`
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

### Starship Prompt

Starship replaces oh-my-zsh theming. `ZSH_THEME=""` in profile disables oh-my-zsh themes; `zsh/oh-my-zsh-custom/starship.zsh` runs `eval "$(starship init zsh)"` after oh-my-zsh loads. Config at `~/.config/starship.toml` (backed up to `xdg-config/starship.toml`, tracked by `bin/sync-backups.sh`). oh-my-zsh is still used for plugins, completions, and aliases.

### Ghostty Configuration

Ghostty uses `~/.config/ghostty/config` (XDG path) as its config file. Backed up to `xdg-config/ghostty/config` and tracked by `bin/sync-backups.sh`. Config covers font (Monaspace Neon), theme (Carbonfox), window padding, cursor style, shell integration, and scrollback limit.

### Claude Code Configuration

Claude Code uses `~/.config/claude/` as its config directory (set via `CLAUDE_CONFIG_DIR` in `claude.zsh`). Config files are backed up to `xdg-config/claude/` and must be kept in sync via `bin/sync-backups.sh`. Never commit API tokens (`settings.json` backup omits the Fastmail token). MCP servers are stored in `~/.config/claude/.claude.json` — not backed up; see NOTES.md to restore.

## Installation Script Architecture

Functions in `lib/` directory; entry point is `new-computer-install.sh`. Read `.claude/refs/install-scripts.md` when modifying install scripts, lib/ files, or bin/sync-config.sh.

## File Editing Guidelines

When editing files in this repository:

1. **Preserve install script logic**: The `new-computer-install.sh` script uses `set -euo pipefail` for safety, but all `brew install` calls must handle errors gracefully with `||` or `&&` to prevent script exit. Never change error handling patterns without understanding the implications.

2. **Maintain zsh load order**: Profile must be sourced before zshrc.base (which initializes oh-my-zsh). Any changes to the loading sequence will break the shell configuration.

3. **Keep XDG structure consistent**: Files in `xdg-config/` should match their expected `~/.config/` structure. The directory hierarchy must be preserved exactly.

4. **Test profile selection**: Ensure both home and work profiles define required variables (`ZSH_THEME`, `plugins`). Missing these will cause oh-my-zsh initialization to fail.

5. **Keep Claude config in sync**: When changing Claude Code configuration files:
   - **Global CLAUDE.md**: `~/.config/claude/CLAUDE.md` (active) → `xdg-config/claude/CLAUDE.md` (backup)
   - **User settings**: `~/.config/claude/settings.json` (active) → `xdg-config/claude/settings.json` (sanitized backup — omit Fastmail token)
   - **Desktop app settings**: `~/Library/Application Support/Claude/claude_desktop_config.json` (active) → `xdg-config/claude/claude_desktop_config.json` (sanitized backup — omit `KAGI_API_KEY`)
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
