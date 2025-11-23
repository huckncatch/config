# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Process

### Work Process

- **Before modifying global CLAUDE.md**, verify it matches the repository backup:
  - Run: `diff ~/.config/claude/CLAUDE.md ~/config/xdg-config/claude/CLAUDE.md`
  - If files differ, the active global file was likely modified from another project (e.g., ~/bin)
  - Check modification times: `ls -l ~/.config/claude/CLAUDE.md ~/config/xdg-config/claude/CLAUDE.md`
  - If repository backup is the same age or older, copy active global file to repository: `cp ~/.config/claude/CLAUDE.md ~/config/xdg-config/claude/CLAUDE.md`
  - If repository backup is newer, determine which changes to keep
- Before proceeding with file modifications, verify that files haven't moved or changed since last checked.
- After completing all work for a plan or task, validate against both CLAUDE.md files for needed updates:
  - **Project CLAUDE.md**: Architecture changes, new patterns, updated file structure
  - **Global CLAUDE.md** (`~/.config/claude/CLAUDE.md`): New universal workflows, cross-project preferences discovered
  - Ensure information isn't duplicated or in the wrong location between files
- Periodically check TODO.md for planned work items. When starting a new session or when the user asks "what's next", reference TODO.md to suggest relevant tasks.

## Repository Overview

This is a personal macOS configuration repository containing dotfiles, shell configurations, and automated setup scripts for provisioning new machines. The repository is designed to be cloned to `~/config` and uses a modular structure with profile-based zsh configuration.

### Documentation Files

- **NOTES.md**: Contains installation tips, configuration instructions, and manual setup steps for tools and applications that can't be fully automated. This includes things like Raycast extensions setup, application-specific configurations, Ruby gems, and macOS system tweaks. When users need to document manual setup procedures or reference instructions for tools, add them to NOTES.md.

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

When modifying submodules, be aware they point to specific commits. Use `git submodule update --remote` to update.

### XDG Base Directory Compliance

Configurations follow XDG spec where supported. The `xdg-config/` directory structure mirrors `~/.config/`:

- **Git**: `xdg-config/git/config` → `~/.config/git/config`
- **Tmux**: `xdg-config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`
- **Claude Code**: `xdg-config/claude/CLAUDE.md` → `~/.config/claude/CLAUDE.md`
- **Karabiner**: `xdg-config/karabiner/` → `~/.config/karabiner/`
- **ncdu**: `xdg-config/ncdu/` → `~/.config/ncdu/`

Note: Some tools (Powerlevel10k, SSH) don't support XDG paths and remain in home directory as dotfiles.

Note: Claude Code settings are NOT stored in `~/.config/claude/settings.json`. See "Claude Code Configuration" section below for the correct file locations.

### Profile Discovery Helper

For users expecting standard zsh conventions, a `.zprofile` file is installed that documents the XDG-compliant location:

- **Source**: `dotfiles/zprofile` → `~/.zprofile` (informational only)
- **Actual config**: `~/.config/zsh/profile.local` (where machine-specific settings live)

### Claude Code Configuration

Claude Code uses a hierarchical settings system. Understanding this hierarchy is important for proper configuration.

#### Settings File Hierarchy (Precedence: highest → lowest)

1. **Enterprise policies** (not applicable to personal use)
2. **Command line arguments**
3. **Local project settings**: `<project>/.claude/settings.local.json`
   - Personal permissions for this project (NOT in git)
   - This is what enables tool execution per-project
4. **Shared project settings**: `<project>/.claude/settings.json`
   - Team conventions (CAN be in git)
5. **User settings**: `~/.claude/settings.json`
   - Global env vars and default permissions

#### Runtime State File

`~/.claude.json` stores runtime state and preferences (NOT settings):

- MCP servers configuration
- OAuth account info
- Project data and history
- Installation method (`"installMethod": "homebrew"`)

#### Homebrew Installation Settings

For Homebrew installations, configure:

1. **Shell environment** (`zsh/oh-my-zsh-custom/claude.zsh`):
   - `DISABLE_AUTOUPDATER=1` - Prevents auto-updates to ~/.local/bin/claude
   - `DISABLE_INSTALLATION_CHECKS=1` - Suppresses false-positive native install warnings

