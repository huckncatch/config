# macOS Configuration Repository

Personal dotfiles and configuration management for macOS systems.

## Quick Start

```bash
# Clone (third-party plugins are fetched by chezmoi during installation)
git clone https://github.com/yourusername/config.git ~/config

# Run the installation script
cd ~/config
./new-computer-install.sh
```

The install script will:

- Verify Homebrew is installed and initialize it if needed
- Set up zsh configuration with profile selection (home/work)
- Copy dotfiles and XDG config files
- Install oh-my-zsh with custom plugins
- Install Homebrew packages and casks (with interactive prompts)

### Installation Options

- `--dry-run` - Preview what would be installed without making changes
- `--verbose` - See full Homebrew output during installation

## Repository Structure

```text
config/
├── home/              # chezmoi source state for ~ (selected by .chezmoiroot)
│   ├── .chezmoiexternal.toml  # pinned third-party: zsh plugins, Oh my tmux!
│   ├── dot_config/    # ~/.config: git, ghostty, starship, bat, ncdu, tmux.conf.local, zsh profile + secrets
│   ├── dot_zshrc      # ~/.zshrc entry point
│   ├── dot_zprofile   # Informational file pointing to XDG config
│   ├── dot_tidyrc     # HTML Tidy configuration
│   ├── dot_editorconfig
│   └── private_dot_ssh/  # ~/.ssh/config (mode 700/600)
├── xdg-config/        # Directories copied to ~/.config/
│   ├── claude/        # Claude Code settings
│   └── karabiner/     # Karabiner-Elements key mappings
├── zsh/               # Zsh configuration
│   ├── zshrc.base     # Shared base configuration (sourced by ~/.zshrc)
│   └── oh-my-zsh-custom/  # Custom zsh configs and functions
├── homebrew/          # Homebrew package management
│   ├── README.md      # Homebrew documentation
│   └── pinned_casks/  # Pinned cask versions
└── new-computer-install.sh  # Main installation script
```

## Zsh Configuration

The zsh setup loads a chezmoi-generated profile (with macOS/Linux differences) before shared base configuration.

### How It Works

1. **~/.zshrc** - Entry point that sources your profile and base configuration
2. **~/.config/zsh/profile.zsh** - Theme, plugins, and environment, rendered by chezmoi from `home/dot_config/zsh/profile.zsh.tmpl`
   - Sources **~/.config/zsh/secrets.zsh** (API tokens rendered from 1Password; see NOTES.md)
3. **zshrc.base** - Common configuration shared across all machines
4. **oh-my-zsh-custom/** - Custom aliases, functions, and tool configurations

### Profile

One profile template, `home/dot_config/zsh/profile.zsh.tmpl`, applies to every machine. chezmoi template conditionals handle macOS vs Linux (Homebrew path, macOS-only plugins). Edit the template, then run `chezmoi apply`.

### Custom Configurations

Custom zsh files in `oh-my-zsh-custom/` are loaded automatically:

- `00_environment.zsh` - PATH, colors, environment variables
- `01_aliases.zsh` - Shell aliases
- `02_functions.zsh` - Custom shell functions
- `claude.zsh` - Claude Code configuration
- `git.zsh` - Git-specific configurations
- `homebrew.zsh` - Homebrew aliases/functions
- `node.zsh` - Node.js configuration
- `xcode.zsh` - Xcode/Swift development

Files with numeric prefixes (00_, 01_, etc.) control load order.

## Day-to-day Scripts

All scripts support `-d` (dry-run) and `-v` (verbose).

| Script | Purpose |
| --- | --- |
| `bin/sync-config.sh` | Sync repo → system after `git pull` (safe, timestamped backups) |
| `bin/sync-backups.sh` | Sync system → repo (keeps tracked files up to date) |
| `bin/install-shell.sh` | Install Homebrew taps, oh-my-zsh, and zsh plugins |
| `bin/install-packages.sh` | Install Homebrew formulae, casks, and fonts |

## Common Tasks

### Debugging Shell Startup

Run `ezd` (or `DEBUG_STARTUP=1 zsh`) to see which files are being sourced during initialization. To trace every new shell, add `export DEBUG_STARTUP=1` to `~/.zshenv`.

### Modifying Your Configuration

- **Theme, plugins, environment**: Edit `home/dot_config/zsh/profile.zsh.tmpl`, then `chezmoi apply`
- **Shared configuration**: Edit `~/config/zsh/zshrc.base` and commit
- **Aliases/functions**: Add to appropriate file in `~/config/zsh/oh-my-zsh-custom/`
- **Environment variables**: Edit `~/config/zsh/oh-my-zsh-custom/00_environment.zsh`

### Installing Additional Packages

Install packages manually:

```bash
brew install <package-name>
brew install --cask <application-name>
```

To add packages to the install script for future machines, see [Homebrew Management](./homebrew/README.md).

### Updating Third-Party Plugins

Oh-my-zsh plugins and Oh my tmux! are chezmoi externals pinned to commits in `home/.chezmoiexternal.toml`. To update one, replace the commit SHA in its URL, then:

```bash
chezmoi apply
git -C ~/config commit -am "chore: update <plugin> to <sha>"
```

### Syncing Changes Across Machines

After making changes to your configuration:

```bash
cd ~/config
git add .
git commit -m "Update configuration"
git push
```

On other machines:

```bash
cd ~/config
git pull
bin/sync-config.sh  # Syncs config files with timestamped backups
```

## XDG Base Directory Compliance

Configuration files follow the [XDG Base Directory specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) where supported, keeping `$HOME` cleaner:

- Git: `~/.config/git/config`
- Tmux: `~/.config/tmux/tmux.conf`
- Zsh profile: `~/.config/zsh/profile.zsh`
- Claude Code: `~/.config/claude/`

Some tools (like Powerlevel10k) don't support XDG paths and remain in the home directory as dotfiles.

## Troubleshooting

### Zsh Completions Not Working

Verify `fpath` includes the completions plugin:

```bash
echo $fpath | grep zsh-completions
```

If missing, check that the plugin is listed in your profile file (`home/dot_config/zsh/profile.zsh.tmpl`).

### Slow Shell Startup

Reduce plugins in `home/dot_config/zsh/profile.zsh.tmpl`, or enable lazy loading features (e.g., zsh-nvm has lazy loading options).

### PATH Issues

Check `~/config/zsh/oh-my-zsh-custom/00_environment.zsh` - GNU utilities override macOS defaults via `$(brew --prefix <tool>)/libexec/gnubin`.

### Git Credential Prompts After Homebrew Updates

Keychain Access may need to trust the new git-credential-osxkeychain path. See [NOTES.md](./NOTES.md) for the fix.

## Additional Documentation

- [Homebrew Management](./homebrew/README.md) - Java setup, brew cu usage, pinned casks
- [Tips & Tricks](./NOTES.md) - Various macOS tips and app configurations

## License

Personal configuration - use at your own risk.
