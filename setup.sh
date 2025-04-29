#!/usr/bin/env bash

# 开发环境配置脚本
# 版本: 1.0.0
# 作者: Your Name
# 用途: 自动化设置开发环境、工具、语言环境等

# 使用方法：
#   ./setup.sh [选项]
#
# 选项:
#   all         安装所有环境和工具
#   basic       只安装基本环境
#   program     安装编程语言环境
#   gui         安装图形界面工具
#   wayland     安装Wayland环境
#   chromium    安装Chromium开发环境
#   doom        安装Doom Emacs
#   vim         安装Vim配置
#   clash       安装Clash代理
#   dotfiles    设置dotfiles配置文件
#   ohmyzsh     安装Oh My Zsh
#   update-index 更新软件包索引

# 启用错误处理
set -e          # 命令返回非零状态时立即退出
set -u          # 使用未定义的变量时报错
set -o pipefail # 管道中任一命令失败则整个管道视为失败

# 启用调试日志
DEBUG_ENABLE=1

# 记录当前脚本目录的绝对路径
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

# 配置文件与路径
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
VIM_HOME="$HOME/.vim"
EMACS_HOME="$HOME/.emacs.d"
OHMYZSH_HOME="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OHMYZSH_HOME/custom}"
NVM_HOME="$CONFIG_HOME/nvm"

# 仓库地址
REPO_OHMYZSH="https://github.com/ohmyzsh/ohmyzsh"
REPO_DOOM="https://github.com/hlissner/doom-emacs"
REPO_P10K="https://github.com/romkatv/powerlevel10k.git"
REPO_ZSH_SUGGESTION="https://github.com/zsh-users/zsh-autosuggestions"
REPO_ZSH_LXD="https://github.com/endaaman/lxd-completion-zsh"
URL_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

_path_relative_xdg_config_home() {
  echo "$CONFIG_HOME/$1"
}

_path_relative_script_home() {
  echo "$SCRIPT_DIR/$1"
}

_ensure_directory_exists() {
  local dir="$1" remove_flag=${2:-true}

  if [[ -z "$dir" || "$dir" == "/" ]]; then
    error "Cannot create root or empty directory"
    return 1
  fi

  if [[ "$remove_flag" == true && -d "$dir" ]]; then 
    debug_log "Removing existing directory: $dir"
    rm -rf "$dir" || return 1
  fi
  
  if [[ ! -d "$dir" ]]; then
    debug_log "Creating directory: $dir"
    mkdir -p "$dir" || return 1
  fi
  
  return 0
}

_ensure_proxy_enabled() {
  local default_proxy='http://127.0.0.1:7890'
  local prompt="Use proxy (default $default_proxy): "
  
  if [[ -z "${HTTP_PROXY:-}" || -z "${HTTPS_PROXY:-}" ]]; then
    info "Network proxy not set, please specify proxy address"
    read -rep "${prompt}" proxy
    proxy="${proxy:-$default_proxy}"
    
    export HTTP_PROXY="$proxy"
    export HTTPS_PROXY="$proxy"
    export http_proxy="$proxy"
    export https_proxy="$proxy"
    
    info "Proxy set: $proxy"
  else
    debug_log "Network proxy already set: HTTP_PROXY=$HTTP_PROXY, HTTPS_PROXY=$HTTPS_PROXY"
  fi
}

ERROR='\033[0;31m'
INFO='\033[0;32m'
WARN='\033[0;33m'
DEBUG='\033[0;34m'
END='\033[0m'

# 定义日志函数
warn() { echo -e ${WARN}[WARN] "$@"$END; }
info() { echo -e ${INFO}[INFO] "$@"$END; }
error() { echo -e ${ERROR}[ERROR] "$@"$END; }
debug_log() { [[ -n $DEBUG_ENABLE ]] && echo -e ${DEBUG}[DEBUG] "$@"${END}; }

# 创建临时目录
TMP_DIR=$(mktemp -d)
debug_log "Created temporary directory: $TMP_DIR"

