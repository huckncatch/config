# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal macOS configuration repository containing dotfiles, shell configurations, and automated setup scripts for provisioning new machines. The repository is designed to be cloned to `~/config` and uses a modular structure with profile-based zsh configuration.

## Installation & Setup

### Initial Setup on New Machine

```bash
# Clone with submodules (includes oh-my-zsh plugins and themes)
git clone --recurse-submodules https://github.com/yourusername/config.git ~/config
cd ~/config
./new-computer-install.sh
```

The installation script (`new-computer-install.sh`) performs these operations:

1. **Validates Homebrew** is installed (exits if not found)
2. **Copies zsh configuration**: `zsh/zshrc` → `~/.zshrc` (backs up existing)
3. **Creates profile**: Prompts for home/work profile, creates `~/.config/zsh/profile.local`
4. **Copies dotfiles**: Items from `dotfiles/` → `~/.<filename>` (with special handling for SSH config)
5. **Copies XDG configs**: Directories from `xdg-config/` → `~/.config/` (includes git, tmux, claude, karabiner, ncdu)
6. **Installs oh-my-zsh**: Uses `RUNZSH=no KEEP_ZSHRC=yes` flags to preserve zshrc
7. **Installs zsh plugins**: Clones zsh-completions, zsh-nvm, fast-syntax-highlighting to `$ZSH_CUSTOM/plugins/`
8. **Installs Homebrew packages**: Interactive prompts for each formula/cask
9. **Installs pinned casks**: From `homebrew/pinned_casks/*.rb` (specific versions to avoid paid upgrades)

### Key Installation Functions

- `copy_zsh_config()`: Copies zshrc and creates profile (lines 68-99)
- `copy_dotfiles()`: Handles dotfiles with SSH config special case (lines 103-124)
- `copy_xdg_config()`: Copies XDG-compliant config directories (lines 127-142)
- `brew_install()`: Interactive package installation with skip logic (lines 54-66)

## Architecture

### Zsh Configuration Loading Order

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

When cloning, use `--recurse-submodules` flag. To update submodules: `git submodule update --remote`

### XDG Base Directory Compliance

Configurations follow XDG spec where supported. The `xdg-config/` directory structure mirrors `~/.config/`:

- **Git**: `xdg-config/git/config` → `~/.config/git/config`
- **Tmux**: `xdg-config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`
- **Claude Code**: `xdg-config/claude/settings.json` → `~/.config/claude/settings.json`
- **Karabiner**: `xdg-config/karabiner/` → `~/.config/karabiner/`
- **ncdu**: `xdg-config/ncdu/` → `~/.config/ncdu/`

Note: Some tools (Powerlevel10k, SSH) don't support XDG paths and remain in home directory as dotfiles.

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

## Homebrew Management

### Pinned Casks

Some applications are pinned to specific versions to avoid paid upgrade prompts:

- Stored in `homebrew/pinned_casks/*.rb` as cask formula files
- Installed via `brew install --cask ~/config/homebrew/pinned_casks/<NAME>.rb`
- To pin during `brew cu` updates: choose interactive mode and pin, or use `brew cu --pin <NAME>`

### Managing Pinned Casks

Export current pins:

```bash
brew cu pinned --export ~/config/homebrew/homebrew-cu-pinned-casks
```

Import pins:

```bash
brew cu pinned --load ~/config/homebrew/homebrew-cu-pinned-casks
```

### Finding Specific Cask Versions

To install a specific version (e.g., to avoid paid upgrade):

1. Go to <https://formulae.brew.sh/cask/>
2. Search for application → Click "Cask code" → Click "History"
3. Find commit with desired version → Click commit → Three dots → "View file"
4. Right-click "Raw" → "Save Link As..." → Save to `homebrew/pinned_casks/`
5. Install: `brew install --cask ~/config/homebrew/pinned_casks/<NAME>.rb`

## Common Tasks

### Debugging Shell Startup Issues

Set `DEBUG_STARTUP=1` in `~/.zshrc` to see which files are sourced during initialization. Output shows each file path as it's loaded.

### Modifying Zsh Configuration

- **Machine-specific changes**: Edit `~/.config/zsh/profile.local` (not tracked in git)
- **Shared configuration**: Edit `~/config/zsh/zshrc.base` and commit
- **Aliases/functions**: Add to appropriate file in `zsh/oh-my-zsh-custom/`
- **Environment variables**: Edit `zsh/oh-my-zsh-custom/00_environment.zsh`

### Adding New Homebrew Packages

Edit `new-computer-install.sh`:

- Packages: Add to `packages` array (line ~199)
- Applications: Add to `applications` array (line ~269)
- Both use `brew_install` function which prompts before installing

### SSH Configuration

SSH config is handled specially during installation:

- Source: `dotfiles/ssh-config`
- Destination: `~/.ssh/config`
- Permissions: Directory 700, file 600 (automatically set by install script)

## File Editing Guidelines

When editing files in this repository:

1. **Preserve install script logic**: The `new-computer-install.sh` script has careful error handling with `set -euo pipefail`
2. **Maintain zsh load order**: Profile must be sourced before zshrc.base (which initializes oh-my-zsh)
3. **Keep XDG structure consistent**: Files in `xdg-config/` should match their expected `~/.config/` structure
4. **Test profile selection**: Ensure both home and work profiles define required variables (`ZSH_THEME`, `plugins`)
5. **Update both settings files**: When changing Claude config, update both `xdg-config/claude/settings.json` and `~/.config/claude/settings.json`

## Debugging Tips

- **Git credential prompts after Homebrew updates**: Keychain Access may need to trust new git-credential-osxkeychain path. See Notes.md for fix.
- **Zsh completions not working**: Verify `fpath` includes `$ZSH_CUSTOM/plugins/zsh-completions/src`
- **Slow shell startup**: Reduce plugins in profile file, or use `zsh-nvm` lazy loading features
- **PATH issues**: Check `00_environment.zsh` - GNU utilities override macOS defaults via `$(brew --prefix <tool>)/libexec/gnubin`
