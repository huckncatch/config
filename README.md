# macOS Configuration Repository

Personal dotfiles and configuration management for macOS systems.

## Quick Start

```bash
# Clone with submodules (includes oh-my-zsh plugins and themes)
git clone --recurse-submodules https://github.com/yourusername/config.git ~/config

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

```
config/
├── dotfiles/           # Files copied to ~/ with dot prefix
│   ├── p10k.zsh       # Powerlevel10k theme configuration
│   ├── zprofile       # Informational file pointing to XDG config
│   ├── tidyrc         # HTML Tidy configuration
│   └── ssh-config     # SSH configuration (copied to ~/.ssh/config)
├── xdg-config/        # Directories copied to ~/.config/
│   ├── git/           # Git configuration (XDG-compliant)
│   ├── tmux/          # Tmux configuration (XDG-compliant)
│   ├── claude/        # Claude Code settings
│   ├── karabiner/     # Karabiner-Elements key mappings
│   └── ncdu/          # ncdu disk analyzer settings
├── zsh/               # Zsh configuration
│   ├── zshrc          # Main zshrc entry point (copied to ~/.zshrc)
│   ├── zshrc.base     # Shared base configuration
│   ├── profile-home.zsh   # Home profile template
│   ├── profile-work.zsh   # Work profile template
│   └── oh-my-zsh-custom/  # Custom zsh configs and functions
├── homebrew/          # Homebrew package management
│   ├── README.md      # Homebrew documentation
│   └── pinned_casks/  # Pinned cask versions
└── new-computer-install.sh  # Main installation script
```

## Zsh Configuration

The zsh setup uses a profile-based system that allows different configurations on different machines while sharing common settings.

### How It Works

1. **~/.zshrc** - Entry point that sources your profile and base configuration
2. **~/.config/zsh/profile.local** - Your machine-specific profile (created during install, not in git)
3. **zshrc.base** - Common configuration shared across all machines
4. **oh-my-zsh-custom/** - Custom aliases, functions, and tool configurations

### Profiles

During installation, you'll choose a profile (home or work) which determines:
- Which theme to use (Powerlevel10k by default)
- Which oh-my-zsh plugins to load

Profile templates are in `zsh/profile-home.zsh` and `zsh/profile-work.zsh`.

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

## Common Tasks

### Debugging Shell Startup

Set `DEBUG_STARTUP=1` in `~/.zshrc` to see which files are being sourced during initialization.

### Modifying Your Configuration

- **Machine-specific changes**: Edit `~/.config/zsh/profile.local` (not tracked in git)
- **Shared configuration**: Edit `~/config/zsh/zshrc.base` and commit
- **Aliases/functions**: Add to appropriate file in `~/config/zsh/oh-my-zsh-custom/`
- **Environment variables**: Edit `~/config/zsh/oh-my-zsh-custom/00_environment.zsh`

### Adding Homebrew Packages

Edit `new-computer-install.sh`:
- Add formulae (command-line tools) to the `packages` array
- Add casks (GUI applications) to the `applications` array

Run the install script again to install new packages, or install manually:

```bash
brew install <package-name>
brew install --cask <application-name>
```

### Updating Git Submodules

Oh-my-zsh plugins and themes are git submodules. To update them:

```bash
cd ~/config
git submodule update --remote
git add zsh/oh-my-zsh-custom
git commit -m "Update oh-my-zsh plugins and themes"
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
./new-computer-install.sh  # Re-run to copy updated files
```

## XDG Base Directory Compliance

Configuration files follow the [XDG Base Directory specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) where supported, keeping `$HOME` cleaner:

- Git: `~/.config/git/config`
- Tmux: `~/.config/tmux/tmux.conf`
- Zsh profile: `~/.config/zsh/profile.local`
- Claude Code: `~/.config/claude/`

Some tools (like Powerlevel10k) don't support XDG paths and remain in the home directory as dotfiles.

## Troubleshooting

### Zsh Completions Not Working

Verify `fpath` includes the completions plugin:

```bash
echo $fpath | grep zsh-completions
```

If missing, check that the plugin is listed in your profile file (`~/.config/zsh/profile.local`).

### Slow Shell Startup

Reduce plugins in `~/.config/zsh/profile.local`, or enable lazy loading features (e.g., zsh-nvm has lazy loading options).

### PATH Issues

Check `~/config/zsh/oh-my-zsh-custom/00_environment.zsh` - GNU utilities override macOS defaults via `$(brew --prefix <tool>)/libexec/gnubin`.

### Git Credential Prompts After Homebrew Updates

Keychain Access may need to trust the new git-credential-osxkeychain path. See [NOTES.md](./NOTES.md) for the fix.

## Additional Documentation

- [Homebrew Management](./homebrew/README.md) - Java setup, brew cu usage, pinned casks
- [Tips & Tricks](./NOTES.md) - Various macOS tips and app configurations

## License

Personal configuration - use at your own risk.
