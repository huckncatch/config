#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)

brew_install() {
  if test ! $(brew list | grep $package); then
    brew install "$@"
  else
    echo '$package already installed, gonna skip that.'
  fi
}

cask_install() {
  if test ! $(brew cask list | grep $application); then
    brew install "$@"
  else
    echo '$application already installed, gonna skip that.'
  fi
}

# copy_configs() {
#   cp .nvimrc ~
#   cp .tmux.conf ~
# }

# Install Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# Install packages
# https://formulae.brew.sh/formula/
packages=(
  binutils
  coreutils
  curl
  diffutils
  emacs
  findutils
  git
  git-lfs
  highlight
  openssh
  python3
  tmux
  wget
  youtube-dl
  zsh
  zsh-syntax-highlighting
)

for package in "$packages[@]"
  do brew_install $package
done

# Install languages
# languages=(
#   elixir
#   go
#   ruby
# )
#
# for package in "$languages[@]"
#   do brew_install $package
# done

# Cask usage: https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
# Install brew caskroom
# brew tap homebrew/cask
# brew tap homebrew/fonts

# Install applications
# https://formulae.brew.sh/cask/
applications=(
  1password
  a-better-finder-rename
  abbyy-finereader-pdf
  alfred
  amadeus-pro
  arc
  audio-hijack
  audiobook-builder
  backblaze
  backblaze-downloader
#   bartender
  bbedit
  betterzip
  beyond-compare
  calibre
  carbon-copy-cloner
  cardhop
  choosy
  copilot-for-xcode
  daisydisk
  default-folder-x
  discord
  eaglefiler
  fantastical
  firefox
  fission
  fluid
  google-chrome
  graphicconverter
  handbrake
  istat-menus
  iterm2
  keyboard-cleaner
  knuff
  launchcontrol
  logi-options-plus
  logitech-g-hub
  logitech-options
  mailmate
  moneydance
  moom
  musicbrainz-picard
  mylio
  name-mangler
  netnewswire
  notion
  path-finder
  poe
  postman
  raycast
  reunion
  skim
  slack
  soundsource
  sourcetree
  spotify
  steam
  suspicious-package
  the-archive-browser
  the-unarchiver
  tower
  visual-studio-code
  vlc
  xld
)

for application in "$applications[@]"
  echo "installing $application"
  do cask_install $application
done
