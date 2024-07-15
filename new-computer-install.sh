#!/bin/sh
# Software for provisioning up a Macbook Pro and all that good stuff.
# Cloned from Iheanyi Ekechukwu
# (https://github.com/iheanyi/dotfiles)
# Inspired by komputer-maschine by Lauren Dorman
# (https://github.com/laurendorman/komputer-maschine)

# Permanently prevent macOS High Sierra from reopening apps after a restart
#
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

# Install zsh-completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

## Install packages
# https://formulae.brew.sh/formula/
echo "Check formulae..."
packages=(
  # binutils
  coreutils
  curl
  # diffutils
  emacs
  findutils
  git
  git-lfs
  grep
  gzip
  highlight
  kubectl
  mc
  openssh
  python3
  rbenv
  screen
  tmux
  wget
  xcbeautify
  youtube-dl
  zsh
  zsh-syntax-highlighting
  # https://remysharp.com/2018/08/23/cli-improved
  ack
  bat
  # diff-so-fancy
  fd
  fzf
  ncdu
  tldr
)

for formula in ${packages[@]}
  do brew_install $formula
done

## node
#
# use nvm to install node
# https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating

# Install applications
# https://formulae.brew.sh/cask/

## Notes
#
# Add `.../Dropbox/ApplicationSupport/Raycast/CommandScripts` as watch directory for Raycast Script Commands (Extension)
#
# To install a specific version of a cask/formula, follow the instructions here:
#   https://stackoverflow.com/a/66477916/662731
# 1 Go to the Homebrew Cask search page: https://formulae.brew.sh/cask/
# 2 Type and find the application you are looking for
# 3 Click Cask code link
# 4 On Github click History button
# 5 Find the version you need by reading the commit messages and view the raw file. Confirm the version variable (normally on line 2) is the version you need.
# 6 Click on the name of the commit, then three dots and select View file
# 7 Right-click Raw button and Save Link As... to download the file locally
# 8 When downloaded, go to download directory cd Downloads/
# 9 Finally run brew install --cask <FORMULA_NAME>.rb
# 10 Voilà 😄

# maestral keep-alive instructions: https://daringfireball.net/2023/07/nerding_out_with_maestral_launchcontrol_and_keyboard_maestro

applications=(
  # 1password (https://1password.com/downloads/mac/) -- !! download directly !!
  abbyy-finereader-pdf # https://www.abbyy.com/en-us/finereader/
  alfred # https://www.alfredapp.com/
  amadeus-pro # https://www.hairersoft.com/pro.html
  # arc (https://arc.net/)
  audio-hijack # https://rogueamoeba.com/audiohijack/
  audiobook-builder # https://www.splasm.com/audiobookbuilder/
  # audioranger (https://www.audioranger.com/)
  # backblaze (https://www.backblaze.com/computer-backup/docs/install-the-backup-client-mac)
  # backblaze-downloader (https://www.backblaze.com/)
  bartender # https://www.macbartender.com/
  betterzip # https://macitbetter.com/
  beyond-compare # https://www.scootersoftware.com/
  brave-browser # https://brave.com/
  calibre # https://calibre-ebook.com/
  carbon-copy-cloner # https://bombich.com/
  cardhop # https://flexibits.com/cardhop
  choosy # https://www.choosyosx.com/
  cloudflare-warp
  cyberduck # https://cyberduck.io/
  daisydisk # https://daisydiskapp.com/
  default-folder-x # https://www.stclairsoft.com/DefaultFolderX/
  devtoys # https://dev.toys/
  discord # https://discord.com/
  eaglefiler # https://c-command.com/eaglefiler/
  fantastical # https://flexibits.com/fantastical
  firefox # https://www.mozilla.org/en-US/firefox/new/
  fission # https://rogueamoeba.com/fission/
  fluid # https://fluidapp.com/
  google-chrome # https://www.google.com/chrome/
  homebrew/cask/handbrake # https://handbrake.fr/
  hazel # https://www.noodlesoft.com/
  istat-menus # https://bjango.com/mac/istatmenus/
  iterm2 # https://iterm2.com/
  karabiner-elements # https://karabiner-elements.pqrs.org/
  keyboard-cleaner # https://folivora.ai/keyboardcleaner
  launchcontrol # https://www.soma-zone.com/LaunchControl/
  logi-options-plus
  logitech-g-hub
  logitech-options
  maestral # https://maestral.app/
  # mailmate (https://freron.com/) -- using beta version
  mailmate@beta
  microsoft-edge # https://www.microsoft.com/en-us/edge
  moneydance # https://moneydance.com/
  moom # https://manytricks.com/moom/
  musicbrainz-picard # https://picard.musicbrainz.org/
  mylio # https://mylio.com/
  name-mangler # https://manytricks.com/namemangler/
  netnewswire # https://ranchero.com/netnewswire/
  notion # https://www.notion.so/
  obsidian # https://obsidian.md/
  opera # https://www.opera.com/
  path-finder # https://cocoatech.com/
  poe # https://poeapp.com/
  # postman () -- work
  raycast # https://raycast.com/
  reunion # https://www.reunionapp.com/
  shortcutdetective # https://www.irradiatedsoftware.com/labs/
  skim # https://skim-app.sourceforge.io/
  slack # https://slack.com/
  soundsource # https://rogueamoeba.com/soundsource/
  sourcetree # https://www.sourcetreeapp.com/
  # spotify -- problems launching after updates
  steam # https://store.steampowered.com/about/
  suspicious-package # https://www.mothersruin.com/software/SuspiciousPackage/
  # the-archive-browser -- using BetterZip instead
  the-unarchiver # https://theunarchiver.com/
  tower # https://www.git-tower.com/
  # unclutter (https://unclutterapp.com/) -- hombebrew version is out of date
  visual-studio-code # https://code.visualstudio.com/
  vlc # https://www.videolan.org/vlc/
  warp # https://www.warp.dev/
  xld # https://tmkk.undo.jp/xld/index_e.html
)

for cask in ${applications[@]}
  do brew_install $cask
done

# install pinned applications
for cask ("$ZSH_CUSTOM"/pinned_casks/*.rb(N)); do
  brew install --cask "$ZSH_CUSTOM"/pinned_casks/$cask"
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

### Fonts? ###
# https://github.com/githubnext/monaspace
# to install
#   `cd util`
#   `bash util/install_macos.sh`
