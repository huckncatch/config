# Custom Themes

This directory contains oh-my-zsh themes. Themes can be added as git submodules or as local theme files.

## Theme Files

Each theme is either:
- **Submodule**: External theme repository added as a git submodule
- **Local theme**: A `.zsh-theme` file

Custom themes placed here will override built-in oh-my-zsh themes with the same name.

## Adding Themes

**As submodule:**

```bash
git submodule add <theme-repo-url> zsh/oh-my-zsh-custom/themes/<theme-name>
```

**As local theme:**

```bash
# Create <name>.zsh-theme file directly in this directory
```

## Updating Submodules

Update all theme submodules:

```bash
git submodule update --remote
```

## Activation

Themes are activated in profile files (`zsh/profile-*.zsh`) by setting the `ZSH_THEME` variable.
