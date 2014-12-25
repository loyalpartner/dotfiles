#!/bin/bash
################################################################################
#
# 快速配置 Tmux， Vim 等常用工具
#
#   1. Tmux 
#   2. Vim 
#   3. Cheat 
#   4. Pentadactyl
#   5. Git
#
################################################################################

script_dir="$( cd "$( dirname "$0" )" && pwd )"
echo $script_dir

# zsh
[ -h ~/.zshrc ] || [ -e ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak -v
ln -s $script_dir/zsh/zshrc.zsh ~/.zshrc

# Tmux
[ -h ~/.tmux.conf ] && mv ~/.tmux.conf ~/.tmux.conf.bak -v
ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf

# vim
[ -h ~/.vimrc.local ] || [ -e ~/.vimrc.local ] && mv ~/.vimrc.local ~/.vimrc.local.bak -v
ln -s $script_dir/vim/.vimrc.local ~/.vimrc.local
[ -h ~/.vimrc.bundles.local ] || [ -e ~/.vimrc.bundles.local ] && mv ~/.vimrc.bundles.local ~/.vimrc.bundles.local.bak -v
ln -s $script_dir/vim/.vimrc.bundles.local ~/.vimrc.bundles.local
[ -h ~/.vimrc.before.fork ] || [ -e ~/.vimrc.before.fork ] && mv ~/.vimrc.before.for ~/.vimrc.before.fork.bak -v
ln -s $script_dir/vim/.vimrc.before.fork ~/.vimrc.before.fork

# cheat
[ -h ~/.cheat ] || [ -e ~/.cheat ] && mv ~/.cheat ~/.cheat.bak -v
ln -s $script_dir/cheat ~/.cheat

# vimperator
#[ -h ~/.vimperatorrc ] && mv ~/.vimperatorrc ~/.vimperatorrc.bak -v
#ln -s $script_dir/vimperator/vimperatorrc.vim ~/.vimperatorrc

# pentadactyl
[ -h ~/.pentadactylrc ] && mv ~/.pentadactylrc ~/.pentadactylrc.bak -v
ln -s $script_dir/pentadactyl/pentadactylrc.vim ~/.pentadactylrc

# wget https://j.mp/spf13-vim3 -O ~/spf13-vim.sh && sh ~/spf13-vim.sh

#if [[ ! -a ~/.w3m/keymap ]]; then
  #ln -s $script_dir/w3m/keymap ~/.w3m/keymap
  #ln -s $script_dir/w3m/bookmark.html ~/.w3m/bookmark.html
#fi

bash $script_dir/git/gitconfig.sh
# vim: set foldmethod=marker
