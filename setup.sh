#!/usr/bin/env bash

# set -e

# enable debug logs
DEBUG_ENABLE=1

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

REPO_OHMYZSH="https://github.com/ohmyzsh/ohmyzsh"
REPO_DOOM="https://github.com/hlissner/doom-emacs"
REPO_P10K="https://github.com/romkatv/powerlevel10k.git"
REPO_ZSH_SUGGESTION="https://github.com/zsh-users/zsh-autosuggestions"
REPO_ZSH_LXD="https://github.com/endaaman/lxd-completion-zsh"
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
URL_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

_path_relative_xdg_config_home() {
  echo ${XDG_CONFIG_HOME:-$HOME/.config}/$1
}

_path_relative_script_home() {
  echo $SCRIPT_DIR/$1
}

_ensure_directory_exists() {
  local dir=$1 remove_flag=${2:-true}

  if [[ -n $dir && $dir != "/" ]]; then
    if $remove_flag; then rm -rf $dir; fi
    mkdir -p $dir
  fi
}

_ensure_proxy_enabled() {
  local default_proxy prompt
  default_proxy='http://127.0.0.1:7890'
  prompt="use proxy(default $default_proxy): "
  if [[ -z $HTTP_PROXY || -z $HTTPS_PROXY ]]; then
    read -rep "${prompt}" proxy
    export HTTP{,S}_PROXY=${proxy:-$default_proxy}
  fi
}

ERROR='\033[0;31m'
INFO='\033[0;32m'
WARN='\033[0;33m'
DEBUG='\033[0;34m'
END='\033[0m'
warn() { echo -e ${WARN}[WARN] "$@"$END; }
info() { echo -e ${INFO}[INFO] "$@"$END; }
error() { echo -e ${ERROR}[ERROR] "$@"$END; }
debug() { [[ -n $DEBUG_ENABLE ]] && echo -e $DEBUG[DEBUG] "$@"$END; $@; }

_executable() {
  local cmd=$1
  which $cmd &> /dev/null
}

_is_ubuntu() { [[ "$(lsb_release -is)" =~ "Ubunutu" ]]; }
_is_arch() { [[ "$(lsb_release -is)" =~ "Arch" ]]; }

_arch() {
  local architecture=""
  case $(uname -m) in
    i386)   architecture="386" ;;
    i686)   architecture="386" ;;
    x86_64) architecture="amd64" ;;
    arm)    dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
  esac
  echo $architecture
}

_install_package() {
  _executable sudo || (error "sudo isn't installed" && return 1)

  local package=$1

  if _executable yay; then
    debug yay -S --needed --noconfirm $package
  elif _executable pacman; then
    debug sudo pacman -S --needed --noconfirm $package
  elif _executable apt; then
    debug sudo apt install $package
  fi
}

_install_packages() {
  _executable sudo || (error "sudo isn't installed" && return 1)

  if _executable yay || _executable pacman; then
    for pkg in $@; do _install_package $pkg; done
  elif _executable apt; then
    debug sudo apt install -y $@
  fi
}

_update_packages_index() {
  if _executable yay; then
    debug yay -Syu
  elif _executable pacman; then
    debug sudo pacman -Syu
  elif _executable apt; then
    debug sudo apt update
  fi
}

_git_clone_or_pull() {
  local repo_url="${1}" repo_dir="${2}"

  if [[ -z $repo_url || -z $repo_dir ]]; then
    error arguments error. url=$repo_url dir=$repo_dir
    return 1
  fi

  if [[ -d $repo_dir/.git ]]; then
    (debug cd $repo_dir && debug git pull)
  else
    debug git clone --depth=1 $repo_url $repo_dir
  fi
}

_setup_wayland_enviroments() {
  local packages=(sway swayr greetd greetd-tuigreet)

  if _is_arch; then
    packages+=( 
      waybar rofi-lbonn-wayland swayidle
      swaylock clipman
      xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland
      ttf-font-awesome
    )
  elif _is_ubuntu; then
    packages+=(fonts-font-awesome)
  fi

  _install_packages ${packages[@]}
  _jetbrains_mono_setup
}

_setup_gui_enviroments() {
  local packages=(
    alacritty google-chrome foot
  )

  if _is_arch; then
    packages+=( 
      tigervnc wqy-microhei gvim
      fcitx5 fcitx5-chinese-addons fcitx5-qt
      fcitx5-pinyin-zhwiki fcitx5-configtool kcm-fcitx5
      alsa-utils pulseaudio pamixer pavucontrol pulseaudio-alsa
      nutstore-experimental
      # nerd-fonts-source-code-pro
      # nerd-fonts-jetbrains-mono
    )
  elif _is_ubuntu; then
    packages+=( 
      vim-gtk{,3}
      fcitx5 fcitx5-chinese-addons
      fcitx5-frontend-gtk3 fcitx5-frontend-gtk2
      fcitx5-frontend-qt5
    )
  fi

  _install_packages ${packages[@]}
}

