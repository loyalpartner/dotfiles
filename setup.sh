#!/usr/bin/env bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"


ln -vfs $script_dir/zsh/zshrc.zsh ~/.zshrc

if [[  "$OSTYPE" == "linux-gnu"*  ]]; then
  if [[ ! -h  "$HOME/.config/sxhkd" ]]; then
    ln -vfs $script_dir/sxhkd/ $HOME/.config/
  fi
  ln -vfs $script_dir/xprofile $HOME/.xprofile
fi

ln -vfs $script_dir/tmux.conf ~/.tmux.conf

[[ -h "$HOME/.ctags.d" ]] || ln -vfs $script_dir/ctags.d/ $HOME/.ctags.d

[[ -h "$HOME/.config/sway" ]] || ln -vfs $script_dir/sway/ $HOME/.config/sway
[[ -h "$HOME/.config/alacritty" ]] || ln -vfs $script_dir/alacritty/ $HOME/.config/alacritty

source "$script_dir/init-git.sh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

