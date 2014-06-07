#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"
echo $script_dir


if [[ ! -a ~/.zshrc ]]
then
  ln -s $script_dir/zsh/zshrc.zsh ~/.zshrc
fi


if [[ ! -a ~/.tmux.conf ]]; then
  ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf
fi

#if [[ ! -a ~/.w3m/keymap ]]; then
  #ln -s $script_dir/w3m/keymap ~/.w3m/keymap
  #ln -s $script_dir/w3m/bookmark.html ~/.w3m/bookmark.html
#fi

source $script_dir/git/gitconfig.sh
