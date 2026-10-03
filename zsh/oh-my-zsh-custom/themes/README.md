# Custom Themes

This directory contains oh-my-zsh themes as local theme files. Third-party themes can be fetched by chezmoi as externals.

## Theme Files

Each theme is either:

- **External**: Third-party theme downloaded by `chezmoi apply` from a pinned commit (see `home/.chezmoiexternal.toml`)
- **Local theme**: A `.zsh-theme` file

Custom themes placed here will override built-in oh-my-zsh themes with the same name.

## Adding Themes

**As external:** add a pinned `archive` entry targeting `config/zsh/oh-my-zsh-custom/themes/<theme-name>` to `home/.chezmoiexternal.toml` (same format as the plugin entries), gitignore that directory, then run `chezmoi apply`.

**As local theme:**

```bash
# Create <name>.zsh-theme file directly in this directory
```

## Updating Externals

Replace the commit SHA in the theme's URL in `home/.chezmoiexternal.toml`, then run `chezmoi apply`.

## Activation

Themes are activated in `home/dot_config/zsh/profile.zsh.tmpl` by setting the `ZSH_THEME` variable, then running `chezmoi apply`. (Currently `ZSH_THEME=""`: Starship draws the prompt.)