_setup_basic_enviroments() {
  local packages=(
    gvim tmux ctags bash-completion zsh man-db
    jq ripgrep fzf fd autojump curl
    sshuttle tree lsb_release
  )

  if _is_arch; then
    _executable yay || _yay_setup
    packages+=(mlocate unzip)
  elif _is_ubuntu; then
    packages+=(locate)
  fi

  _install_packages ${packages[@]}
}

_nltk_setup() {
  debug python3 -m nltk.downloader popular
}

_setup_python_enviroments() {
  local packages=()

  if _is_arch; then
    packages+=(pyenv python python-pip)
  elif _is_ubuntu; then
    packages+=(python)
  fi

  _install_packages ${packages[@]}

  if _executable pip; then
    local pip_packages=( 
      wordfreq nltk bs4 # basic
      pudb # python debugger
    )
    debug pip install ${pip_packages[@]}
    _nltk_setup
  fi
}

_setup_go_enviroments() {
  local packages=(protobuf)

  if _is_arch; then
    packages+=(go)
  elif _is_ubuntu; then
    packages+=(golang)
  fi

  _install_packages ${packages[@]}

  debug go env -w GOPATH=$HOME/go
  debug go env -w GOBIN=$HOME/go/bin
  debug go env -w GOPROXY=https://goproxy.cn,direct

  # setup vim.go
  local go_packages=(
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    github.com/grafana/jsonnet-language-server@latest # jsonnet language server
  )

  for pkg in ${go_packages[@]}; do
    debug go install $pkg
  done
}

_setup_rust_enviroments() {
  sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y
  rustup default nightly
  rustup component add rust-analyzer
}

_setup_node_enviroments() {
  local only_setup_node_and_yarn=${1:-false}
  local npm_packages

  _nvm_setup || (error nvm setup failed && return 0)

  debug nvm install node

  [[ $only_setup_node_and_yarn == true ]] && return 0

  debug npm install -g yarn

  npm_packages=(
    source-map-support prettier eslint ts-node
  )

  yarn global add ${npm_packages[@]}
}

_setup_chromium_development_enviroments() {
    local packages=(
      python perl gcc gcc-libs bison flex gperf
      pkgconfig nss alsa-lib glib2 gtk3 nspr 
      freetype2 cairo dbus libgnome-keyring
      xorg-server-xvfb xorg-xdpyinfo
    )
    if _is_arch; then 
      _install_packages ${packages[@]}
    else
      error unspport platform
    fi
}

_setup_c_enviroments() {
  local packages=(
    gcc llvm clang clangd gdb cgdb
  )

  if _is_arch; then
    packages+=()
  elif _is_ubuntu; then
    packages+=()
  fi

  _install_packages ${packages[@]}
}

_setup_all_languages_enviroments() {
  _setup_python_enviroments
  _setup_node_enviroments
  _setup_go_enviroments
  _setup_rust_enviroments
  _setup_c_enviroments
}

_setup_specific_language_enviroments() {
  local language=$1
  case $language in 
    all   )
      _setup_all_languages_enviroments ;;
    python|node|go|rust|c)
      eval _setup_${language}_enviroments ;;
    *     ) ;;
  esac
}

_setup_program_enviroments() {
  local languages=(all python node golang rust)
  select language in ${languages[@]}; do
    _setup_specific_language_enviroments $language
    break
  done
}

_setup_all_enviroments() {
  _update_packages_index
  _setup_basic_enviroments
  _setup_gui_enviroments
  _setup_wayland_enviroments
  _setup_chromium_development_enviroments
  _setup_all_languages_enviroments
  # _clash_setup
  _dotfiles_setup
  _doom_setup
}

_setup() {
  local action=${1:-all}
  case $action in 
    all|basic|program|gui|wayland|chromium)
      eval _setup_${action}_enviroments ;;
    doom|vim|clash|dotfiles|ohmyzsh) _${action}_setup ;;
    update-index) _update_packages_index ;;
    *     ) warn selected none ;;
  esac
}

