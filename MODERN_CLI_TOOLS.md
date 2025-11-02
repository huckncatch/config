# Modern CLI Tools Reference Guide

This guide covers the modern replacements for traditional Unix tools installed via Homebrew.

## Quick Reference

| Old Tool | Modern Replacement | What It Does |
|----------|-------------------|--------------|
| `find` | `fd` | Find files/directories |
| `grep` | `rg` (ripgrep) | Search file contents |
| `ls` | `eza` | List directory contents |
| `cat` | `bat` | Display file contents with syntax highlighting |
| `du` | `ncdu` | Disk usage analyzer (interactive) |

---

## fd - Modern Find Replacement

**Homepage:** https://github.com/shepskyh/fd

### Why fd is better than find:
- Faster (parallel execution)
- Easier syntax (no need for `-name` or `-type`)
- Respects `.gitignore` by default
- Colorized output
- Smart case sensitivity

### Basic Usage:

```bash
# Find files by name (simple pattern)
fd README.md

# Find files by extension
fd -e js
fd -e py

# Find directories only
fd -t d config

# Find files only
fd -t f

# Include hidden files
fd -H pattern

# Include ignored files (like .gitignore entries)
fd -I pattern

# Search in specific directory
fd pattern /path/to/dir

# Execute command on results
fd -e js -x eslint

# Find and delete
fd -e tmp -x rm
```

### Advanced Examples:

```bash
# Find files modified in last 24 hours
fd -t f --changed-within 24h

# Find large files (>100MB)
fd -t f --size +100m

# Find by full path (not just filename)
fd --full-path /etc/.*\.conf

# Exclude specific directories
fd -E node_modules -E .git pattern

# Find files with multiple extensions
fd -e js -e ts

# Show absolute paths
fd --absolute-path pattern
```

---

## ripgrep (rg) - Modern Grep Replacement

**Homepage:** https://github.com/BurntSushi/ripgrep

### Why ripgrep is better than grep:
- Extremely fast (parallelized search)
- Respects `.gitignore` by default
- Supports all regex features
- Automatically skips binary files
- Colorized output with context

### Basic Usage:

```bash
# Simple search
rg pattern

# Case-insensitive search
rg -i pattern

# Search specific file types
rg -t js pattern
rg -t py pattern

# List available file types
rg --type-list

# Search only in specific files
rg pattern -g '*.js'
rg pattern -g 'test_*.py'

# Show context (lines before/after match)
rg -C 3 pattern    # 3 lines before and after
rg -B 2 pattern    # 2 lines before
rg -A 2 pattern    # 2 lines after

# Show line numbers (default on)
rg -n pattern

# Show files with matches only
rg -l pattern

# Show count of matches per file
rg -c pattern
```

### Advanced Examples:

```bash
# Search for whole words only
rg -w function

# Search including hidden files
rg -. pattern

# Search including ignored files
rg -u pattern

# Search EVERYTHING (hidden + ignored + binary)
rg -uuu pattern

# Multiline search
rg -U 'pattern1.*pattern2'

# Regex search with capture groups
rg 'TODO: (.+)' -r 'DONE: $1'

# Search and replace (preview)
rg 'old_name' -r 'new_name'

# Inverse search (lines NOT matching)
rg -v pattern

# Search with multiple patterns (OR)
rg 'pattern1|pattern2'

# Fixed string search (no regex)
rg -F 'literal.string'

# Show statistics
rg --stats pattern
```

### Combining with fd:

```bash
# Search only in JavaScript files using fd + rg
fd -e js -x rg pattern

# Search in files modified recently
fd --changed-within 1d -x rg pattern
```

---

## eza - Modern ls Replacement

**Homepage:** https://github.com/eza-community/eza

### Why eza is better than ls:
- Git integration (shows status)
- Icons support
- Better color schemes
- Tree view built-in
- More intuitive options

### Basic Usage (via your aliases):

