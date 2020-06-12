#!/usr/bin/env bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

echo $script_dir

ln -fs $script_dir/zsh/zshrc.zsh ~/.zshrc

if [[  "$OSTYPE" == "linux-gnu"*  ]]; then
  ln -fs $script_dir/sxhkd $HOME/.config/sxhkd
  ln -fs xprofile $HOME/.xprofile
fi

