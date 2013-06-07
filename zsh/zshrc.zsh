# Path to your oh-my-zsh configuration.
ZSH=$HOME/source/oh-my-zsh

export EDITOR=vim
export MAIL=loyalpartner@163.com

setopt nocorrect
setopt listrowsfirst

# oh-my-zsh #{{{
ZSH_THEME="ys"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
#COMPLETION_WAITING_DOTS="true"

export LANG="zh_CN.UTF-8"

#export PATH=/home/lee/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git autojump python node gem tmuxinator)


source $ZSH/oh-my-zsh.sh
#}}}

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
#bindkey -s ',;' ';' 
bindkey -v
bindkey -s '^c' ''

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

# man 彩色化
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

alias tmux='tmux -2'
alias ins='sudo pacman -S'

# vim:set ft=sh foldmethod=marker foldenable:
