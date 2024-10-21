echo ".../oh-my-zsh-custom/00_aliases.zsh"

if [[ -o interactive ]]; then

  # default switches
  alias ls='command ls -FsC --color=auto --si'
  alias mv='nocorrect command mv -i'
  alias cp='nocorrect command cp -i'
  alias jobs='builtin jobs -l'
  alias mmv="noglob zmv -W"

  # search aliases
  alias eg='set | grep -i'
  alias ag='alias | grep -i'
  alias cg='compctl | grep -i'
  alias hg='history 1- | grep -i'

  alias c=clear

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

  # ls
  alias ltr='ls -ltrFH'                 # long listing sorted by date (reversed)
  alias l.='ls -ld .*'                # list dot files only
  ## List only directories and symbolic links that point to directories
  alias lsd='ls -ld *(-/DN)'          # list directories only
  alias lsda='ls -l *(-/DN)'          # list directories and their contents

  alias grep='egrep'

  # git
  alias gt='git tag'
  alias gpot='git push origin "$(git_current_branch)" && git push origin --tags'
  alias gfst='git fetch && git status'
  alias gfasb='git fetch --all --prune && git status --short --branch'
  alias grs.='git restore .'
  alias gsw-='git switch -'
  alias gbd!='git branch -D `git_previous_branch`'

  alias gfind='find . -type f -follow -print0 | xargs -0 grep -n'
  alias clean="find . -name '*.orig' -type f -follow -print0 | xargs -0 rm -f"

  alias yt='yt-dlp --cookies ./cookies.txt --recode-video mp4'
  alias rmquarantine='xattr -d -r com.apple.quarantine'

  alias verifyCodeSign='codesign --verify --verbose'

  # node package manager
  alias nrt='npm run transpile'
  alias nrs='npm run start'
  alias nrts='nrt && nrs'
  alias nrtest='npm run test'

  # homebrew
  alias bi='brew info'
  alias bs='brew search'
  alias blc='brew list --cask'
  alias bis='brew install'
  alias bcu='brew cu --all'
  ## brew plugin overrides
  alias bubo='brew update && brew outdated --formulae'
  alias bubc='brew upgrade --formulae && brew cleanup'
  unalias bugbc
  unalias bubug
  unalias bcubo
  unalias bcubc

  # iTerm
  alias ic='imgcat'

  # Xcode
  alias xcode-release='sudo xcode-select --switch /Applications/Xcode.app'
  alias xcode-beta='sudo xcode-select --switch /Applications/Xcode-beta.app'
fi
