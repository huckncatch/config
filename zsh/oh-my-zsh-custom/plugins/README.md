# Custom Plugins

This directory contains oh-my-zsh plugins. Plugins can be added as git submodules or as local plugin directories.

## Plugin Structure

Each plugin is either:
- **Submodule**: External plugin repository added as a git submodule
- **Local plugin**: Directory containing a `<name>.plugin.zsh` file

Local plugins placed here will override built-in oh-my-zsh plugins with the same name.

## Adding Plugins

**As submodule:**

```bash
git submodule add <plugin-repo-url> zsh/oh-my-zsh-custom/plugins/<plugin-name>
```

**As local plugin:**

```bash
mkdir zsh/oh-my-zsh-custom/plugins/<plugin-name>
# Create <plugin-name>.plugin.zsh with your plugin code
```

## Updating Submodules

Update all plugin submodules:

```bash
git submodule update --remote
```

## Activation

Plugins are activated in profile files (`zsh/profile-*.zsh`) by adding them to the `plugins` array.
