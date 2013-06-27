# Path to your oh-my-zsh configuration.
ZSH=$HOME/source/oh-my-zsh

export EDITOR=$(which vim)
export MAIL=loyalpartner@163.com

# oh-my-zsh #{{{
ZSH_THEME="ys"

# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
export LANG="zh_CN.UTF-8"
#export PATH=/home/lee/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
plugins=(git autojump archlinux web-search colored-man python node gem tmuxinator extract)
source $ZSH/oh-my-zsh.sh
#}}}

autoload zmv
setopt nocorrectall
setopt listrowsfirst

#source $HOME/.bash_aliases
#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#PATH=$PATH:$HOME/tmuxinator/bin # Add RVM to PATH for scripting

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# bindkeys
# 操作vim化
# 在编辑的情况下使用emacs的快捷键
# 如果需要绑定额外 shell命令，需要 -s选项
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#stty intr ^X # 将C-x当成中断键,C-c映射成 <Esc>#{{{
#bindkey -s '^c' ''
bindkey -v
#bindkey -s ',;' ';' 
bindkey -s '\el' 'ls'
bindkey -s '\eh' 'cd ~'
bindkey -s '\e-' 'cd -'

bindkey '\eq' push-line-or-edit
bindkey '' accept-line-and-down-history
bindkey '\e.' insert-last-word

bindkey -M vicmd v edit-command-line
bindkey -M viins '' beginning-of-line
bindkey -M viins '' end-of-line
#bindkey -M viins '' backward-delete-char
bindkey -M viins '' backward-delete-char
bindkey -M viins '' backward-delete-word
bindkey -M viins '' kill-line
bindkey -M viins '' backward-kill-line
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins 'f' emacs-forward-word
bindkey -M viins 'b' emacs-backward-word

bindkey -M viins '' history-incremental-search-backward
bindkey -M vicmd '' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
bindkey -M vicmd '^S' history-incremental-search-forward
#}}}

function share(){ sudo mount.cifs $1 $2 -o user=GaoPP,pass=a }

alias tmux='tmux -2'
alias mux='tmuxinator'
alias .='cd ~/dotfiles'
alias ins='sudo pacman -S'

# 备份
bp(){ 
  cp $1{,.bak}
}
# 恢复
rt(){
  zmv -f "($1).bak" "\$1"
}

sx(){
  if [[ -a ~/gtkrc-2.0 ]]; then
    mv ~/{gtkrc-2.0,.gtkrc-2.0}
  fi
  startx
}

sx4(){
  if [[ -a ~/.gtkrc-2.0 ]]; then
    mv ~/{.gtkrc-2.0,gtkrc-2.0}
  fi
  if [[ -n `which brew` ]]; then
      startxfce4
  fi
}

s(){
    dig "$*.jianbing.org" +short txt | perl -pe's/\\(\d{1,3})/chr $1/eg; s/(^"|"$)//g'
}

export PATH=$HOME/source/tmuxinator/bin:$PATH
# vim:set ft=zsh foldmethod=marker foldenable:
