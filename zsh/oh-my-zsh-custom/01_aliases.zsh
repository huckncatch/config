# ==============================================================================
# GENERAL SHELL ALIASES
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
# Loading order: Second (01_ prefix)
#
# Contains general-purpose shell aliases for interactive sessions
# Tool-specific aliases (git, homebrew, etc.) are in their respective files
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Only set aliases in interactive shells that are not Claude Code sessions.
# Why exclude CLAUDECODE: Claude Code captures shell snapshots that persist aliases
# across commands. Interactive aliases like 'cp -i' would cause Bash tool commands
# to hang waiting for confirmation. Other files use the same check with shorter comments.
if [[ -o interactive ]]; then

  # ==============================================================================
  # DIRECTORY LISTING (ls/eza)
  # ==============================================================================

  # Set USE_EZA=1 to use eza (modern ls replacement with git integration)
  # Set USE_EZA=0 to use traditional GNU ls
  USE_EZA=${USE_EZA:-1}

  # Base ls command with sensible defaults
  if [[ "$USE_EZA" == "1" ]]; then
    alias ls='eza --icons --git'
  else
    alias ls='command ls -FsC --color=auto --si'
  fi

  # Directory listing variations
  if [[ "$USE_EZA" == "1" ]]; then
    alias ll='ls -l'                               # long listing (no dot files)
    alias la='ls -la'                              # long listing with dot files
    alias lt='ls -l --sort=modified'               # long listing sorted by modification time
    alias ltr='ls -l --sort=modified --reverse'    # long listing sorted by time (oldest first)
    alias l.='ls -ld .*'                           # list dot files only
    alias lsd='ls -ld *(-/DN)'                     # list directories only
    alias lsda='ls -l *(-/DN)'                     # list directories with details
  else
    alias ll='ls -l'                               # long listing (no dot files)
    alias la='ls -la'                              # long listing with dot files
    alias lt='ls -lt'                              # long listing sorted by modification time
    alias ltr='ls -ltrFH'                          # long listing sorted by time (oldest first)
    alias l.='ls -ld .*'                           # list dot files only
    alias lsd='ls -ld *(-/DN)'                     # list directories only
    alias lsda='ls -l *(-/DN)'                     # list directories with details
  fi

  # ==============================================================================
  # SAFE FILE OPERATIONS
  # ==============================================================================

  # Interactive prompts for potentially destructive operations
  # nocorrect: Disable zsh spelling correction for these commands
  alias mv='nocorrect command mv -i'               # confirm before overwriting
  alias cp='nocorrect command cp -i'               # confirm before overwriting
  alias rm='nocorrect command rm -i'               # confirm before deleting

  # Mass rename using zmv (zsh built-in)
  # Example: mmv *.txt *.md  (renames all .txt to .md)
  alias mmv="noglob zmv -W"

  # mkdir spelling correction disabled - causes issues with sudo
  # Kept for reference in case a workaround is found
  # alias mkdir='nocorrect mkdir'

  # ==============================================================================
  # MODERN UNIX TOOL REPLACEMENTS
  # ==============================================================================

  # Modern alternatives to traditional Unix tools (faster, more user-friendly)
  alias find='fd'                                  # fd: faster, simpler syntax than find
  alias grep='rg'                                  # ripgrep: much faster than grep
  alias cat='bat'                                  # bat: cat with syntax highlighting
  alias du='ncdu'                                  # ncdu: interactive disk usage (config: ~/.config/ncdu/config)

  # ==============================================================================
  # SEARCH AND FIND ALIASES
  # ==============================================================================

  # Environment and alias searching
  alias eg='set | rg -i'                           # search environment variables
  alias alg='alias | rg -i'                        # search aliases
  alias cg='compctl | rg -i'                       # search completion controls

  # File searching (using fd)
  alias ff='fd --type f --hidden --exclude .git'   # find files (including hidden, excluding .git)

  # Content searching (using ripgrep)
  alias gfind='fd --type f --hidden --follow --exec rg -n'  # search in file contents with line numbers

  # File cleanup
  alias clean="fd -H -t f -e orig -x rm"           # remove .orig files (merge artifacts)

  # ==============================================================================
  # HISTORY MANAGEMENT
  # ==============================================================================

  alias h='history'                                # show command history
  alias hg="fc -El 0 | grep"                       # search command history

  # ==============================================================================
  # DIRECTORY NAVIGATION
  # ==============================================================================

  alias cdcode='cd ~/Developer'                    # development projects
  alias cddocs='cd ~/Documents'                    # documents
  alias cddls='cd ~/Downloads'                     # downloads
  alias cdpics='cd ~/Pictures'                     # pictures
  alias cdicloud='cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs'  # iCloud Drive

  # ==============================================================================
  # GENERAL UTILITIES
  # ==============================================================================

  alias c=clear                                    # clear terminal
  alias em='emacs'                                 # short emacs
  alias so='source'                                # source files
  alias ez='exec zsh'                              # restart shell (reload config)

  # Job control
  alias jobs='builtin jobs -l'                     # list background jobs with PIDs

  # ==============================================================================
  # ARCHIVE OPERATIONS
  # ==============================================================================

  alias mytar='tar -cvzf'                          # create compressed tar archive
  alias myuntar='tar -xvzf'                        # extract compressed tar archive

  # ==============================================================================
  # FILE PREVIEW AND VIEWING
  # ==============================================================================

  # fzf file preview with syntax highlighting
  alias preview="fzf --preview 'bat --color \"always\" {}'"

  # ==============================================================================
  # MACOS SPECIFIC
  # ==============================================================================

  # Remove quarantine attribute (for downloaded files blocked by macOS)
  alias rmquarantine='xattr -d -r com.apple.quarantine'

  # Verify code signature of applications
  alias verifyCodeSign='codesign --verify --verbose'

  # ==============================================================================
  # MEDIA AND DOWNLOADS
  # ==============================================================================

  # yt-dlp: Download videos with cookies and recode to mp4
  alias yt='yt-dlp --cookies ./cookies.txt --recode-video mp4 -o "%(title)s.%(ext)s"'

  # ==============================================================================
  # ITERM2 SPECIFIC
  # ==============================================================================

  # Display images in terminal
  alias ic='imgcat'

  # ==============================================================================
  # DEPRECATED/REPLACED ALIASES
  # ==============================================================================

  # Xcode workspace/project opener
  # Replaced by oxc() function in 02_functions.zsh for better error handling
  # Old version: opened first match without checking if multiple exist
  # alias oxc='[[ -d *.xcworkspace ]] && open *.xcworkspace || open *.xcodeproj'

  # Traditional grep/find patterns (replaced by modern tools above)
  # Kept for reference if reverting to traditional tools is needed
  # alias grep='egrep'
  # alias gfind='find . -type f -follow -print0 | xargs -0 grep -n'

fi
