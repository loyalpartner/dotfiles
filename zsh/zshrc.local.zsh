# -*- mode: bash -*-

paths=( 
  "/usr/lib/ccache/bin"
  "/usr/lib/icecream/bin"
  "/usr/share/bcc/tools"
  "$HOME/dotfiles/bin"
  "$HOME/.gem/ruby/3.0.0/bin"
  "$HOME/.local/share/gem/ruby/3.0.0/bin:"
  "$HOME/go/bin"
  "$HOME/.yarn/bin"
  "$HOME/.local/bin"
  "$HOME/depot_tools"
  "$HOME/icecc-chromium"
)
for p in $paths; do 
  [[ ! "$PATH" =~ $p ]] && export PATH="$PATH:$p"
done

if which pyenv > /dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"    # if `pyenv` is not already on PATH
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

export EDITOR="vim"
export FZF_DEFAULT_COMMAND='fd --max-depth 8'
export FZF_DEFAULT_OPTS="\
  --height 50% \
  --preview 'bat --style=numbers --color=always --line-range :500 {}' \
  --bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)+abort' \
  "

# alias
alias pkiller='_pkiller'
alias b="echo \$(bindkey | sed -e 's/\"//g' | fzf --no-preview -q \')|awk '{print \$2}'"
alias tb="tmux list-keys -T prefix | fzf --no-preview"
alias a='_run_alias'
alias mux=tmuxinator
alias t="_trans"
alias man='_man'
alias open="_open"
alias pip-install='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'
alias cph="history -n | fzf | xclip"
alias cpf=_copy
alias lo="_locate"
alias loc="DB=/var/lib/mlocate/chromium.db _locate"
#alias updb="sudo updatedb --add-prunepaths ~/.emacs.d/.local/cache"
alias updb="sudo updatedb --add-prunenames '.git .cache .local .undodir'"
alias myip="curl -s http://myip.ipip.net"
alias xclip="xclip -selection clipboard"
alias gite="git config -e --global"
# -> mpc 
alias mpca="mpc add"
alias mpcp="mpc prev"
alias mpcn="mpc next"
alias mpcl="mpc listall"
alias mpct="mpc toggle"
# -> quick open config
alias zshe="vim ~/.zshrc"
alias zshel="vim $script_dir/zshrc.local.zsh"
alias tmue="vim ~/.tmux.conf"
alias sshe="vim ~/.ssh/config"
alias gite="vim ~/.gitconfig"
alias swae="vim ~/.config/sway/config"
alias alae="vim ~/.config/alacritty/alacritty.yml"
which nvim > /dev/null 2>&1 && alias vim="nvim"
alias wfp="_wordfreq_from_webpage"

# bindkey
bindkey -s "^z" "^e^ufg^m"
#bindkey -s "^h" "| _stdin^m"

# functions
function _trans { trans :zh -no-autocorrect "$*"}
function _locate { _auto_open $(locate --database "$DB" ${@:-""} | fzf -q "$*") }
function _emacs { emacsclient -nc "$@" }
function _man {
  if grep -qo "\-k" <(echo "$@"); then
    \man $@
  else
    \vim -c "Man $*" -c "only"
  fi
}
function _stdin { vim -M +1 -c'nmap q :qa!<C-m>' - }
function _auto_open {
  if [[ "$1" == "" ]]; then return ; fi
  case $(file -Lb --mime-type $1) in
    text/troff) man ./ $1;;
    text/*) ${EDITOR:-vim} $1;;
    *) bash -c "exec ${LAUNCHER:-xdg-open} $1 > /dev/null 2>&1 &";;
  esac
}
function _open { _auto_open "$(fzf -e -q "$*")" }
function _run_alias {
  local command=$(alias|fzf -q "$*")
  eval $command && echo $command
}
function _auto_copy {
  if [[ "$1" == "" ]]; then return ; fi
  xclip -selection clipboard -t "$(file -Lb --mime-type "$1")" -i $1
}
function _copy { _auto_copy "$(fzf -q "$*")" }
function _pkiller { kill -9 $(lsof -ti :$1) }
function _wordfreq_from_webpage() {
  curl -s $1 | pup 'body text{}' | wf
}
