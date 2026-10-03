# Custom Plugins

This directory contains oh-my-zsh plugins: third-party plugins fetched by chezmoi, and local plugins tracked in git.

## Plugin Structure

Each plugin is either:

- **External**: Third-party plugin downloaded by `chezmoi apply` from a pinned commit (see `home/.chezmoiexternal.toml`). Gitignored by name in `/.gitignore`; never edit files in these directories, since chezmoi removes changes on the next apply
- **Local plugin**: Directory containing a `<name>.plugin.zsh` file, tracked in git (e.g. `profiles/`, `tmux/`)

Local plugins placed here will override built-in oh-my-zsh plugins with the same name.

## Adding Plugins

**As external** (third-party):

1. Add an entry to `home/.chezmoiexternal.toml`, pinned to a commit:

   ```toml
   ["config/zsh/oh-my-zsh-custom/plugins/<plugin-name>"]
   type = "archive"
   url = "https://github.com/<owner>/<repo>/archive/<commit-sha>.tar.gz"
   stripComponents = 1
   exact = true
   ```

2. Add `zsh/oh-my-zsh-custom/plugins/<plugin-name>/` to `/.gitignore`
3. Run `chezmoi apply`

**As local plugin:**

```bash
mkdir zsh/oh-my-zsh-custom/plugins/<plugin-name>
# Create <plugin-name>.plugin.zsh with your plugin code
```

## Updating Externals

Replace the commit SHA in the plugin's URL in `home/.chezmoiexternal.toml`, then run `chezmoi apply`.

## Activation

Plugins are activated in `home/dot_config/zsh/profile.zsh.tmpl` by adding them to the `plugins` array, then running `chezmoi apply`.