main() {
  if [[ $# > 0 ]]; then
    _setup $@
    return
  fi
  local actions=( 
    all basic gui wayland program
    update-index doom vim clash dotfiles
    ohmyzsh
  )
  select action in ${actions[@]}; do
    _setup $action; break
  done
}

_doom_setup(){
  _install_package emacs
  local repo emacs_home remove_flag=true
  repo=$REPO_DOOM
  emacs_home=$HOME/.emacs.d

  _ensure_proxy_enabled

  [[ -d $emacs_home/.git ]] && remove_flag=false

  _ensure_directory_exists $emacs_home $remove_flag
  debug git clone --depth 1 $repo $emacs_home
  debug $emacs_home/bin/doom install
}

_vim_setup() {
  local output 
  vim_home=$HOME/.vim
  vimrc_dir=$SCRIPT_DIR/vimrc.d
  output=$vim_home/autoload/plug.vim

  # install nvm if node is not exist
  _executable node || _setup_node_enviroments true

  _ensure_proxy_enabled

  _ensure_directory_exists $vim_home
  _ensure_directory_exists $vim_home/vimrc.d

  info install vim-plug
  debug curl -fsSLo $output --create-dirs $URL_PLUG

  debug ln -fs $vimrc_dir/'*' $vim_home/vimrc.d
  debug ln -fs $vimrc_dir/.vimrc $vim_home/vimrc

  if _executable vim; then
    local nvm_dir=$(_path_relative_xdg_config_home nvm)
    source $nvm_dir/nvm.sh
    vim -c "PlugInstall" -c "qa!"
  fi
}

_jetbrains_mono_setup() {
  _ensure_proxy_enabled
  # https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/font-info.md
  setup_script="https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh"
  bash -c "$(curl -fsSL $setup_script)"
}

_clash_setup() {
  local arch url filename
  arch=$(_arch)
  platform=$(uname -s)
  # filename=clash-${platform@L}-$arch-latest.gz
  filename=clash-${platform,}-$arch-latest.gz
  url=https://release.dreamacro.workers.dev/latest/$filename

  tmpdir=$(_path_relative_xdg_config_home clash)
  tmpfile=$tmpdir/$filename

  # warn create temp directory $tmpdir
  debug curl -fsSL -o $tmpfile --create-dirs $url &&
    (debug cd $tmpdir &&
      debug gunzip -f $tmpfile &&
      debug chmod +x ${filename%.*} &&
      debug sudo install -m755 ${filename%.*} /usr/bin/clash)
  if _executable systemctl; then
    cat << EOF | sudo tee /etc/systemd/system/clash.service > /dev/null
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target network-online.target nss-lookup.target 

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/clash -d /etc/clash

[Install]
WantedBy=multi-user.target
EOF
    debug sudo systemctl daemon-reload
    debug sudo systemctl restart clash
  fi
}

_nvm_setup() {
  local nvm_dir
  nvm_dir=$(_path_relative_xdg_config_home nvm)

  if [[ $? == 0 ]]; then
    ( 
    debug git clone https://github.com/nvm-sh/nvm.git "$nvm_dir"
    cd $nvm_dir
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
    ) && source $nvm_dir/nvm.sh
  fi
}

_ohmyzsh_setup() {
  _ensure_proxy_enabled
  _install_package zsh

  declare -a args=(
    "${REPO_OHMYZSH} $HOME/.oh-my-zsh"
    "${REPO_P10K} ${ZSH_CUSTOM}/themes/powerlevel10k"
    "${REPO_ZSH_SUGGESTION} ${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    "${REPO_ZSH_LXD} ${ZSH_CUSTOM}/plugins/lxd-completion-zsh"
  )
  for arg in "${args[@]}"; do git clone --depth=1 $arg ; done
}

_yay_setup() {
  local yay_home=$HOME/.cache/yay

  _ensure_directory_exists $yay_home false

  sudo pacman -S --needed git base-devel &&
    git clone https://aur.archlinux.org/yay.git $yay_home/yay &&
      cd $yay_home/yay  && makepkg -si --noconfirm
}

_dotfiles_setup() {
  for config in ./configs/*; do
    if [ -d $config ]; then
      config=$(basename $config)
      rm -rf $(_path_relative_xdg_config_home $config)
      ln -fs $SCRIPT_DIR/configs/$config $(_path_relative_xdg_config_home $config)
    fi
  done

  local ohmyzsh_home=$HOME/.oh-my-zsh
  _ensure_directory_exists $ohmyzsh_home false

  if [[ ! -d $ohmyzsh_home ]]; then
    _ohmyzsh_setup
  fi

  debug ln -fs $SCRIPT_DIR/zsh/zshrc.zsh $HOME/.zshrc
  debug ln -fs $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf

  debug source $SCRIPT_DIR/init-git.sh
}

main ${@:1}
