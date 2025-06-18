echo ${0:A}

# fzf
# export FZF_DEFAULT_COMMAND='fd --type f --exclude "DerivedData"'
# Enable Ctrl+R history search with preview
export FZF_DEFAULT_COMMAND='ag -g ""'
# https://remysharp.com/2018/08/23/cli-improved
export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(code {})+abort,ctrl-b:execute(bbedit {})+abort'"

export LS_COLORS='bd=40;33;01:cd=40;33;01:di=01;34:ex=100;01;33:fi=00:ln=01;36:no=00:or=40;31;01:pi=40;33:so=01;35:*.aac=01;34:*.app=01;33:*.arj=01;31:*.asf=01;35:*.avi=01;35:*.bin=01;31:*.bmp=01;35:*.bz2=01;31:*.c=01;36:*.cgi=01;36:*.cpp=01;36:*.dmg=01;32:*.flac=01;34:*.gif=01;35:*.gz=01;31:*.h=01;37:*.hqx=01;31:*.jpg=01;35:*.JPG=01;35:*.js=01;36:*.lzh=01;31:*.m=01;36:*.m4a=01;34:*.m4v=01;35:*.md=01;37:*.mkv=01;35:*.mov=01;35:*.mp3=01;34:*.mp4=01;34:*.mpg=01;35:*.pdf=01;35:*.php=01;36:*.pl=01;36:*.png=01;35:*.sh=01;36:*.sit=01;31:*.sitx=01;31:*.smi=01;32:*.swift=01;36:*.tar=01;31:*.taz=01;31:*.tcl=01;36:*.tgz=01;31:*.tif=01;35:*.tiff=01;35:*.ts=01;36:*.webm=01;35:*.wmv=01;35:*.xml=01;37:*.yml=01;37:*.z=01;31:*.Z=01;31:*.zip=01;31:*.zsh=01;36:'
export CLICOLOR=1

## iTerm shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

export PATH="/usr/local/sbin:$PATH"

export PATH="$(brew --prefix binutils)/bin:$PATH"
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix curl)/bin:$PATH"
export PATH="$(brew --prefix diffutils)/libexec/gnubin:$PATH"
# export PATH="$(brew --prefix ed)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-tar)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-which)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix openssl)/libexec/gnubin:$PATH"
# export PATH="$(brew --prefix unzip)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix python)/libexec/bin:$PATH"

export PATH="$HOME/.rbenv/bin:$PATH"

export PATH="$HOME/bin:$PATH"

## These don't appear to be needed for the profiles plugin to work
# export HOST=$(hostname)

# if [[ "$OSTYPE" = darwin* ]]; then
#   # macOS's $HOST changes with dhcp, etc. Use ComputerName if possible.
#   export SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST="${HOST/.*/}"
# else
#   export SHORT_HOST="${HOST/.*/}"
# fi

## rbenv
# https://github.com/rbenv/rbenv
eval "$(rbenv init - --no-rehash zsh)"
# ruby-build installs a non-Homebrew OpenSSL for each Ruby version installed and these are never upgraded.
# https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
# To link Rubies to Homebrew's OpenSSL 1.1 (which is upgraded) add the following to your ~/.zshrc:
# For Ruby versions 2.x–3.0:
# - brew install openssl@1.1 readline libyaml gmp
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# Ruby 3.1 and above requires OpenSSL 3:
# - brew install openssl@3 readline libyaml gmp
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"

## nvm
# using the zsh-nvm plugin instead of the official nvm installation
# NVM_DIR is still getting set somehow
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
