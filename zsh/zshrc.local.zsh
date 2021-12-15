# -*- mode: bash -*-

export PATH=/usr/lib/icecream/bin:$PATH
export PATH=~/.gem/ruby/3.0.0/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=~/.yarn/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=$PATH:~/depot_tools

export EDITOR="vim"
export FZF_DEFAULT_COMMAND='fd --max-depth 3'
export FZF_DEFAULT_OPTS="\
  --height 50% \
  --preview 'bat --style=numbers --color=always --line-range :500 {}' \
  --bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)+abort' \
  "
bindkey -s "^z" "^e^ufg^m"

alias b="echo \$(bindkey | sed -e 's/\"//g' | fzf --no-preview -q \')|awk '{print \$2}'"
alias tb="tmux list-keys -T prefix | fzf --no-preview"
alias a='_run_alias'
alias mux=tmuxinator
alias t="_trans"
alias man='_man'
alias open="_open"
alias pip-install='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package'
alias cph="history -n | fzf | xclip"
alias cpf=_copy
alias lo="_locate"
alias loc="DB=/var/lib/mlocate/chromium.db _locate"
#alias updb="sudo updatedb --add-prunepaths ~/.emacs.d/.local/cache"
alias updb="sudo updatedb --add-prunenames '.git .cache .local .undodir'"
alias myip="curl -s http://myip.ipip.net"
alias xclip="xclip -selection clipboard"
alias gite="git config -e --global"

# mpc 
alias ma="mpc add"
alias mp="mpc prev"
alias mn="mpc next"
alias ml="mpc listall"
alias mls="mpc ls"
alias mm="mpc toggle"
alias mt="mpc repeat 1;mpc toggle"

# quick open config
alias zshe="vim ~/.zshrc"
alias zshel="vim $script_dir/zshrc.local.zsh"
alias tmue="vim ~/.tmux.conf"
alias swae="vim ~/.config/sway/config"

# functions
function _trans { trans :zh -no-autocorrect "$*"}
function _locate { _auto_open $(locate --database "$DB" ${@:-""} | fzf -q "$*") }
function _emacs { emacsclient -nc "$@" }
function _man { vim -c "Man $*" -c "only" }
function _auto_open {
  if [[ "$1" == "" ]]; then return ; fi
  case $(file -Lb --mime-type $1) in
    text/troff) man ./ $1;;
    text/*) ${EDITOR:-vim} $1;;
    *) bash -c "exec ${LAUNCHER:-xdg-open} $1 &"
  esac
}
function _open { _auto_open "$(fzf -q "$*")" }
function _run_alias
{
	local command=$(alias|fzf -q "$*")
	eval $command && echo $command
}
function _auto_copy {
  if [[ "$1" == "" ]]; then return ; fi
	xclip -selection clipboard -t "$(file -Lb --mime-type "$1")" -i $1
}
function _copy { _auto_copy "$(fzf -q "$*")" }
