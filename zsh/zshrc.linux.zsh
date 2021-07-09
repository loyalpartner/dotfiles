export PATH=~/.gem/ruby/3.0.0/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=~/.yarn/bin:$PATH

# setxkbmap dvorak
# xset r rate 300 40
source ~/Documents/work/dmpp/chromium/src/tools/bash-completion

export FZF_DEFAULT_OPTS="--bind 'f1:execute(less -f {}),ctrl-y:execute-silent(echo {} |sed \"s/[0-9 ]\+//\" | xclip -selection clipboard)+abort'"

alias gite="git config -e --global"

alias ma="mpc add"
alias mp="mpc prev"
alias mn="mpc next"
alias ml="mpc listall"
alias mls="mpc ls"
alias mm="mpc toggle"
alias mt="mpc repeat 1;mpc toggle"

alias xclip="xclip -selection clipboard"
alias myip="echo $(curl -s http://myip.ipip.net)"
