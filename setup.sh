#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"
echo $script_dir


if [ -e ~/.zshrc ]; then
#  mv ~/.zshrc ~/.zshrc.bak
  echo exists
fi
#ln -s $script_dir/zsh/zshrc.zsh ~/.zshrc


if [ -e ~/.tmux.conf ]; then
  echo exists
fi
#ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf

#if [[ ! -a ~/.w3m/keymap ]]; then
  #ln -s $script_dir/w3m/keymap ~/.w3m/keymap
  #ln -s $script_dir/w3m/bookmark.html ~/.w3m/bookmark.html
#fi

source $script_dir/git/gitconfig.sh