```bash
# Basic listing (aliased to 'ls')
ls

# Long format
ll

# Show all (including hidden)
la

# Sort by modification time
lt

# Reverse time sort
ltr

# Show only dot files
l.

# Directories only
lsd

# Tree view (not aliased, use directly)
eza --tree
eza --tree --level=2
eza --tree --git-ignore

# Show git status
eza --long --git

# Show file headers
eza --long --header

# Group directories first
eza --group-directories-first
```

---

## bat - Modern cat Replacement

**Homepage:** https://github.com/shepskyh/bat

### Why bat is better than cat:
- Syntax highlighting
- Git integration (shows modifications)
- Line numbers
- Paging for long files
- Theme support

### Basic Usage (aliased to 'cat'):

```bash
# View file with syntax highlighting
cat file.js

# Show line numbers
bat -n file.py

# Show all characters (including whitespace)
bat -A file.txt

# Specific language syntax
bat -l json data.txt

# Plain output (no decorations)
bat --plain file.txt
bat -p file.txt

# Compare with diff
bat file1.txt file2.txt

# Theme selection
bat --list-themes
bat --theme="Monokai Extended" file.js

# Paging control
bat --paging=never file.txt
```

### Integration with other tools:

```bash
# Use in pipelines
rg pattern | bat -l log

# Preview with fzf (already aliased as 'preview')
preview

# View man pages with highlighting
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

---

## ncdu - Modern du Replacement

**Homepage:** https://dev.yorhel.nl/ncdu

### Why ncdu is better than du:
- Interactive TUI interface
- Easy navigation
- Quick deletion
- Export/import capability
- Shows percentages

### Basic Usage (aliased to 'du'):

```bash
# Analyze current directory
du

# Analyze specific path
ncdu /path/to/directory

# Show hidden files
ncdu -h

# Navigation keys (once running):
# ↑/↓ - Navigate files
# →   - Enter directory
# ←   - Parent directory
# d   - Delete selected item
# g   - Show percentage/graph
# n   - Sort by name
# s   - Sort by size
# q   - Quit
```

---

## Additional Modern Tools You Have

### tree - Directory visualization
```bash
# Show directory tree
tree

# Limit depth
tree -L 2

# Show hidden files
tree -a

# Show only directories
tree -d

# Colorize output
tree -C
```

### fzf - Fuzzy finder
```bash
# Interactive file search
fzf

# Preview files (use your alias)
preview

# Search history
history | fzf

# Kill process interactively
ps aux | fzf | awk '{print $2}' | xargs kill

# Change directory interactively
cd $(fd -t d | fzf)
```

### tldr - Simplified man pages
```bash
# Quick help for any command
tldr fd
tldr rg
tldr tar
tldr git
```

---

## Tips for Learning

1. **Use `--help` flag** - All these modern tools have excellent help:
   ```bash
   fd --help
   rg --help
   eza --help
   bat --help
   ```

2. **Start with basic aliases** - Your aliases already provide sensible defaults

3. **Use tldr for quick reference**:
   ```bash
   tldr fd
   tldr rg
   ```

4. **Practice with real tasks**:
   ```bash
   # Find all JavaScript files modified today
   fd -e js --changed-within 1d

   # Search for TODOs in Python files
   rg -t py 'TODO|FIXME'

   # Find large log files
   fd -e log --size +10m
   ```

5. **Combine tools**:
   ```bash
   # Find and search in one go
   fd -e md -x rg pattern

   # Interactive file search with preview
   fd | fzf --preview 'bat --color=always {}'
   ```

---

## Escape Hatches

If you need the original tools, they're still available:

```bash
# Use original tools with 'command' or full path
command find . -name "*.txt"
command grep pattern file.txt
/usr/bin/find . -name "*.txt"

# Or temporarily disable aliases in a subshell
(unalias find; find . -name "*.txt")
```

---

## Configuration Files

Your aliases are in: `~/config/zsh/oh-my-zsh-custom/01_aliases.zsh`
ncdu config: `~/.config/ncdu/config`
bat themes: `bat --config-file` (to see location)

To reload aliases after changes:
```bash
exec zsh  # or use alias: ez
```
