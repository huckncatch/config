echo "oh-my-zsh/custom/00_aliases.zsh"

if [[ -o interactive ]]; then

  # default switches
  alias ls='command ls -FsC --color=auto --si'
  alias mv='nocorrect command mv -i'
  alias cp='nocorrect command cp -i'
  alias jobs='builtin jobs -l'
  alias mmv="noglob zmv -W"

  alias eg='set | grep -i'
  alias ag='alias | grep -i'
  alias cg='compctl | grep -i'
  alias hg='history 1- | grep -i'
  alias c=clear

# doesn't work with sudo... do I really need nocorrect anyway?
#     alias mkdir='nocorrect mkdir'   # no spelling correction on mkdir

  alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

  alias em='emacs'
  alias so=source
  alias sorc='so ~/.zshrc'

  # ls aliases
  alias lg="grep 'alias l' $ZDOT/zshrc_local.d/aliases.mine.zsh"  # show all list aliases
#     alias ll='ls -l'                    # long listing (no dot files)
#     alias la='ls -lA'                   # long listing (full)
#     alias lt='ls -lt'                   # long listing sorted by date
  alias ltr='ls -ltr'                 # long listing sorted by date (reversed)
  alias l.='ls -ld .*'                # list dot files only
  # List only directories and symbolic links that point to directories
  alias lsd='ls -ld *(-/DN)'          # list directories only
  alias lsda='ls -l *(-/DN)'          # list directories and their contents

  alias grep=egrep

  # git
  alias grhs='git reset --soft'
#   alias gt='git tag'
  alias gpot='git push origin "$(git_current_branch)" && git push origin --tags'
  alias gfst='git fetch && git status'
  alias gfasb='git fetch --all --prune && git status --short --branch'
  alias grs.='git restore .'

  alias gfind='find . -type f -follow -print0 | xargs -0 grep -n'
  alias clean="find . -name '*.orig' -type f -follow -print0 | xargs -0 rm -f"

  alias yt='youtube-dl --cookies ./cookies.txt --recode-video mp4'
  alias rmquarantine='xattr -d -r com.apple.quarantine'

  alias verifyCodeSign='codesign --verify --verbose'

  alias nrt='npm run transpile'
  alias nrs='npm run start'
  alias nrts='nrt && nrs'
  alias nrtest='npm run test'

  alias bi='brew info'
  alias bs='brew search'
fi
