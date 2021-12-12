# -*- mode: sh -*-

#[[ "$OSTYPE" == "linux-gnu"* ]] && source $script_dir/zshrc.linux.zsh
export PATH=/usr/lib/icecream/bin:$PATH
export PATH=~/.gem/ruby/3.0.0/bin:$PATH
export PATH=~/go/bin:$PATH
export PATH=~/.yarn/bin:$PATH
export PATH=~/.local/bin:$PATH
export PATH=$PATH:~/depot_tools

export EDITOR="vim"
export FZF_DEFAULT_COMMAND='rg --files --max-depth 3'
COPY_COMMAND="echo {} |sed \"s/[0-9 ]\+//\" | xclip -selection clipboard"
export FZF_DEFAULT_OPTS="\
  --height 50% --preview \"bat --style=numbers --color=always --line-range :500 {}\" \
  --bind 'ctrl-y:execute-silent($COPY_COMMAND)+abort' \
  "
bindkey -s "^z" "^e^ufg^m"

alias b="echo \$(bindkey | sed -e 's/\"//g' | fzf -q \')|awk '{print \$2}'"
alias a='run_alias'
alias mux=tmuxinator
alias trans="trans :zh"
alias man='_man'
alias open="_open"
alias pip-install='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package'
alias cpl="history -n | tail -n 1 | xclip"
alias cpf=mime_file_copy
alias le=edit_select_locate "$@" #locate edit
alias lc="_locate"
alias ll="_locate | fpp -c vim"
alias updatelocatedb="sudo updatedb --add-prunepaths ~/.emacs.d/.local/cache"
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
alias zsheli="vim $script_dir/zshrc.linux.zsh"
alias tmuxe="vim ~/.tmux.conf"
alias swaye="vim ~/.config/sway/config"

# functions
function _locate { locate --database /var/lib/mlocate/chromium.db $@ }
function emsclt { emacsclient -nc "$@" }
function _man { vim -c "Man $*" -c "only" }
function _open { bash -c "exec xdg-open \"$(fzf -q "$*")\" &" }
function run_alias
{
	local command=$(alias|fzf -q "$*")
	local alias=${command%%=*}
	eval $alias && echo $command
}
# sudo updatedb --add-prunepaths /home/lee/.emacs.d/.local/cache
# locate 过滤文件夹 https://bbs.archlinuxcn.org/viewtopic.php?pid=42514#p42514
function edit_select_locate
{
	local file=$(locate /|fzf -q "$*")
	[[ -e $file ]] && $EDITOR $file
}
function mime_file_copy
{
	local file=$(fzf -q "$*")
	local mime_type=$(file -b --mime-type "$file")

	xclip -selection clipboard -t $mime_type -i $file
	echo "copy file $file to clipboard"
}
