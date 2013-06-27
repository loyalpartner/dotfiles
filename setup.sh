#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"
echo $script_dir

echo "输入oh-my-zsh的目录，默认为$HOME/source/oh-my-zsh："
read oh_my_zsh

if [[ ! -d $oh_my_zsh ]]; then
  oh_my_zsh=$HOME/source/oh-my-zsh
fi

oh_my_zsh_plugins=$oh_my_zsh/plugins/
if [[ -d $oh_my_zsh_plugins ]]; then
  if [[ ! -d $oh_my_zsh_plugins/myconfig ]]; then
    mkdir $oh_my_zsh_plugins/myconfig
    ln -s $script_dir/zsh/myconfig/myconfig.plugin.zsh \
    $oh_my_zsh_plugins/myconfig/myconfig.plugin.zsh
  fi
  if [[ ! -d $oh_my_zsh_plugins/xfce4 ]]; then
    mkdir $oh_my_zsh_plugins/xfce4
    ln -s $script_dir/zsh/xfce4/xfce4.plugin.zsh \
    $oh_my_zsh_plugins/xfce4/xfce4.plugin.zsh
  fi
fi

if [[ ! -a ~/.zshrc ]]
then
  ln -s $script_dir/zsh/zshrc.zsh ~/.zshrc
fi

if [[ ! -a ~/.vimrc ]]
then
  ln -s $script_dir/vim/vimrc.vim ~/.vimrc
fi

if [[ ! -a ~/.tmux.conf ]]; then
  ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf
fi

if [[ ! -a ~/.w3m/keymap ]]; then
  ln -s $script_dir/w3m/keymap ~/.w3m/keymap
  ln -s $script_dir/w3m/bookmark.html ~/.w3m/bookmark.html
fi

source $script_dir/git/gitconfig.sh
