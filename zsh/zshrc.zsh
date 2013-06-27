# Path to your oh-my-zsh configuration.
ZSH=$HOME/source/oh-my-zsh

export EDITOR=$(which vim)
export MAIL=loyalpartner@163.com
export LANG="zh_CN.UTF-8"

ZSH_THEME="ys"
DISABLE_AUTO_TITLE="true"
plugins=(git autojump archlinux web-search colored-man python node gem \
  tmuxinator extract vi-mode myconfig xfce4)
source $ZSH/oh-my-zsh.sh

export PATH=$HOME/source/tmuxinator/bin:$PATH
#function share(){ sudo mount.cifs $1 $2 -o user=GaoPP,pass=a }

alias tmux='tmux -2'
alias mux='tmuxinator'
alias .='cd ~/dotfiles'
alias ins='sudo pacman -S'

# vim:set ft=zsh foldmethod=marker foldenable:
