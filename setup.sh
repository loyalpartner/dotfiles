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
[ -h ~/.zshrc ] || [ -e ~/.zshrc ] && mv -v ~/.zshrc ~/.zshrc.bak
ln -s $script_dir/zsh/zshrc.zsh ~/.zshrc

# Tmux
[ -h ~/.tmux.conf ] && mv -v ~/.tmux.conf ~/.tmux.conf.bak
ln -s $script_dir/tmux/tmux.conf ~/.tmux.conf

# vim
[ -h ~/.vimrc.local ] || [ -e ~/.vimrc.local ] && mv -v ~/.vimrc.local ~/.vimrc.local.bak
ln -s $script_dir/vim/.vimrc.local ~/.vimrc.local
[ -h ~/.vimrc.bundles.local ] || [ -e ~/.vimrc.bundles.local ] && mv -v ~/.vimrc.bundles.local ~/.vimrc.bundles.local.bak
ln -s $script_dir/vim/.vimrc.bundles.local ~/.vimrc.bundles.local
[ -h ~/.vimrc.before.fork ] || [ -e ~/.vimrc.before.fork ] && mv -v ~/.vimrc.before.fork ~/.vimrc.before.fork.bak
ln -s $script_dir/vim/.vimrc.before.fork ~/.vimrc.before.fork

# cheat
[ -h ~/.cheat ] || [ -e ~/.cheat ] && mv -v ~/.cheat ~/.cheat.bak
ln -s $script_dir/cheat ~/.cheat

# vimperator
#[ -h ~/.vimperatorrc ] && mv -v ~/.vimperatorrc ~/.vimperatorrc.bak
#ln -s $script_dir/vimperator/vimperatorrc.vim ~/.vimperatorrc

# pentadactyl
[ -h ~/.pentadactylrc ] && mv -v ~/.pentadactylrc ~/.pentadactylrc.bak
ln -s $script_dir/pentadactyl/pentadactylrc.vim ~/.pentadactylrc

# snippets
snippets_directory=~/.vim/bundle/vim-snippets/snippets/
if test -d $snippets_directory;then
  rm $snippets_directory*.snip
  ln -s snippets/*.snip $snippets_directory
fi
# wget https://j.mp/spf13-vim3 -O ~/spf13-vim.sh && sh ~/spf13-vim.sh

#if [[ ! -a ~/.w3m/keymap ]]; then
  #ln -s $script_dir/w3m/keymap ~/.w3m/keymap
  #ln -s $script_dir/w3m/bookmark.html ~/.w3m/bookmark.html
#fi

bash $script_dir/git/gitconfig.sh
# vim: set foldmethod=marker