# 在脚本退出时执行清理
cleanup() {
  local exit_code=$?
  debug_log "Performing cleanup..."
  
  # 删除临时目录
  if [[ -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
    debug_log "Removed temporary directory: $TMP_DIR"
  fi
  
  # 根据退出码显示完成消息
  if [[ $exit_code -eq 0 ]]; then
    info "Script execution completed"
  else
    error "Script execution failed, exit code: $exit_code"
  fi
  
  exit $exit_code
}

# 处理中断信号
handle_interrupt() {
  error "Interrupt signal received, terminating script"
  exit 130
}

# 注册清理和中断处理函数
trap cleanup EXIT
trap handle_interrupt INT

# 执行命令，支持超时和重试
run_cmd() { 
  local timeout=300  # 默认超时时间，秒
  local retries=1    # 默认重试次数
  local cmd=()
  local i=0
  
  # 解析参数
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --timeout=*)
        timeout="${1#*=}"
        shift
        ;;
      --retries=*)
        retries="${1#*=}"
        shift
        ;;
      *)
        cmd+=("$1")
        shift
        ;;
    esac
  done
  
  debug_log "Executing command: ${cmd[*]}"
  
  # 重试机制
  for ((i=0; i<retries; i++)); do
    if [[ $i -gt 0 ]]; then
      warn "Command failed, retrying ($i/$retries)..."
      sleep 2
    fi
    
    # 使用timeout命令设置超时
    if _executable timeout; then
      if timeout "$timeout" "${cmd[@]}"; then
        return 0
      fi
    else
      # 如果timeout命令不可用，直接执行
      if "${cmd[@]}"; then
        return 0
      fi
    fi
  done
  
  error "Command execution failed: ${cmd[*]}"
  return 1
}

_executable() {
  local cmd=$1
  which $cmd &> /dev/null
}

_is_ubuntu() { [[ "$(lsb_release -is)" =~ "Ubuntu" ]]; }
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
    run_cmd yay -S --needed --noconfirm $package
  elif _executable pacman; then
    run_cmd sudo pacman -S --needed --noconfirm $package
  elif _executable apt; then
    run_cmd sudo apt install $package
  fi
}

_install_packages() {
  _executable sudo || (error "sudo isn't installed" && return 1)

  if _executable yay || _executable pacman; then
    for pkg in $@; do _install_package $pkg; done
  elif _executable apt; then
    run_cmd sudo apt install -y $@
  fi
}

_update_packages_index() {
  if _executable yay; then
    run_cmd yay -Syu
  elif _executable pacman; then
    run_cmd sudo pacman -Syu
  elif _executable apt; then
    run_cmd sudo apt update
  fi
}

_git_clone_or_pull() {
  local repo_url="${1}" repo_dir="${2}"

  if [[ -z $repo_url || -z $repo_dir ]]; then
    error arguments error. url=$repo_url dir=$repo_dir
    return 1
  fi

  if [[ -d $repo_dir/.git ]]; then
    (cd "$repo_dir" && run_cmd git pull)
  else
    run_cmd git clone --depth=1 "$repo_url" "$repo_dir"
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
  run_cmd python3 -m nltk.downloader popular
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
    run_cmd pip install ${pip_packages[@]}
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

  run_cmd go env -w GOPATH=$HOME/go
  run_cmd go env -w GOBIN=$HOME/go/bin
  run_cmd go env -w GOPROXY=https://goproxy.cn,direct

  # setup vim.go
  local go_packages=(
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    github.com/grafana/jsonnet-language-server@latest # jsonnet language server
  )

  for pkg in ${go_packages[@]}; do
    run_cmd go install $pkg
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

  run_cmd nvm install node

  [[ $only_setup_node_and_yarn == true ]] && return 0

  run_cmd npm install -g yarn

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
  # 检查基本依赖
  _check_dependencies
  
  if [[ $# > 0 ]]; then
    _setup $@
    return
  fi
  
  # 显示菜单
  _show_menu
}

# 显示菜单界面
_show_menu() {
  clear
  echo -e "${INFO}====================================${END}"
  echo -e "${INFO}  Development Environment Setup Tool v1.0.0 ${END}"
  echo -e "${INFO}====================================${END}"
  echo ""
  echo "Please select an operation:"
  echo ""
  echo "Environment Installation:"
  echo "  1) Install all components (recommended)"
  echo "  2) Install basic environment only"
  echo "  3) Install programming language environments"
  echo "  4) Install GUI tools"
  echo "  5) Install Wayland environment"
  echo "  6) Install Chromium development environment"
  echo ""
  echo "Tool Configuration:"
  echo "  7) Install Doom Emacs"
  echo "  8) Install Vim configuration"
  echo "  9) Install Clash proxy"
  echo " 10) Install dotfiles"
  echo " 11) Install Oh My Zsh"
  echo ""
  echo "System Management:"
  echo " 12) Update package index"
  echo " 13) Exit"
  echo ""
  
  local choice
  read -rep "Enter your choice [1-13]: " choice
  
  case $choice in
    1)  _setup all ;;
    2)  _setup basic ;;
    3)  _setup program ;;
    4)  _setup gui ;;
    5)  _setup wayland ;;
    6)  _setup chromium ;;
    7)  _setup doom ;;
    8)  _setup vim ;;
    9)  _setup clash ;;
    10) _setup dotfiles ;;
    11) _setup ohmyzsh ;;
    12) _setup update-index ;;
    13) echo "Exiting script"; exit 0 ;;
    *)  warn "Invalid option, please try again"; sleep 2; _show_menu ;;
  esac
  
  # 操作完成后询问是否继续
  echo ""
  read -rep "Operation completed. Return to main menu? [Y/n] " continue
  [[ ${continue,,} != "n" ]] && _show_menu || echo "Exited"
}

