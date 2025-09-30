# macOS Configuration Repository

Personal dotfiles and configuration management for macOS systems.

## Quick Start

```bash
# Clone this repository
git clone --recurse-submodules https://github.com/yourusername/config.git ~/config

# Run the installation script
cd ~/config
./new-computer-install.sh
```

The install script will:
- Verify Homebrew is installed
- Set up zsh configuration with profile selection (home/work)
- Install Homebrew packages and casks
- Copy dotfiles and XDG config files

## Repository Structure

```
config/
├── dotfiles/           # Files copied to ~/ with dot prefix
│   ├── p10k.zsh       # Powerlevel10k theme configuration
│   └── tidyrc         # HTML Tidy configuration
├── xdg-config/        # Directories copied to ~/.config/
│   ├── git/           # Git configuration (XDG-compliant)
│   ├── tmux/          # Tmux configuration (XDG-compliant)
│   ├── claude/        # Claude Code settings
│   ├── karabiner/     # Karabiner-Elements key mappings
│   └── ncdu/          # ncdu disk analyzer settings
├── zsh/               # Zsh configuration
│   ├── zshrc          # Main zshrc entry point
│   ├── zshrc.base     # Shared base configuration
│   ├── profile-home.zsh   # Home profile (theme & plugins)
│   ├── profile-work.zsh   # Work profile (theme & plugins)
│   ├── home/          # Historical backup files
│   ├── work/          # Historical backup files
│   └── oh-my-zsh-custom/  # Custom zsh functions and aliases
├── homebrew/          # Homebrew package management
│   ├── README.md      # Java and brew cu documentation
│   ├── mas-apps.txt   # Mac App Store apps reference
│   └── pinned_casks/  # Pinned cask versions
└── new-computer-install.sh  # Main installation script
```

## Zsh Configuration

The zsh setup uses a modular approach:

1. **~/.zshrc** - Main entry point, sources profile then base
2. **~/.config/zsh/profile.local** - Machine-specific profile (created during install)
3. **zshrc.base** - Common configuration shared across machines
4. **profile-{home,work}.zsh** - Profile templates for different environments

### Debugging Shell Startup

Set `DEBUG_STARTUP=1` in `~/.zshrc` to see which files are being sourced during initialization.

## XDG Base Directory Compliance

Configuration files follow the [XDG Base Directory specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) where supported:

- Git: `~/.config/git/config`
- Tmux: `~/.config/tmux/tmux.conf`
- Zsh profile: `~/.config/zsh/profile.local`

Note: Some tools (like Powerlevel10k) don't support XDG paths and remain in the home directory.

## Additional Documentation

- [Homebrew Notes](./homebrew/README.md) - Java setup, brew cu usage
- [Tips & Tricks](./Notes.md) - Various macOS tips and app configurations

## License

Personal configuration - use at your own risk.
