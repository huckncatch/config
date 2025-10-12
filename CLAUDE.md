# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Process

### Commit Discipline

- **Commit after each meaningful change**, not just at the end of a multi-step plan.
- Each commit should represent a single logical unit of work that could be understood and potentially reverted independently.
- When working through a multi-step plan, commit after completing each major step (e.g., after restructuring one file, after adding a new function, after fixing a bug).
- Use imperative mood in commit messages (e.g., "Add validation logic" not "Added validation logic").
- Examples of when to commit:
  - When creating new scripts/files: commit the journey incrementally (initial structure, then core logic, then error handling, then tests, etc.)
  - After refactoring a single file or module
  - After adding a new feature or function
  - After fixing a bug
  - After updating documentation to reflect code changes
  - NOT after every single line change, but after each coherent piece of work

### Work Process

- After completing each step in a plan, list the remaining steps and ask the user if they want to continue or make changes to instructions or the plan.
- Before proceeding with file modifications, verify that files haven't moved or changed since last checked.
- After all blocks of work have been completed for a plan (or task), always validate against this CLAUDE.md for any needed updates. For example: directory structure changes during refactors, new patterns that should be documented, or documentation that no longer reflects reality.
- Review all documentation for accuracy - avoid hallucinating or exaggerating information.
- Avoid unnecessary emphasis words like "entire", "completely", "absolutely" when describing issues or constraints. Be direct and factual.
- Periodically check TODO.md for planned work items. When starting a new session or when the user asks "what's next", reference TODO.md to suggest relevant tasks.

## Documentation Standards

- All markdown documentation files must use uppercase filenames with the .md extension.
- Examples: CLAUDE.md, README.md, NOTES.md, TROUBLESHOOTING.md
- This improves visibility and consistency across the repository.
- Subdirectories follow the same convention (e.g., homebrew/README.md, not homebrew/HOMEBREW.md).

## Repository Overview

This is a personal macOS configuration repository containing dotfiles, shell configurations, and automated setup scripts for provisioning new machines. The repository is designed to be cloned to `~/config` and uses a modular structure with profile-based zsh configuration.

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
   - Must define: `ZSH_THEME` and `plugins` array

3. **`zsh/zshrc.base`** (shared configuration)
   - Enables Powerlevel10k instant prompt
   - Sets `ZSH_CUSTOM="$HOME/config/zsh/oh-my-zsh-custom"`
   - Initializes oh-my-zsh
   - Configures fzf, alias-finder plugin
   - Sources `~/.p10k.zsh` (Powerlevel10k theme config)

4. **Custom configs** (loaded automatically by oh-my-zsh from `$ZSH_CUSTOM`)
   - Files in `zsh/oh-my-zsh-custom/*.zsh` are sourced alphabetically
   - Naming convention uses numeric prefixes for load order:
     - `00_environment.zsh` - PATH, colors, environment variables
     - `01_aliases.zsh` - Shell aliases
     - `02_functions.zsh` - Custom shell functions
     - `claude.zsh` - Claude Code configuration
     - `git.zsh` - Git-specific configurations
     - `homebrew.zsh` - Homebrew aliases/functions
     - `node.zsh` - Node.js configuration
     - `xcode.zsh` - Xcode/Swift development

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
- **Claude Code**: `xdg-config/claude/settings.json` → `~/.config/claude/settings.json`
- **Karabiner**: `xdg-config/karabiner/` → `~/.config/karabiner/`
- **ncdu**: `xdg-config/ncdu/` → `~/.config/ncdu/`

Note: Some tools (Powerlevel10k, SSH) don't support XDG paths and remain in home directory as dotfiles.

### Profile Discovery Helper

For users expecting standard zsh conventions, a `.zprofile` file is installed that documents the XDG-compliant location:

- **Source**: `dotfiles/zprofile` → `~/.zprofile` (informational only)
- **Actual config**: `~/.config/zsh/profile.local` (where machine-specific settings live)

### Claude Code Configuration

**For Homebrew installations**, environment variables and settings prevent conflicts with native installer:

- **Environment** (`zsh/oh-my-zsh-custom/claude.zsh`):
  - `DISABLE_AUTOUPDATER=1` - Prevents auto-updates to ~/.local/bin/claude
  - `DISABLE_INSTALLATION_CHECKS=1` - Suppresses false-positive native install warnings

- **Settings** (`xdg-config/claude/settings.json`):

  ```json
  {
    "installMethod": "homebrew",
    "autoUpdates": false,
    "autoUpdatesProtectedForNative": false
  }
  ```

