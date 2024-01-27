# Common user configuration
# echo "Common user configuration"

export LS_COLORS='bd=40;33;01:cd=40;33;01:di=01;34:ex=100;01;33:fi=00:ln=01;36:no=00:or=40;31;01:pi=40;33:so=01;35:*.aac=01;34:*.app=01;33:*.arj=01;31:*.asf=01;35:*.avi=01;35:*.bin=01;31:*.bmp=01;35:*.bz2=01;31:*.c=01;36:*.cgi=01;36:*.cpp=01;36:*.dmg=01;32:*.flac=01;34:*.gif=01;35:*.gz=01;31:*.h=01;37:*.hqx=01;31:*.jpg=01;35:*.JPG=01;35:*.js=01;36:*.lzh=01;31:*.m=01;36:*.m4a=01;34:*.m4v=01;35:*.md=01;37:*.mkv=01;35:*.mov=01;35:*.mp3=01;34:*.mp4=01;34:*.mpg=01;35:*.pdf=01;35:*.php=01;36:*.pl=01;36:*.png=01;35:*.sh=01;36:*.sit=01;31:*.sitx=01;31:*.smi=01;32:*.swift=01;36:*.tar=01;31:*.taz=01;31:*.tcl=01;36:*.tgz=01;31:*.tif=01;35:*.tiff=01;35:*.ts=01;36:*.webm=01;35:*.wmv=01;35:*.xml=01;37:*.yml=01;37:*.z=01;31:*.Z=01;31:*.zip=01;31:*.zsh=01;36:'
export CLICOLOR=1

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

## iTerm shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

## rbenv
# https://github.com/rbenv/rbenv
eval "$(rbenv init - zsh)"
# ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.
# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
# To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following to your ~/.zshrc:
# For Ruby versions 2.x–3.0:
# - brew install openssl@1.1 readline libyaml gmp
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# Ruby 3.1 and above requires OpenSSL 3:
# - brew install openssl@3 readline libyaml gmp
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

export PATH="/usr/local/sbin:$PATH"

export PATH="$(brew --prefix binutils)/bin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix curl)/bin:$PATH"
export PATH="$(brew --prefix diffutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix ed)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-tar)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-which)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix openssl)/libexec/gnubin:$PATH"
# export PATH="$(brew --prefix unzip)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix python)/bin:$PATH"

export PATH=$HOME/bin:$PATH
