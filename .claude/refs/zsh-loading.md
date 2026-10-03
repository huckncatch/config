# Zsh Configuration Loading Order

**Critical: This load order must be maintained for the system to work correctly.**

The zsh setup uses a hierarchical loading system:

1. **`~/.zshrc`** (entry point, sourced by zsh)
   - Defaults `DEBUG_STARTUP` to 0 unless already set in the environment (`DEBUG_STARTUP=1 zsh` traces file loading)
   - Sources `~/.config/zsh/profile.zsh` (warns and falls back to defaults if missing)
   - Sources `~/config/zsh/zshrc.base`

2. **Profile** (defines theme and plugins before oh-my-zsh init)
   - `~/.config/zsh/profile.zsh`, rendered by chezmoi from `home/dot_config/zsh/profile.zsh.tmpl`; never edit the rendered file
   - Template conditionals on `.chezmoi.os`: Homebrew `shellenv` path, macOS-only plugins (`bbedit`, `brew`, `iterm2`)
   - Must define: `ZSH_THEME` and `plugins` array
   - Sources `~/.config/zsh/secrets.zsh` (rendered from 1Password via `home/dot_config/zsh/private_secrets.zsh.tmpl`); warns on stderr if missing

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

## Externals (chezmoi)

Third-party code is fetched by chezmoi from pinned commits in `home/.chezmoiexternal.toml` (no git submodules):

- `plugins/fast-syntax-highlighting`, `plugins/zsh-autosuggestions`, `plugins/zsh-completions`, `plugins/zsh-nvm` - `archive` externals with `exact = true`, downloaded into the repo's `zsh/oh-my-zsh-custom/plugins/` and gitignored by name. `plugins/profiles` and `plugins/tmux` are local plugins tracked in git
- `~/.config/tmux/tmux.conf` - Oh my tmux! as a `file` external (overrides in chezmoi-managed `tmux.conf.local`)

To update, change the commit SHA in the URL and run `chezmoi apply`. `exact = true` deletes untracked files in those directories; runtime files a plugin writes must be listed in `home/.chezmoiignore` (e.g. zsh-nvm's `previous_version`). Because externals live under `~/config`, chezmoi manages `~/config` as a directory: `apply_chezmoi` refuses to run if `~/config` is a symlink.
