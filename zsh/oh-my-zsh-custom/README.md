# Oh-My-Zsh Custom Configuration

This directory contains custom zsh configurations that extend oh-my-zsh.

## How It Works

The `ZSH_CUSTOM` environment variable points to this directory (`$HOME/config/zsh/oh-my-zsh-custom`), causing oh-my-zsh to automatically source all `.zsh` files found here.

Files are:
- Loaded automatically by oh-my-zsh in alphabetical order
- Loaded after all built-ins, allowing them to override default behavior
- Tracked in git (unlike the default `~/.oh-my-zsh/custom/`)

## File Naming Convention

Files with numeric prefixes control load order:
- `00_environment.zsh` - Loads first (PATH, environment variables)
- `01_aliases.zsh` - Loads second (shell aliases)
- `02_functions.zsh` - Loads third (shell functions)
- Other `.zsh` files - Load alphabetically

Use numeric prefixes only when load order matters (e.g., environment variables must be set before functions that use them).

## Directory Structure

- `plugins/` - Custom plugins (mix of submodules and local files)
- `themes/` - Custom themes (mix of submodules and local files)
- `profiles/` - Profile templates for different machine types
