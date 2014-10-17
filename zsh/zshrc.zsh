# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

export EDITOR=$(which vim)
export MAIL=loyalpartner@163.com
export LANG="zh_CN.UTF-8"
export TERM=xterm-256color

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias tmux='tmux -2'
alias mux='tmuxinator'
#alias .='cd ~/dotfiles'
alias ins='sudo pacman -S'

alias rg='rake generate'
alias rd='rake deploy'
alias rgd='rake gen_deploy'
alias rp='rake preview'

alias apti='sudo apt-get install'
alias aptu='sudo apt-get update'
alias aptup='sudo apt-get upgrade'
alias aptr='sudo apt-get remove'
alias aptar='sudo apt-get autoremove'
#alias sshs=''

function tel () {
    adb -d forward tcp:8080 tcp:8080 
    telnet 127.0.0.1:8080
}
function sshs () {
    ssh ${1:=192.168.1.103} -p 8090 -l username -t /data/data/com.spartacusrex.spartacuside/files/system/bin/bash -init-file /data/data/com.spartacusrex.spartacuside/files/.init
}
function wadb(){
    #adb disconnect ${1:=192.168.1.103}
    adb connect ${1:=192.168.1.103} && sleep 2 && adb shell
}

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=( \
  git autojump archlinux web-search colored-man colorize \
  coffee cake python node gem pip \
  tmuxinator extract gradle cheat)

source $ZSH/oh-my-zsh.sh

# User configuration

export ANDROID_HOME="/home/lee/src/android-sdk-linux"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh

# export SSH_KEY_PATH="~/.ssh/dsa_id"

PAGER='less -X -M' export LESSOPEN="| $(which src-hilite-lesspipe.sh) %s" export LESS=' -R '

alias -s png=eog
alias -s jpg=eog
alias -s jpeg=eog
alias -s gif=eog

function copy (){
    if which xsel > /dev/null; then
        echo "$1" | xsel -bi
    else
        echo xsel not exist
    fi
}

#echo "Did you know that:"; whatis $(ls /bin | shuf -n 1)
#cowsay -f $(ls /usr/share/cowsay/cows | shuf -n 1 | cut -d. -f1) $(whatis $(ls /bin) 2> /dev/null | shuf -n 1)
