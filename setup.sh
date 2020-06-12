#!/usr/bin/env bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

echo $script_dir

ln -fs $script_dir/zsh/zshrc.zsh ~/.zshrc
ln -fs $script_dir/sxhkd $HOME/.config/sxhkd

[[ "$OSTYPE" == "linux-gnu"* ]] && ln -fs xprofile $HOME/.xprofile

