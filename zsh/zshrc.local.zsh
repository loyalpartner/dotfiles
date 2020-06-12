# -*- mode: sh -*-

[[ "$OSTYPE" == "linux-gnu"* ]] && source $script_dir/zshrc.linux.zsh

alias vim=nvim
alias pip-install='pip install -i https://pypi.tuna.tsinghua.edu.cn/simple some-package'

bindkey -s '' fg
bindkey -s '' clear

if [[ $OSTYPE = "linux-gnu"  && -e ~/.zshrc.linux ]] then
	source ~/.zshrc.linux
fi

export EDITOR="nvim"
function emsclt
{
	emacsclient -nc "$@"
}

export proxy="socks5://127.0.0.1:1080"
alias git-proxy="git config --global http.proxy $proxy;git config --global https.proxy $proxy"
alias git-unproxy='git config --global http.proxy "";git config --global https.proxy ""'


alias b="echo \$(bindkey | sed -e 's/\"//g' | fzf -q \')|awk '{print \$2}'"

alias a='select_alias_run $@'

alias le=edit_select_locate "$@" #locate edit
alias updatelocatedb="sudo updatedb --add-prunepaths ~/.emacs.d/.local/cache"

function select_alias_run
{
	local command=$(alias|fzf -q "$*")
	local alias=${command%%=*}
	# command=${command#\'}
	# command=${command%\'}
	# $SHELL -c "$command"
  eval $alias
	echo $command
}
# sudo updatedb --add-prunepaths /home/lee/.emacs.d/.local/cache
# locate 过滤文件夹 https://bbs.archlinuxcn.org/viewtopic.php?pid=42514#p42514
function edit_select_locate
{
	local file=$(locate /|fzf -q "$*")
	[[ -e $file ]] && $EDITOR $file
}
