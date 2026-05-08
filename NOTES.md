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
- **superpowers**: Enhances Claude Code with additional skills and workflows
- **feature-dev**: Guided feature development agents
- **github**: GitHub repository management (MCP — see GitHub MCP Server section below)
- **playwright**: Browser automation MCP server
- **commit-commands**: Slash commands `/commit`, `/commit-push-pr`, `/clean_gone`
- **explanatory-output-style**: Output style — educational insights while coding

### Installing plugins

```bash
claude plugin install <plugin-name>@<source>
```

Example:

```bash
claude plugin install superpowers@claude-plugins-official
```

Browse available plugins at <https://claude.com/plugins>.

The `enabledPlugins` list in `settings.json` is backed up by `bin/sync-backups.sh`, so installed plugins are captured automatically. On a new machine, restore them with:

```bash
bin/install-plugins.sh
```

This is also run automatically by `new-computer-install.sh`.

## Claude Code MCP Servers

In Claude Code v2.x, user-scope MCP servers are managed via `claude mcp add/remove --scope user` and stored in `~/.config/claude/.claude.json`. This file is **not** backed up (it contains OAuth tokens and ephemeral caches). Re-add servers after re-imaging using the commands below.

**Currently installed:**

- **kagi**: Web search via Kagi API
- **mailmate**: Email via MailMate app (requires MailMate running)
- **obsidian**: Vault access, semantic search, templates via MCP Tools plugin
- **github**: Repository management (plugin: `github@claude-plugins-official` — no local server)

**Not installed (fastmail):** Fastmail has 30 tools (~18.5k tokens of context). Omitted to save context — use MailMate MCP for email instead.

### Fresh install: restore MCP servers

Before running these, ensure API tokens are in `~/.config/zsh/profile.local`:

```bash
# profile.local entries needed:
export KAGI_API_KEY="<token>"
export KAGI_SUMMARIZER_ENGINE="cecil"
export OBSIDIAN_API_KEY="<token from Local REST API plugin data.json>"
```

Then add the servers:

```bash
claude mcp add --scope user kagi -- /opt/homebrew/bin/uvx kagimcp
claude mcp add --scope user mailmate -- /Users/soob/Developer/mailmate-mcp/.venv/bin/mailmate-mcp
claude mcp add --scope user obsidian -- /Users/soob/Dropbox/Apps/Obsidian/Home/.obsidian/plugins/mcp-tools/bin/mcp-server
```

### Kagi MCP Server

Uses `uvx` (uv tool runner) — no persistent install needed. API key inherited from shell environment.

Get token: <https://kagi.com/settings?p=api>

### MailMate MCP Server

Repository: local at `~/Developer/mailmate-mcp/`

Requires MailMate to be running. Must launch the venv server manually after restart (or configure as a login item).

#### Installation / setup

```bash
cd ~/Developer/mailmate-mcp
python -m venv .venv
.venv/bin/pip install mailmate-mcp
```

### Obsidian MCP Server

Plugin: [MCP Tools for Obsidian](https://github.com/jacksteamdev/obsidian-mcp-tools) — installed as community plugin `mcp-tools`.

Binary installed at: `{vault}/.obsidian/plugins/mcp-tools/bin/mcp-server` (downloaded by clicking "Install Server" in the plugin settings).

Requires: **Local REST API** plugin enabled with an API key. The `OBSIDIAN_API_KEY` is found in `{vault}/.obsidian/plugins/obsidian-local-rest-api/data.json`.

Also optional but recommended for full features: **Smart Connections** (semantic search) and **Templater** plugins.

Note: The plugin's "Install Server" button auto-configures Claude Desktop — Claude Code registration is done separately via `claude mcp add` (see restore commands above).

### GitHub MCP Server

Installed via plugin: `github@claude-plugins-official`. Uses GitHub's hosted Copilot MCP endpoint — no local server to run.

#### Installation

```bash
claude plugin install github@claude-plugins-official
```

#### Configuration

1. Create a fine-grained Personal Access Token at <https://github.com/settings/personal-access-tokens/new>

   **Repository access:** Select specific repos or "All repositories"

   **Repository permissions:**

   | Permission | Level |
   | --- | --- |
   | Contents | Read and write |
   | Issues | Read and write |
   | Pull requests | Read and write |
   | Commit statuses | Read-only |
   | Metadata | Read-only (auto-enabled) |

   Optional: Workflows (read and write) to trigger/view GitHub Actions.

2. Add token to `~/.config/zsh/profile.local` (not tracked in git):

   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN="<your-token>"
   ```

   Token is inherited by Claude Code as an env var — no need to store it in `settings.json`.

## Claude Code / Claude Desktop Memory System

Structured memory system (Young Leaders architecture) shared between Claude Code and Claude Desktop.

### How it works

- **Claude Code**: A `PreToolUse` hook (`inject-memory.py`) fires once per session, reads the global and project memory files, and injects them as context automatically.
- **Claude Desktop**: A `memory-files` filesystem MCP server exposes the same directory. Project system prompts tell Claude to read `general.md` at conversation start.

### File locations

```
~/.config/claude/
├── memory/
│   ├── memory.md                  # global index + routing table
│   ├── general.md                 # always-load cross-project rules
│   ├── tools/{tool}.md            # tool-specific knowledge (load on demand)
│   └── desktop-project-prompt.md  # template for Claude Desktop project system prompts
└── hooks/
    └── inject-memory.py           # PreToolUse hook for Claude Code
```

Per-project memory lives at:

```
~/.config/claude/projects/{path-mapped}/memory/MEMORY.md
```

### Fresh install: restore memory system

All memory files and the hook script are backed up in the repo and synced via `bin/sync-backups.sh`.

After a fresh install, run sync-backups to restore:

```bash
bin/sync-backups.sh
```

Then verify the hook is wired up in `~/.config/claude/settings.json` under `hooks.PreToolUse` — it should have an entry running `inject-memory.py` with an empty matcher.

The hook uses PPID-based flag files in `/tmp/claude-memory-flags/` to fire only once per session. These are ephemeral and recreated automatically.

### Updating memory

| What to update | Where |
| --- | --- |
| Cross-project rule or preference | `~/.config/claude/memory/general.md` |
| Tool-specific knowledge | `~/.config/claude/memory/tools/{tool}.md` (add pointer in `memory.md`) |
| Project-specific context | `~/.config/claude/projects/{path}/memory/MEMORY.md` |

Run `bin/sync-backups.sh` after updating memory files to keep the repo backup current.

### Claude Desktop Projects

Use the template in `~/.config/claude/memory/desktop-project-prompt.md` as the system prompt for new Claude Desktop Projects. It instructs Claude to read `general.md` via the `memory-files` MCP at conversation start.

The `memory-files` MCP is configured in `~/Library/Application Support/Claude/claude_desktop_config.json` — this file is **not** backed up (contains API keys). Re-add it manually after re-imaging:

```json
"memory-files": {
  "command": "/opt/homebrew/bin/npx",
  "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/soob/.config/claude/memory"]
}
```