# 检查必要的依赖是否已安装
_check_dependencies() {
  local missing_deps=()
  local essential_cmds=(git curl bash)
  
  for cmd in "${essential_cmds[@]}"; do
    if ! _executable "$cmd"; then
      missing_deps+=("$cmd")
    fi
  done
  
  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    error "Missing required dependencies: ${missing_deps[*]}"
    info "Please install these dependencies first, then run this script again"
    exit 1
  fi
  
  debug_log "Basic dependency check passed"
}

_doom_setup(){
  _install_package emacs
  local repo emacs_home remove_flag=true
  repo=$REPO_DOOM
  emacs_home=$HOME/.emacs.d

  _ensure_proxy_enabled

  [[ -d $emacs_home/.git ]] && remove_flag=false

  _ensure_directory_exists $emacs_home $remove_flag
  run_cmd git clone --depth 1 $repo $emacs_home
  run_cmd $emacs_home/bin/doom install
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
  run_cmd curl -fsSLo $output --create-dirs $URL_PLUG

  run_cmd ln -fs $vimrc_dir/'*' $vim_home/vimrc.d
  run_cmd ln -fs $vimrc_dir/.vimrc $vim_home/vimrc

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
  run_cmd curl -fsSL -o $tmpfile --create-dirs $url &&
    (cd $tmpdir &&
      run_cmd gunzip -f $tmpfile &&
      run_cmd chmod +x ${filename%.*} &&
      run_cmd sudo install -m755 ${filename%.*} /usr/bin/clash)
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
    run_cmd sudo systemctl daemon-reload
    run_cmd sudo systemctl restart clash
  fi
}

_nvm_setup() {
  local nvm_dir
  nvm_dir=$(_path_relative_xdg_config_home nvm)

  if [[ $? == 0 ]]; then
    ( 
    run_cmd git clone https://github.com/nvm-sh/nvm.git "$nvm_dir"
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
  debug_log "Setting up dotfiles..."
  local backup_dir="$HOME/.config_backups/$(date +%Y%m%d_%H%M%S)"
  
  # 创建备份目录
  _ensure_directory_exists "$backup_dir" false
  info "Will create configuration backups in $backup_dir"

  # 设置配置文件，备份现有的配置
  for config in ./configs/*; do
    if [ -d "$config" ]; then
      config=$(basename "$config")
      local target_path="$(_path_relative_xdg_config_home "$config")"
      
      # 备份现有配置
      if [ -d "$target_path" ] && [ ! -L "$target_path" ]; then
        local backup_path="$backup_dir/$config"
        info "Backing up existing config: $target_path → $backup_path"
        cp -a "$target_path" "$backup_path"
      fi
      
      # 创建链接
      rm -rf "$target_path"
      ln -fs "$SCRIPT_DIR/configs/$config" "$target_path"
      info "Linked configuration: $config"
    fi
  done

  local ohmyzsh_home=$HOME/.oh-my-zsh
  _ensure_directory_exists $ohmyzsh_home false

  if [[ ! -d $ohmyzsh_home ]]; then
    _ohmyzsh_setup
  fi

  # 备份 zshrc 和 tmux.conf
  for f in "$HOME/.zshrc" "$HOME/.tmux.conf"; do
    if [ -f "$f" ] && [ ! -L "$f" ]; then
      local fname=$(basename "$f")
      cp -a "$f" "$backup_dir/$fname"
      info "Backed up: $f → $backup_dir/$fname"
    fi
  done

  run_cmd ln -fs $SCRIPT_DIR/zsh/zshrc.zsh $HOME/.zshrc
  run_cmd ln -fs $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf

  run_cmd source $SCRIPT_DIR/init-git.sh
  
  info "Dotfiles setup completed"
}

main ${@:1}
