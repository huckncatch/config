# ==============================================================================
# GENERAL SHELL ALIASES
# ==============================================================================
#
# Auto-loaded by oh-my-zsh from $ZSH_CUSTOM during initialization
# Loading order: Second (01_ prefix)
#
# Contains general-purpose shell aliases for interactive sessions
# ==============================================================================

[[ "$DEBUG_STARTUP" == "1" ]] && echo "      ${0:A}"

# Only set aliases in interactive shells that are not Claude Code sessions.
# Why exclude CLAUDECODE: Claude Code captures shell snapshots that persist aliases
# across commands. Interactive aliases like 'cp -i' would cause Bash tool commands
# to hang waiting for confirmation. Other files use the same check with shorter comments.
if [[ -o interactive ]]; then

  # Set USE_EZA=1 to use eza, or USE_EZA=0 to use traditional ls
  USE_EZA=${USE_EZA:-1}

  # default switches
  if [[ "$USE_EZA" == "1" ]]; then
    alias ls='eza --icons --git'
  else
    alias ls='command ls -FsC --color=auto --si'
  fi
  alias mv='nocorrect command mv -i'
  alias cp='nocorrect command cp -i'
  alias jobs='builtin jobs -l'
  alias mmv="noglob zmv -W"

  # search aliases
  alias eg='set | grep -i'
  alias alg='alias | grep -i'
  alias cg='compctl | grep -i'
  alias hg='history 1- | grep -i'

  alias c=clear
  alias cdicloud='cd ~/Library/Mobile\ Documents/com\~apple\~CloudDocs' # iCloud Drive
  alias cddls='cd ~/Downloads'
  alias cdpics='cd ~/Pictures'
  alias cddocs='cd ~/Documents'
  alias cdcode='cd ~/Developer'

# doesn't work with sudo... do I really need nocorrect anyway?
#     alias mkdir='nocorrect mkdir'   # no spelling correction on mkdir

  # https://remysharp.com/2018/08/23/cli-improved
  alias cat='bat'
  alias preview="fzf --preview 'bat --color \"always\" {}'"
  alias du='ncdu' # options in ~/.config/ncdu/config

  alias em='emacs'
  alias so='source'

  alias mytar='tar -cvzf'
  alias myuntar='tar -xvzf'

  # restart shell
  alias ez='exec zsh'

  # ls aliases - adapt based on USE_EZA
  if [[ "$USE_EZA" == "1" ]]; then
    alias ll='ls -l'                               # long listing (no dot files)
    alias la='ls -la'                              # long listing (full)
    alias lt='ls -l --sort=modified'               # long listing sorted by date
    alias ltr='ls -l --sort=modified --reverse'    # long listing sorted by date (reversed)
    alias l.='ls -ld .*'                           # list dot files only
    ## List only directories and symbolic links that point to directories
    alias lsd='ls -ld *(-/DN)'                     # list directories only
    alias lsda='ls -l *(-/DN)'                     # list directories and their contents
  else
    alias ll='ls -l'                    # long listing (no dot files)
    alias la='ls -la'                   # long listing (full)
    alias lt='ls -lt'                   # long listing sorted by date
    alias ltr='ls -ltrFH'               # long listing sorted by date (reversed)
    alias l.='ls -ld .*'                # list dot files only
    ## List only directories and symbolic links that point to directories
    alias lsd='ls -ld *(-/DN)'          # list directories only
    alias lsda='ls -l *(-/DN)'          # list directories and their contents
  fi

  alias grep='egrep'

  alias gfind='find . -type f -follow -print0 | xargs -0 grep -n'
  alias clean="find . -name '*.orig' -type f -follow -print0 | xargs -0 rm -f"

  alias yt='yt-dlp --cookies ./cookies.txt --recode-video mp4 -o "%(title)s.%(ext)s"'
  alias rmquarantine='xattr -d -r com.apple.quarantine'

  alias verifyCodeSign='codesign --verify --verbose'

  # iTerm
  alias ic='imgcat'

fi