This configuration gets copied to `~/.config/claude/settings.json` during `new-computer-install.sh` setup.

## Installation Script Architecture

The `new-computer-install.sh` script performs automated setup in a specific order:

### Key Installation Functions

- `copy_zsh_config()`: Copies zshrc and creates profile
- `copy_dotfiles()`: Handles dotfiles with SSH config special case (sets permissions 700/600)
- `copy_xdg_config()`: Copies XDG-compliant config directories
- `brew_install()`: Interactive package installation with error handling that continues on failures

### Installation Script Flow

The script performs these operations in order:

1. Initializes Homebrew environment (auto-detects and runs `brew shellenv` if needed)
2. Validates Homebrew installation
3. Copies zsh configuration → `~/.zshrc` (backs up existing)
4. Creates profile (`~/.config/zsh/profile.local`) from home/work template
5. Copies dotfiles → `~/.<filename>` (SSH config gets special permissions)
6. Copies XDG configs → `~/.config/`
7. Installs oh-my-zsh (with `RUNZSH=no KEEP_ZSHRC=yes` to preserve zshrc)
8. Installs zsh plugins to `$ZSH_CUSTOM/plugins/`
9. Installs Homebrew packages (interactive, continues on failures)
10. Installs pinned casks from `homebrew/pinned_casks/*.rb`

### Script Behavior

- Uses `set -euo pipefail` for safety, but `brew install` failures don't stop execution
- Supports `--dry-run` and `--verbose` flags
- Auto-initializes Homebrew environment if needed

## File Editing Guidelines

When editing files in this repository:

1. **Preserve install script logic**: The `new-computer-install.sh` script uses `set -euo pipefail` for safety, but all `brew install` calls must handle errors gracefully with `||` or `&&` to prevent script exit. Never change error handling patterns without understanding the implications.

2. **Maintain zsh load order**: Profile must be sourced before zshrc.base (which initializes oh-my-zsh). Any changes to the loading sequence will break the shell configuration.

3. **Keep XDG structure consistent**: Files in `xdg-config/` should match their expected `~/.config/` structure. The directory hierarchy must be preserved exactly.

4. **Test profile selection**: Ensure both home and work profiles define required variables (`ZSH_THEME`, `plugins`). Missing these will cause oh-my-zsh initialization to fail.

5. **Keep Claude config in sync**: When changing Claude Code configuration files, immediately update both locations:
   - **Global CLAUDE.md**: `~/.config/claude/CLAUDE.md` (active) → `xdg-config/claude/CLAUDE.md` (backup)
   - **Settings**: `~/.config/claude/settings.json` (active) → `xdg-config/claude/settings.json` (backup)

   The `xdg-config/` versions are used when provisioning new machines via `new-computer-install.sh`.

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

**Claude Code configuration exists in two locations and must be kept in sync:**

- Active: `~/.config/claude/`
- Repository: `xdg-config/claude/`

When modifying Claude settings or instructions, both locations must be updated. The repository version is used for new installations, while the active version is used by the running Claude Code instance.

## Understanding the Codebase

### Why Profile-Based Configuration?

The profile system (home vs work) allows different plugin sets and themes on different machines while sharing the base configuration. This is why profile must load before zshrc.base - it defines variables that zshrc.base depends on.

### Why XDG Compliance?

XDG Base Directory specification keeps `$HOME` cleaner by organizing config files in `~/.config/`. This repository adopts XDG where supported, but falls back to traditional dotfiles when tools don't support it (like Powerlevel10k's `.p10k.zsh`).

### Why Pinned Casks?

Some applications (like BBEdit, GraphicConverter) require payment for version upgrades. Pinning allows using a specific version indefinitely. The `homebrew/pinned_casks/*.rb` files are downloaded from Homebrew's formula history and installed directly.

### Why Custom ZSH_CUSTOM Location?

Setting `ZSH_CUSTOM="$HOME/config/zsh/oh-my-zsh-custom"` keeps custom configurations in the git repository instead of `~/.oh-my-zsh/custom/`. This makes the entire configuration portable and version-controlled.

## Common Patterns

### Adding Environment Variables

Add to `zsh/oh-my-zsh-custom/00_environment.zsh` (the `00_` prefix ensures it loads first).

### Adding Aliases or Functions

- Aliases: `zsh/oh-my-zsh-custom/01_aliases.zsh`
- Functions: `zsh/oh-my-zsh-custom/02_functions.zsh`
- Tool-specific: Create/edit appropriate file (e.g., `git.zsh`, `homebrew.zsh`)

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
