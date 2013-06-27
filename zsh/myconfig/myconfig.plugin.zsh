autoload zmv
setopt nocorrectall
setopt listrowsfirst
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
#
# bindkeys
# 在编辑的情况下使用emacs的快捷键
# 如果需要绑定额外 shell命令，需要 -s选项
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
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

# 备份
backup(){ 
  cp $1{,.bak}
}
# 恢复
revert(){
  zmv -f "($1).bak" "\$1"
}
#翻译
translate(){
    dig "$*.jianbing.org" +short txt | perl -pe's/\\(\d{1,3})/chr $1/eg; s/(^"|"$)//g'
}

alias bp='backup'
alias rt='revert'
alias s='translate'

