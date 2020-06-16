#!/usr/bin/env bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

ln -vfs $script_dir/zsh/zshrc.zsh ~/.zshrc

if [[  "$OSTYPE" == "linux-gnu"*  ]]; then
  if [[ ! -h  "$HOME/.config/sxhkd" ]]; then
    ln -vfs $script_dir/sxhkd $HOME/.config/sxhkd/
  fi
  ln -vfs $script_dir/xprofile $HOME/.xprofile
fi

