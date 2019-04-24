#!/bin/bash

#Welcome to Jellene's laptop script! This script is inspired by
# thoughbot's discontinued linux laptop script. This script will
# install development essentials on your laptop and make it awesome! <3


# Shared functions
fancy_echo() {
  printf "\n%b\n" "$1"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="$2"

  if [[ -w "$HOME/.zshrc.local" ]]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if (( skip_new_line )); then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}


#Trap
trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
set -e

#Create .zshrc and .bin files for later
if [[ ! -d "$HOME/.bin/" ]]; then
  mkdir "$HOME/.bin"
fi

if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
fi

append_to_zshrc 'export PATH="$HOME/.bin:$PATH"'

# Method to check for Ruby Gems
gem_install_or_update() {
  if gem list "$1" --installed > /dev/null; then
    fancy_echo "Updating %s ..." "$1"
    gem update "$@"
  else
    fancy_echo "Installing %s ..." "$1"
    gem install "$@"
    rbenv rehash
  fi
}


#----------------------------------
# APT Package installation
#
fancy_echo "Installing git, for source control management ..."
  sudo apt install -y git

fancy_echo "Installing vim, best editor ever! ..."
  sudo apt install -y vim vim-gnome

if [[ ! -d "$HOME/.vim" ]]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall &> /dev/null

#fancy_echo "Installing libraries for common gem dependencies ..."
#  sudo apt install -y libgpm-dev libpcre3 libpcre3-dev libevent-dev libncurses-dev automake autotools-dev curl zlib1g-dev build-essential libyaml-dev libssl-dev libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libqtwebkit-dev libreadline-dev libxml2-dev

fancy_echo "Installing sqlite, a common database used by Ruby On Rails ..."
  sudo apt install -y sqlite3 libsqlite3-dev

fancy_echo "Installing ImageMagick, to crop and resize images ..."
  sudo apt install -y imagemagick

fancy_echo "Installing zsh, a better more customizable terminal ..."
  sudo apt install -y zsh

fancy_echo "Installing node, to render the rails asset pipeline ..."
  sudo apt install -y nodejs npm

fancy_echo "Installing checkinstall, for easy package removal ..."
  sudo apt install -y checkinstall

fancy_echo "Installing tmux, a powerful terminal multiplexer..."
  sudo apt install -y tmux

#Switch to zsh shell
fancy_echo "Changing your shell to zsh ..."
  sudo chsh -s $(which zsh) $(whoami)
  zsh

fancy_echo "Installing Oh-My-Zsh plugin for zsh ..."
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"


#------------------------------------
# Silver Searcher (ag) Installation
#
silver_searcher_from_source() {
  git clone git://github.com/ggreer/the_silver_searcher.git /tmp/the_silver_searcher
  sudo aptitude install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
  sh /tmp/the_silver_searcher/build.sh
  cd /tmp/the_silver_searcher
  sh build.sh
  sudo make install
  cd
  rm -rf /tmp/the_silver_searcher
}

if ! command -v ag >/dev/null; then
  fancy_echo "Installing The Silver Searcher (better than ack or grep) to search the contents of files ..."

  if aptitude show silversearcher-ag &>/dev/null; then
    sudo aptitude install silversearcher-ag
  else
    silver_searcher_from_source
  fi
fi

#---------------------------------------
# tig installation
#
if ! type tig 2>/dev/null; then
  git clone git@github.com:jonas/tig.git ~/Applications/tig
  cd ~/Applications/tig
  ./autogen.sh
  ./configure && make
  sudo checkinstall -y make install
fi

#------------------------------------
# All other personal installation will be installed from .laptop.local
#
fancy_echo "Installing your personal additions from ~/.laptop.local ..."
if [[ -d "$HOME/.laptop.local" ]]; then
  source ~/.laptop.local
fi
