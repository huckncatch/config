# Homebrew Management

## Package Management

### Adding Packages to Install Script

To add packages that will be installed on new machines, edit `new-computer-install.sh`:

- Add to `packages` array for command-line tools (formulae)
- Add to `applications` array for GUI applications (casks)

The script provides interactive prompts for each package and continues even if individual installations fail.

## Java

Using [these instructions](https://johnathangilday.com/blog/macos-homebrew-openjdk/) to manage Java using Homebrew.

### For Minecraft

Use [these instructions](https://minecrafthopper.net/help/installing-java/) for Minecraft-specific Java setup.

## Pinned Casks

Some applications are pinned to specific versions to avoid paid upgrade prompts (e.g., BBEdit, GraphicConverter, A Better Finder Rename).

### How Pinned Casks Work

Pinned casks are stored as formula files in `homebrew/pinned_casks/*.rb` and installed directly:

```bash
brew install --cask ~/config/homebrew/pinned_casks/<NAME>.rb
```

The install script handles these automatically during setup.

### Finding and Pinning a Specific Version

To install a specific version of a cask (e.g., to avoid paid upgrade):

1. Go to <https://formulae.brew.sh/cask/>
2. Search for the application
3. Click "Cask code" → Click "History"
4. Find the commit with the desired version by reading commit messages
5. Click the commit → Three dots → "View file"
6. Right-click "Raw" → "Save Link As..."
7. Save to `~/config/homebrew/pinned_casks/<NAME>.rb`
8. Install: `brew install --cask ~/config/homebrew/pinned_casks/<NAME>.rb`

### Managing Pins with brew cu

The `brew cu` command (from brew-cask-upgrade) can manage pinned casks:

**Pin during interactive update:**

```bash
brew cu  # Choose interactive mode when prompted, then pin specific casks
```

**Pin via command line:**

```bash
brew cu --pin <CASK_NAME>
```

**Export current pins:**

```bash
brew cu pinned --export ~/config/homebrew/homebrew-cu-pinned-casks
```

**Import pins:**

```bash
brew cu pinned --load ~/config/homebrew/homebrew-cu-pinned-casks
```

### Disabling Casks

To temporarily disable a pinned cask (so it won't be installed by the install script), rename it with a `-disabled` suffix:

```bash
cd ~/config/homebrew/pinned_casks
mv example.rb example.rb-disabled
```

The install script skips files without the `.rb` extension.

## Upgrading Packages

**Formulae (command-line tools):**

```bash
brew upgrade
```

**Casks (GUI applications):**

```bash
brew cu  # Respects pinned casks
```

Or upgrade all casks (ignoring pins):

```bash
brew upgrade --cask
```