2. **Runtime state** (`~/.claude.json`):

   ```json
   {
     "installMethod": "homebrew"
   }
   ```

3. **User settings** (`~/.claude/settings.json`):

   ```json
   {
     "env": {
       "DISABLE_AUTOUPDATER": "1"
     }
   }
   ```

#### Repository Backups

- `xdg-config/claude/CLAUDE.md` → `~/.config/claude/CLAUDE.md` (global instructions)
- `claude/settings.json` → `~/.claude/settings.json` (user settings with permissions/env vars)

Note: `xdg-config/claude/settings.json` is kept for reference only (not actively used since settings go in `~/.claude/settings.json`)

## Installation Script Architecture

The `new-computer-install.sh` script performs automated setup in a specific order:

### Key Installation Functions

- `copy_zsh_config()`: Copies zshrc and creates profile
- `copy_dotfiles()`: Handles dotfiles with SSH config special case (sets permissions 700/600)
- `copy_xdg_config()`: Copies XDG-compliant config directories
- `copy_claude_settings()`: Copies Claude Code user settings to `~/.claude/`
- `brew_install()`: Interactive package installation with error handling that continues on failures

### Installation Script Flow

The script performs these operations in order:

1. Initializes Homebrew environment (auto-detects and runs `brew shellenv` if needed)
2. Validates Homebrew installation
3. Copies zsh configuration → `~/.zshrc` (backs up existing)
4. Creates profile (`~/.config/zsh/profile.local`) from home/work template
5. Copies dotfiles → `~/.<filename>` (SSH config gets special permissions)
6. Copies XDG configs → `~/.config/`
7. Copies Claude Code user settings → `~/.claude/settings.json`
8. Installs oh-my-zsh (with `RUNZSH=no KEEP_ZSHRC=yes` to preserve zshrc)
9. Installs zsh plugins to `$ZSH_CUSTOM/plugins/`
10. Installs Homebrew packages (interactive, continues on failures)
11. Installs pinned casks from `homebrew/pinned_casks/*.rb`

### Script Behavior

- Uses `set -euo pipefail` for safety, but `brew install` failures don't stop execution
- Supports `--dry-run`, `--update`, and `--verbose` flags
- Auto-initializes Homebrew environment if needed

### Update/Refresh Mode

The `--update` flag enables safe configuration syncing after pulling repository updates:

**What it does:**

- Syncs only changed configuration files (creates timestamped backups)
- Skips all installations (Homebrew, oh-my-zsh, plugins, packages)
- Preserves user data and local customizations
- Detects profile drift from templates

**Files synced:**

- `~/.zshrc` - Smart sync with backup if changed
- Dotfiles (`~/.p10k.zsh`, `~/.editorconfig`, etc.) - Smart sync with backup
- XDG configs with selective preservation:
  - **Claude** (`~/.config/claude/`): Syncs `CLAUDE.md`, preserves `local/`, `projects/`, `statsig/`, `todos/`, `hooks/`
  - **Karabiner**: Syncs `karabiner.json`, preserves `automatic_backups/`, `assets/`
  - **Git/tmux/ncdu**: Full sync (no user data to preserve)
- Claude Code user settings (`~/.claude/settings.json`) - Smart sync with backup if changed

**Files preserved/skipped:**

- `~/.config/zsh/profile.local` - Skipped entirely (drift detection runs)
- `~/.ssh/config` - Skipped entirely (manual merge recommended)
- All Homebrew taps, packages, casks, fonts
- oh-my-zsh and zsh plugins

**Usage:**

```bash
cd ~/config && git pull && ./new-computer-install.sh --update
```

**With dry-run preview:**

```bash
./new-computer-install.sh --update --dry-run
```

**With verbose output:**

```bash
./new-computer-install.sh --update --verbose
```

**Backup format:**

Files are backed up with timestamps before updates:

- Format: `<filename>.backup.YYYYMMDD_HHMMSS`
- Example: `.zshrc.backup.20251025_121230`
- All backups are preserved (no automatic cleanup)

