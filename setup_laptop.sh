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

fancy_echo "Installing zsh, a better more customizable terminal ..."
  sudo apt install -y zsh

fancy_echo "Installing tmux, a powerful terminal multiplexer..."
  sudo apt install -y tmux

fancy_echo "Installing ag, similar to ack but faster..."
  sudo apt install -y silversearcher-ag

fancy_echo "Installing tig, command line git sourcetree..."
  sudo apt install -y tig

#Switch to zsh shell
fancy_echo "Changing your shell to zsh ..."
  sudo chsh -s $(which zsh) $(whoami)
  zsh

fancy_echo "Installing Oh-My-Zsh plugin for zsh ..."
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
