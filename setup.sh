#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"
echo $script_dir

# 如果存在～/.zshrc先备份
[ -h ~/.zshrc ] || [ -e ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak -v
ln -s $script_dir/zsh/zshrc.zsh ~/.zshrc

# 如果存在～/.tmux.conf先备份
[ -h ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.bak -v
ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf

## 如果存在 ~/.vimperatorrc先备份
## 已升级到 pentadactyl
#[ -h ~/.vimperatorrc ] && mv ~/.vimperatorrc ~/.vimperatorrc.bak -v
#ln -s $script_dir/vimperator/vimperatorrc.vim ~/.vimperatorrc

# 如果存在 ~/.pentadactylrc先备份
[ -h ~/.pentadactylrc ] && mv ~/.pentadactylrc ~/.pentadactylrc.bak -v
ln -s $script_dir/pentadactyl/pentadactylrc.vim ~/.pentadactylrc

# wget https://j.mp/spf13-vim3 -O ~/spf13-vim.sh && sh ~/spf13-vim.sh

#if [[ ! -a ~/.w3m/keymap ]]; then
  #ln -s $script_dir/w3m/keymap ~/.w3m/keymap
  #ln -s $script_dir/w3m/bookmark.html ~/.w3m/bookmark.html
#fi

echo $script_dir/git/gitconfig.sh
source $script_dir/git/gitconfig.sh