## File Editing Guidelines

When editing files in this repository:

1. **Preserve install script logic**: The `new-computer-install.sh` script uses `set -euo pipefail` for safety, but all `brew install` calls must handle errors gracefully with `||` or `&&` to prevent script exit. Never change error handling patterns without understanding the implications.

2. **Maintain zsh load order**: Profile must be sourced before zshrc.base (which initializes oh-my-zsh). Any changes to the loading sequence will break the shell configuration.

3. **Keep XDG structure consistent**: Files in `xdg-config/` should match their expected `~/.config/` structure. The directory hierarchy must be preserved exactly.

4. **Test profile selection**: Ensure both home and work profiles define required variables (`ZSH_THEME`, `plugins`). Missing these will cause oh-my-zsh initialization to fail.

5. **Keep Claude config in sync**: When changing Claude Code configuration files:
   - **Global CLAUDE.md**: `~/.config/claude/CLAUDE.md` (active) → `xdg-config/claude/CLAUDE.md` (backup)

   Note: Settings are stored in `~/.claude.json` (not `~/.config/claude/settings.json`). This file contains runtime state and is not backed up to the repository.

6. **Preserve SSH security**: SSH config must always set directory permissions to 700 and file permissions to 600. This is enforced in `copy_dotfiles()`.

7. **Homebrew package additions**: When adding packages to `new-computer-install.sh`, add them to the appropriate array (`packages` for formulae, `applications` for casks). All installations use `brew_install` which handles errors gracefully.

8. **Numeric prefixes in custom zsh files**: Files in `zsh/oh-my-zsh-custom/` with numeric prefixes (00_, 01_, 02_) control load order. Only use numeric prefixes when load order matters (e.g., environment variables must load before functions that use them).

## Critical Constraints

### Error Handling in Install Script

**Never allow `brew install` commands to cause script exit.** The install script is designed to be resilient and continue even if individual package installations fail. All brew operations must use error handling:

```bash
# Good - continues on failure
brew_install formula "package-name" || true

# Good - continues on failure with logging
brew_install formula "package-name" && echo "Success" || echo "Failed but continuing"

# Bad - will exit script on failure
brew install package-name
```

### Zsh Load Order Dependencies

**Never change the order of sourcing profile vs zshrc.base.** The profile files define `ZSH_THEME` and `plugins` which must be set before oh-my-zsh is initialized in zshrc.base. Changing this order will break the shell configuration.

### Configuration Sync Requirements

**Claude Code CLAUDE.md exists in two locations and must be kept in sync:**

- Active: `~/.config/claude/CLAUDE.md`
- Repository: `xdg-config/claude/CLAUDE.md`

When modifying global instructions, both locations must be updated. The repository version is used for new installations.

Note: Settings files (`~/.claude.json`, `~/.claude/settings.json`, `.claude/settings.local.json`) are NOT backed up to the repository as they contain machine-specific state and permissions.

## Architecture Rationale

Understanding these design decisions prevents breaking changes:

### Why Profile-Based Configuration?

Allows different plugin sets and themes per machine while sharing base configuration. Profile must load before zshrc.base because it defines `ZSH_THEME` and `plugins` that oh-my-zsh initialization depends on.

### Why XDG Compliance (Partial)?

Keeps `$HOME` cleaner by using `~/.config/` where supported. Some tools (Powerlevel10k, SSH) don't support XDG paths and must remain as dotfiles in home directory.

### Why Custom ZSH_CUSTOM Location?

Keeps custom configurations in this git repository (`~/config/zsh/oh-my-zsh-custom`) instead of `~/.oh-my-zsh/custom/`, making the entire configuration portable and version-controlled.

### Why Pinned Casks?

Some applications require payment for version upgrades. Pinning specific versions allows indefinite use. The `homebrew/pinned_casks/*.rb` files are downloaded from Homebrew's formula history.

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

Edit `new-computer-install.sh`:

- Add to `packages=(...)` array for formulae (command-line tools)
- Add to `applications=(...)` array for casks (GUI applications)

Both use the `brew_install` function which prompts before installing and handles errors gracefully.
