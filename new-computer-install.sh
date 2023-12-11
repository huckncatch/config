#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)

_prompt_install() {
  local response
  read -r -p "$1 (y/n): " response
  if [[ $response == [Yy] || $response == "yes" ]]; then
      echo "yes"
    else
      echo "no"
    fi
}

_brew_list_does_not_contain() {
  # local brew_list_output
  brew_list_output=$(brew list 2>/dev/null)
  if [[ $brew_list_output != *"$@"* ]]; then
    return 0
  else
    return 1
  fi
}

brew_install() {
  if _brew_list_does_not_contain "$formula"; then
   proceed=$(_prompt_install "Install $formula?")
    if [[ "$proceed" == "yes" ]]; then
      echo "Installing..."
      brew install "$formula"
    else
      echo "Declined"
    fi
  else
    echo "$formula already installed, gonna skip that."
  fi
}

copy_dotfiles() {
  echo "Copying dotfiles..."
  for file in "./dotfiles"/*; do
    filename=$(basename "$file")
    newFilename=".$filename"
    echo "$newFilename"
    cp "$file" "$HOME/$newFilename"
  done
}
copy_dotfiles

# Install Homebrew
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Check formulae..."# Install packages
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

for formula in ${packages[@]}
  do brew_install $formula
done

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
  bartender
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

for formula in ${applications[@]}
  do brew_install $formula
done

## Never been tried
# Install languages
# languages=(
#   elixir
#   go
#   ruby
# )
#
# for formula in ${languages[@]}
#   do brew_install $formula
# done

# Cask usage: https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
# Install brew caskroom
# brew tap homebrew/cask
# brew tap homebrew/fonts