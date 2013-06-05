#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

echo $script_dir

if [[ ! -a ~/.zshrc ]]
then
  ln -s $script_dir/zshrc.zsh ~/.zshrc
fi

if [[ ! -a ~/.vimrc ]]
then
  ln -s $script_dir/vim/vimrc.vim ~/.vimrc
fi

if [[ ! -a ~/.tmux.conf ]]; then
  ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf
fi
