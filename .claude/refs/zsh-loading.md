# Zsh Configuration Loading Order

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
   - Initializes Starship prompt (via `zsh/oh-my-zsh-custom/starship.zsh`)

4. **Custom configs** (loaded automatically by oh-my-zsh from `$ZSH_CUSTOM`)
   - Files in `zsh/oh-my-zsh-custom/*.zsh` are sourced alphabetically
   - Naming conventions:
     - Numeric prefixes (00_, 01_, 02_) control load order when needed
     - `00_environment.zsh` - Loads first for PATH and environment variables
     - `01_aliases.zsh` - General shell aliases (not tool-specific)
     - `02_functions.zsh` - General shell functions (not tool-specific)
     - Tool-specific files (e.g., `fzf.zsh`, `git.zsh`, `homebrew.zsh`) contain ALL related configuration for that tool (environment vars, aliases, functions)

## Git Submodules

Oh-my-zsh custom plugins and themes are git submodules in `zsh/oh-my-zsh-custom/`:

- `plugins/zsh-completions`
- `plugins/zsh-nvm`
- `plugins/fast-syntax-highlighting`
- `plugins/zsh-autosuggestions`
- `plugins/zsh-syntax-highlighting`
- `plugins/tmux`

Oh my tmux! configuration framework is a git submodule:

- `xdg-config/tmux/oh-my-tmux` - Pre-configured tmux setup from <https://github.com/gpakosz/.tmux>

When modifying submodules, be aware they point to specific commits. Use `git submodule update --remote` to update.
