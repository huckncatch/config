#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)
#
# Permanently prevent macOS High Sierra from reopening apps after a restart
# https://apple.stackexchange.com/a/309140/234778
# sudo rm -f ~/Library/Preferences/ByHost/com.apple.loginwindow*
# touch ~/Library/Preferences/ByHost/com.apple.loginwindow*
# sudo chown root ~/Library/Preferences/ByHost/com.apple.loginwindow*
# sudo chmod 000 ~/Library/Preferences/ByHost/com.apple.loginwindow*

# helper functions
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

# Copy config files
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

copy_zsh_config() {
  echo "Copying zshrc..."
  # zshrc="./zsh/home-dot-zsh/zshrc"
  # filename=$(basename "$zshrc")
  # newFilename=".$filename"
  local zshrc
  personal=$(_prompt_install "Personal config?")
  if [[ "$personal" == "yes" ]]; then
    echo "Home..."
    zshrc="./zsh/home-dot-zsh/zshrc"
    # TODO: do I want to update `/etc/zshrc` too?
  else
    echo "Work"
    zshrc="./zsh/work-dot-zsh/zshrc"
    # TODO: do I want to update `/etc/zshrc` too?
  fi
  # cp "$zshrc" "$HOME/$newFilename"
  cp "$zshrc" "$HOME/.zshrc"
}
copy_zsh_config

# Install Homebrew
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Taps
# https://github.com/buo/homebrew-cask-upgrade
brew tap buo/cask-upgrade
# used by [Java installation instructions](https://johnathangilday.com/blog/macos-homebrew-openjdk/)
brew tap homebrew/cask-versions

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Install packages
# https://formulae.brew.sh/formula/
echo "Check formulae..."
packages=(
  bat
  # binutils
  coreutils
  curl
  diff-so-fancy
  # diffutils
  emacs
  fd
  findutils
  git
  git-lfs
  grep
  gzip
  highlight
  ncdu
  openssh
  python3
  rbenv
  screen
  tldr
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

## Notes
#
# Add `.../Dropbox/ApplicationSupport/Raycast/CommandScripts` as watch directory for Raycast Script Commands (Extension)
#
# To install a specific version of a cask/formula, follow the instructions here:
#   https://stackoverflow.com/a/66477916/662731

applications=(
  # 1password
  a-better-finder-rename # pinned
  abbyy-finereader-pdf
  alfred
  amadeus-pro
  # arc
  audio-hijack
  audiobook-builder
  # backblaze
  # backblaze-downloader
  bartender # pinned?
  bbedit # pinned
  betterzip
  beyond-compare
  calibre
  carbon-copy-cloner
  cardhop
  choosy
  cloudflare-warp
  # copilot-for-xcode
  daisydisk
  default-folder-x
  # devtoys
  discord
  eaglefiler
  fantastical
  firefox
  fission
  fluid
  google-chrome
  graphicconverter
  homebrew/cask/handbrake
  hazel
  istat-menus
  iterm2
  keyboard-cleaner
  # knuff
  launchcontrol
  logi-options-plus
  logitech-g-hub
  logitech-options
  maestral
  # mailmate
  moneydance
  moom
  musicbrainz-picard
  mylio
  name-mangler
  netnewswire
  notion
  opera
  path-finder
  poe
  # postman
  raycast
  reunion
  skim
  slack
  soundsource
  sourcetree
  spotify
  # stats
  steam
  suspicious-package
  # the-archive-browser
  the-unarchiver
  tower
  visual-studio-code
  vlc
  workflowy
  xld
)

for cask in ${applications[@]}
  do brew_install $cask
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

# Not sure these taps are needed (or correct)
# Cask usage: https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md
# Install brew caskroom
# brew tap homebrew/cask
# brew tap homebrew/fonts

### Fonts? ###
