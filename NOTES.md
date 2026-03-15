# Tips, Tricks, and Settings

## Clean up disk space

```shell
npx mac-cleaner-cli
```

## Raycast

Add `.../Dropbox/ApplicationSupport/Raycast/CommandScripts` as watch directory for Raycast Script Commands (Extension)

### Toothpick

Toothpick is a Raycast extension that allows you to control Bluetooth devices from the command line. It requires the `blueutil` command-line tool to be installed. Follow the "Enabling 'blueutil' backend" instructions in the [README](https://www.raycast.com/VladCuciureanu/toothpick#readme) file.

## Maestral

keep-alive instructions: <https://daringfireball.net/2023/07/nerding_out_with_maestral_launchcontrol_and_keyboard_maestro>

## BBEdit

Before launching, create a symlink to `~/Dropbox/Apps/BBEdit` in `~/Library/Application Support`

    ln -s ~/Dropbox/Apps/BBEdit .

## Python / pip

Python is managed via Homebrew. The OMZ `python` plugin provides useful aliases.

### Setup

1. Install Python via Homebrew:

   ```bash
   brew install python@3.13
   brew link python@3.13
   ```

2. The `python` plugin is enabled in the profile templates (profile-home.zsh, profile-work.zsh)

3. `brew shellenv` in profile-base.zsh adds `/opt/homebrew/bin` to PATH

### Usage

```bash
# Python commands (Homebrew provides python3/pip3, not python/pip)
python3 --version
pip3 install <package>
python3 -m pip install <package>

# OMZ python plugin aliases
py              # runs python3
pyfind          # find .py files recursively
pyclean         # delete __pycache__ and .pyc files
pygrep <text>   # grep in *.py files
pyserver        # start HTTP server on current directory
```

### Virtual Environments

```bash
mkv [name]      # create venv (default: venv)
vrun [name]     # activate venv
```

To enable auto-activation when entering directories with venv, add to profile.local:

```bash
PYTHON_AUTO_VRUN=true
PYTHON_VENV_NAME=".venv"  # optional, default is "venv"
```

### Multiple Python Versions

Homebrew can have multiple Python versions installed simultaneously:

```bash
brew install python@3.12 python@3.13 python@3.14
brew link python@3.13  # sets default python3/pip3
```

Version-specific commands are always available:

```bash
python3.12, pip3.12
python3.13, pip3.13
python3.14, pip3.14
```

### Installing Python Packages

Homebrew's Python is "externally managed" (PEP 668) and won't allow global pip installs. Options:

1. **pipx** (Best for CLI tools):

   ```bash
   brew install pipx
   pipx ensurepath
   pipx install <package>
   ```

2. **Virtual environments** (Best for projects):

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

3. **--user flag** (Quick installs):

   ```bash
   pip3 install --user <package>
   ```

For standalone Python scripts, use a dedicated venv and update the shebang to point to the venv's Python interpreter.

## Kintsugi

Ruby gem for resolving Xcode project file merge conflicts.

Repository: <https://github.com/Lightricks/Kintsugi>

Install after setting up rbenv:

```bash
gem install kintsugi
```

## tmux

### Mouse Selection (iTerm-like behavior)

The tmux.conf is configured for iTerm-like mouse selection:

- **Click-drag**: Selects text, copies to clipboard, selection stays visible
- **Double-click**: Selects word, copies to clipboard, selection stays visible
- **Press `q` or `Escape`**: Exit copy mode and clear selection

### Copy Mode Cheatsheet (vi mode)

Enter copy mode: `prefix + [` (usually `Ctrl-b [`)

#### Navigation

| Key | Action |
| --- | --- |
| `h/j/k/l` | Move left/down/up/right |
| `w` / `b` | Word forward / backward |
| `0` / `$` | Beginning / end of line |
| `g` / `G` | Top / bottom of buffer |
| `Ctrl-b` / `Ctrl-f` | Page up / down |
| `/` / `?` | Search forward / backward |
| `n` / `N` | Next / previous search match |

#### Selection and Copy

| Key | Action |
| --- | --- |
| `v` | Start selection |
| `V` | Select line |
| `y` | Copy selection to clipboard |
| `Enter` | Copy selection and exit |
| `Escape` or `q` | Cancel / exit copy mode |

## iTerm2: enable word jumping

Use ⌥ + <-/-> (left/right arrow) to jump from one word to the next

- From preferences, go to “Profiles”. Under the “Keys”, click “Key Mappings” then the “+” to create a new Key Mapping.
- From the "Action" drop-down, select “Send Escape Sequence”.
- For left, enter the keyboard shortcut ⌥+left arrow, and Esc+ ‘b’
- For right, enter the keyboard shortcut ⌥+right arrow, and Esc+ ‘f’

## `brew cu`

Upgrade all outdated casks

### Prevent updating cask with `bcu` -- pin a specific cask version

To install a specific version of a cask/formula, follow the instructions in [this Stack Overflow answer](https://stackoverflow.com/a/66477916/662731)

1. Go to the Homebrew Cask [search page](https://formulae.brew.sh/cask/)
1. Search for the application you are looking for
1. Click Cask code link
1. On Github click History button
1. Find the version you need by reading the commit messages and view the raw file (hover text: View code at this point). Confirm the version variable (normally on line 2) is the version you need.
    - Click on the name of the commit, then three dots and select View file
1. Right-click Raw button and "Save Link As..." to download the file locally
1. Move to ~/config/homebrew/pinned_casks
1. Run `brew install --cask ~/config/homebrew/pinned_casks/<FORMULA_NAME>.rb`
1. Voilà 😄

When `bcu` shows an update available, choose interactive mode and pin to exclude it from updates, or use `bcu --pin <FORMULA_NAME>` to pin it.

## [Fix for 'git-credential-osxkeychain wants to access key "github.com" in your keychain'](https://stackoverflow.com/a/71936715/662731)

OSX prompts for a password every time you use git after brew upgrades git. To make Keychain Access trust git with the password again, you have to open Keychain Access, search for github under Keychain: login, kind: Internet password, and add the new path to git-credential-osxkeychain.

Or, just delete the github password and regenerate the Personal Access Token again. (source: [Fixing the git-credential-osxkeychain password prompts on every git transaction](https://dominoc925.blogspot.com/2019/11/fixing-git-credential-osxkeychain.html))

## Speed the Dock open/close animation

`defaults write com.apple.dock autohide-time-modifier -float 0.15;killall Dock`

## Prevent FigmaAgent from launching on startup

- remove FigmaAgent.app

    ```bash
    % rm -fr ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

- create a dummy file

    ```bash
    % touch ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

- make the file undeletable

    ```bash
    % sudo chflags -R schg ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

Now Figma will not be able to override that file when it wants to update it. Also the login item does not get created for me again after removal at this point

### revert the changes

- remove the schg flag

    ```bash
    % sudo chflags -R noschg ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

- remove the dummy file

    ```bash
    % rm -fr ~/Library/Application\ Support/Figma/FigmaAgent.app
    ```

## VS Code

### `ctrl+l` — Scroll Current Line to Center

This keybinding (equivalent to Vim's `zz`) is powered by the [Commands](https://marketplace.visualstudio.com/items?itemName=usernamehw.commands) extension (`usernamehw.commands`), which allows defining custom command IDs that invoke built-in VSCode commands with arguments.

#### How it works

`Viewport.scrollCenter` is not a built-in VSCode command — it's a custom command defined in settings that calls `revealLine` with `${lineNumber}` (the current cursor line) and `at: "center"`.

#### Setup for each profile

The `commands.commands` setting is **application-scoped**, so VS Code's Settings UI will refuse to let you add it in a non-default profile. **Bypass this by editing the profile's `settings.json` directly** (Cmd+Shift+P → "Open User Settings (JSON)").

Add to the profile's `settings.json`:

```json
"commands.variableSubstitutionEnabled": true,
"commands.commands": {
    "Viewport.scrollCenter": {
        "command": "revealLine",
        "args": {
            "lineNumber": "${lineNumber}",
            "at": "center"
        }
    }
}
```

And add to the profile's `keybindings.json`:

```json
{
    "key": "ctrl+l",
    "command": "Viewport.scrollCenter",
    "when": "editorTextFocus"
}
```

> **Note:** `commands.variableSubstitutionEnabled` must be `true` or `${lineNumber}` will be passed as a literal string instead of the actual line number.

#### Finding the correct profile settings file

VS Code profiles each have their own settings files under:
`~/Library/Application Support/Code/User/profiles/<id>/`

To open the current profile's settings JSON: Cmd+Shift+P → **"Open User Settings (JSON)"**. This always opens the active profile's file.

## Claude Code Plugins

Plugins extend Claude Code with additional capabilities. They are configured in `~/.config/claude/settings.json` under the `enabledPlugins` key.

**Currently installed:**

- **context7**: Library documentation lookup
- **superpowers**: Enhances Claude Code with additional tools and capabilities

### Installing plugins

```bash
claude plugin install <plugin-name>@<source>
```

Example:

```bash
claude plugin install superpowers@claude-plugins-official
```

Browse available plugins at <https://claude.com/plugins>.

## Claude Code MCP Servers

MCP servers are configured in `~/.config/claude/settings.json` under the `mcpServers` key (set via `CLAUDE_CONFIG_DIR`). Use `bin/sync-backups.sh` to back up configuration changes.

**Currently installed:**

- **fastmail**: Email/calendar/contacts management (local install at `~/.local/share/mcp/fastmail-mcp`)

**Token usage tip:** Fastmail has 30 tools (~18.5k tokens). Disable by renaming to `_fastmail_disabled` in `~/.config/claude/settings.json` to save ~9% context.

### Fastmail MCP Server

Repository: <https://github.com/MadLlama25/fastmail-mcp>

#### Installation

```bash
git clone https://github.com/MadLlama25/fastmail-mcp.git ~/.local/share/mcp/fastmail-mcp
cd ~/.local/share/mcp/fastmail-mcp
npm install
npm run build
```

#### Configuration

1. Get your Fastmail API token: Fastmail → Settings → Privacy & Security → Connected apps & API tokens

2. Add `FASTMAIL_API_TOKEN=<token>` to `~/.config/zsh/profile.local` (not tracked in git — token is inherited by Claude Code as an env var)

3. Add to `~/.config/claude/settings.json` under `mcpServers`:

```json
"fastmail": {
  "command": "npx",
  "args": ["/Users/soob/.local/share/mcp/fastmail-mcp/dist/index.js"]
}
```

#### Updating

```bash
cd ~/.local/share/mcp/fastmail-mcp
git pull
npm install
npm run build
```
