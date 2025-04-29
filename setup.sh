#!/usr/bin/env bash
#
# Development environment setup script.
#
# This script automates the setup of various development environments including:
# - Basic environment tools (vim, tmux, git, etc.)
# - Programming language environments (Python, Node.js, Go, Rust, C)
# - GUI tools and Wayland environment
# - Chromium development environment
# - Configuration files and dotfiles
#
# Usage:
#   ./setup.sh [OPTION]
#
# Options:
#   all         Install all components (recommended)
#   basic       Install basic environment only
#   program     Install programming language environments
#   gui         Install GUI tools
#   wayland     Install Wayland environment
#   chromium    Install Chromium development environment
#   doom        Install Doom Emacs
#   vim         Install Vim configuration
#   clash       Install Clash proxy
#   dotfiles    Set up dotfiles
#   ohmyzsh     Install Oh My Zsh
#   update-index Update package index
#
# Examples:
#   ./setup.sh basic      # Install basic environment only
#   ./setup.sh all        # Install all components
#   ./setup.sh dotfiles   # Set up dotfiles only
#
# Author: Lee (loyalpartner@163.com)
# Version: 1.0.1
#
# shellcheck disable=SC1090,SC2059,SC2034

# Enable error handling
set -e          # Exit immediately if a command exits with a non-zero status
set -u          # Treat unset variables as an error
set -o pipefail # Pipeline fails on first command failure

# Enable debug logging
readonly DEBUG_ENABLE=1

# Script location and paths
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Configuration paths
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly VIM_HOME="$HOME/.vim"
readonly EMACS_HOME="$HOME/.emacs.d"
readonly OHMYZSH_HOME="$HOME/.oh-my-zsh"
readonly ZSH_CUSTOM="${ZSH_CUSTOM:-$OHMYZSH_HOME/custom}"
readonly NVM_HOME="$CONFIG_HOME/nvm"

# Repository URLs
readonly REPO_OHMYZSH="https://github.com/ohmyzsh/ohmyzsh"
readonly REPO_DOOM="https://github.com/hlissner/doom-emacs"
readonly REPO_P10K="https://github.com/romkatv/powerlevel10k.git"
readonly REPO_ZSH_SUGGESTION="https://github.com/zsh-users/zsh-autosuggestions"
readonly REPO_ZSH_LXD="https://github.com/endaaman/lxd-completion-zsh"
readonly URL_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Color definitions for output formatting
readonly COLOR_ERROR='\033[0;31m'
readonly COLOR_INFO='\033[0;32m'
readonly COLOR_WARN='\033[0;33m'
readonly COLOR_DEBUG='\033[0;34m'
readonly COLOR_RESET='\033[0m'

# Create temporary directory
readonly TMP_DIR=$(mktemp -d)

#######################################
# Log a warning message to stderr
# Arguments:
#   Message text
#######################################
warn() { 
  echo -e "${COLOR_WARN}[WARN] $*${COLOR_RESET}" >&2
}

#######################################
# Log an informational message
# Arguments:
#   Message text
#######################################
info() { 
  echo -e "${COLOR_INFO}[INFO] $*${COLOR_RESET}"
}

#######################################
# Log an error message to stderr
# Arguments:
#   Message text
#######################################
error() { 
  echo -e "${COLOR_ERROR}[ERROR] $*${COLOR_RESET}" >&2
}

#######################################
# Log a debug message if debug is enabled
# Arguments:
#   Message text
#######################################
debug_log() { 
  [[ -n $DEBUG_ENABLE ]] && echo -e "${COLOR_DEBUG}[DEBUG] $*${COLOR_RESET}"
}

#######################################
# Execute a command with logging
# Arguments:
#   Command and its arguments
# Returns:
#   Command exit status
#######################################
run_cmd() {
  debug_log "Executing command: $*"
  if [[ -n $DEBUG_ENABLE ]]; then
    "$@"
  else
    "$@" >/dev/null 2>&1
  fi
  return $?
}

#######################################
# Cleanup function called on script exit
# Arguments:
#   None
#######################################
cleanup() {
  local exit_code=$?
  debug_log "Performing cleanup..."
  
  # Remove temporary directory
  if [[ -d "$TMP_DIR" ]]; then
    rm -rf "$TMP_DIR"
    debug_log "Removed temporary directory: $TMP_DIR"
  fi
  
  # Show completion message based on exit code
  if [[ $exit_code -eq 0 ]]; then
    info "Script execution completed"
  else
    error "Script execution failed, exit code: $exit_code"
  fi
  
  exit $exit_code
}

#######################################
# Handle interrupt signals
# Arguments:
#   None
#######################################
handle_interrupt() {
  error "Interrupt signal received, terminating script"
  exit 130
}

# Register cleanup and interrupt handlers
trap cleanup EXIT
trap handle_interrupt INT

debug_log "Created temporary directory: $TMP_DIR"

#######################################
# Check if a command is available
# Arguments:
#   Command name
# Returns:
#   0 if command exists, 1 otherwise
#######################################
is_executable() {
  local cmd="$1"
  command -v "$cmd" &> /dev/null
}

#######################################
# Check if running on Ubuntu
# Returns:
#   0 if Ubuntu, 1 otherwise
#######################################
is_ubuntu() { 
  [[ "$(lsb_release -is 2>/dev/null)" =~ "Ubuntu" ]]
}

#######################################
# Check if running on Arch Linux
# Returns:
#   0 if Arch, 1 otherwise
#######################################
is_arch() { 
  [[ "$(lsb_release -is 2>/dev/null)" =~ "Arch" ]]
}

#######################################
# Get system architecture
# Returns:
#   Architecture string (386, amd64, arm, arm64)
#######################################
get_arch() {
  local architecture=""
  case $(uname -m) in
    i386)   architecture="386" ;;
    i686)   architecture="386" ;;
    x86_64) architecture="amd64" ;;
    arm)    dpkg --print-architecture 2>/dev/null | grep -q "arm64" && 
             architecture="arm64" || architecture="arm" ;;
  esac
  echo "$architecture"
}

#######################################
# Get path relative to XDG config home
# Arguments:
#   Path component to append
# Returns:
#   Full path
#######################################
get_config_path() {
  echo "$CONFIG_HOME/$1"
}

#######################################
# Get path relative to script directory
# Arguments:
#   Path component to append
# Returns:
#   Full path
#######################################
get_script_path() {
  echo "$SCRIPT_DIR/$1"
}

#######################################
# Ensure directory exists, optionally removing it first
# Arguments:
#   Directory path
#   Remove flag (true/false, defaults to true)
# Returns:
#   0 on success, 1 on failure
#######################################
ensure_directory() {
  local dir="$1" 
  local remove_flag=${2:-true}

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

#######################################
# Set up proxy environment variables
# Arguments:
#   None
#######################################
ensure_proxy_enabled() {
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

#######################################
# Install a single package using available package manager
# Arguments:
#   Package name
# Returns:
#   0 on success, 1 on failure
#######################################
install_package() {
  if ! is_executable sudo; then
    error "sudo isn't installed"
    return 1
  fi

  local package="$1"

  if is_executable yay; then
    run_cmd yay -S --needed --noconfirm "$package"
  elif is_executable pacman; then
    run_cmd sudo pacman -S --needed --noconfirm "$package"
  elif is_executable apt; then
    run_cmd sudo apt install "$package"
  else
    error "No supported package manager found"
    return 1
  fi
}

#######################################
# Install multiple packages
# Arguments:
#   Package names
# Returns:
#   0 on success, 1 on failure
#######################################
install_packages() {
  if ! is_executable sudo; then
    error "sudo isn't installed"
    return 1
  fi

  if is_executable yay || is_executable pacman; then
    for pkg in "$@"; do 
      install_package "$pkg"
    done
  elif is_executable apt; then
    run_cmd sudo apt install -y "$@"
  else
    error "No supported package manager found"
    return 1
  fi
}

#######################################
# Update package index
# Arguments:
#   None
# Returns:
#   0 on success, 1 on failure
#######################################
update_packages_index() {
  if is_executable yay; then
    run_cmd yay -Syu
  elif is_executable pacman; then
    run_cmd sudo pacman -Syu
  elif is_executable apt; then
    run_cmd sudo apt update
  else
    error "No supported package manager found"
    return 1
  fi
}

#######################################
# Clone or pull a git repository
# Arguments:
#   Repository URL
#   Target directory
# Returns:
#   0 on success, 1 on failure
#######################################
git_clone_or_pull() {
  local repo_url="$1" repo_dir="$2"

  if [[ -z "$repo_url" || -z "$repo_dir" ]]; then
    error "Missing arguments. URL=$repo_url, Dir=$repo_dir"
    return 1
  fi

  if [[ -d "$repo_dir/.git" ]]; then
    (cd "$repo_dir" && run_cmd git pull)
  else
    run_cmd git clone --depth=1 "$repo_url" "$repo_dir"
  fi
}

#######################################
# Set up Wayland environment
# Arguments:
#   None
#######################################
setup_wayland_environments() {
  local packages=(sway swayr greetd greetd-tuigreet)

  if is_arch; then
    packages+=( 
      waybar rofi-lbonn-wayland swayidle
      swaylock clipman
      xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland
      ttf-font-awesome
    )
  elif is_ubuntu; then
    packages+=(fonts-font-awesome)
  fi

  install_packages "${packages[@]}"
  setup_jetbrains_mono
}

#######################################
# Set up GUI environment
# Arguments:
#   None
#######################################
setup_gui_environments() {
  local packages=(
    alacritty google-chrome foot
  )

  if is_arch; then
    packages+=( 
      tigervnc wqy-microhei gvim
      fcitx5 fcitx5-chinese-addons fcitx5-qt
      fcitx5-pinyin-zhwiki fcitx5-configtool kcm-fcitx5
      alsa-utils pulseaudio pamixer pavucontrol pulseaudio-alsa
      nutstore-experimental
      # nerd-fonts-source-code-pro
      # nerd-fonts-jetbrains-mono
    )
  elif is_ubuntu; then
    packages+=( 
      vim-gtk{,3}
      fcitx5 fcitx5-chinese-addons
      fcitx5-frontend-gtk3 fcitx5-frontend-gtk2
      fcitx5-frontend-qt5
    )
  fi

  install_packages "${packages[@]}"
}

#######################################
# Set up basic environment
# Arguments:
#   None
#######################################
setup_basic_environments() {
  local packages=(
    gvim tmux ctags bash-completion zsh man-db
    jq ripgrep fzf fd autojump curl
    sshuttle tree lsb_release
  )

  if is_arch; then
    is_executable yay || setup_yay
    packages+=(mlocate unzip)
  elif is_ubuntu; then
    packages+=(locate)
  fi

  install_packages "${packages[@]}"
}

#######################################
# Setup NLTK Python package
# Arguments:
#   None
#######################################
setup_nltk() {
  run_cmd python3 -m nltk.downloader popular
}

#######################################
# Set up Python environment
# Arguments:
#   None
#######################################
setup_python_environments() {
  local packages=()

  if is_arch; then
    packages+=(pyenv python python-pip)
  elif is_ubuntu; then
    packages+=(python)
  fi

  install_packages "${packages[@]}"

  if is_executable pip; then
    local pip_packages=( 
      wordfreq nltk bs4 # basic
      pudb # python debugger
    )
    run_cmd pip install "${pip_packages[@]}"
    setup_nltk
  fi
}

#######################################
# Set up Go environment
# Arguments:
#   None
#######################################
setup_go_environments() {
  local packages=(protobuf)

  if is_arch; then
    packages+=(go)
  elif is_ubuntu; then
    packages+=(golang)
  fi

  install_packages "${packages[@]}"

  run_cmd go env -w GOPATH=$HOME/go
  run_cmd go env -w GOBIN=$HOME/go/bin
  run_cmd go env -w GOPROXY=https://goproxy.cn,direct

  # Setup vim.go packages
  local go_packages=(
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    github.com/grafana/jsonnet-language-server@latest # jsonnet language server
  )

  for pkg in "${go_packages[@]}"; do
    run_cmd go install "$pkg"
  done
}

#######################################
# Set up Rust environment
# Arguments:
#   None
#######################################
setup_rust_environments() {
  sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y
  rustup default nightly
  rustup component add rust-analyzer
}

#######################################
# Set up Node.js environment
# Arguments:
#   only_setup_node_and_yarn - whether to only set up node and yarn (default: false)
#######################################
setup_node_environments() {
  local only_setup_node_and_yarn=${1:-false}
  local npm_packages

  setup_nvm || { error "NVM setup failed"; return 0; }

  run_cmd nvm install node

  [[ $only_setup_node_and_yarn == true ]] && return 0

  run_cmd npm install -g yarn

  npm_packages=(
    source-map-support prettier eslint ts-node
  )

  yarn global add "${npm_packages[@]}"
}

#######################################
# Set up Chromium development environment
# Arguments:
#   None
#######################################
setup_chromium_development_environments() {
  local packages=(
    python perl gcc gcc-libs bison flex gperf
    pkgconfig nss alsa-lib glib2 gtk3 nspr 
    freetype2 cairo dbus libgnome-keyring
    xorg-server-xvfb xorg-xdpyinfo
  )
  if is_arch; then 
    install_packages "${packages[@]}"
  else
    error "Unsupported platform"
    return 1
  fi
}

#######################################
# Set up C development environment
# Arguments:
#   None
#######################################
setup_c_environments() {
  local packages=(
    gcc llvm clang clangd gdb cgdb
  )

  # Add platform-specific packages
  if is_arch; then
    packages+=()
  elif is_ubuntu; then
    packages+=()
  fi

  install_packages "${packages[@]}"
}

#######################################
# Set up all programming languages environments
# Arguments:
#   None
#######################################
setup_all_languages_environments() {
  setup_python_environments
  setup_node_environments
  setup_go_environments
  setup_rust_environments
  setup_c_environments
}

#######################################
# Set up a specific language environment
# Arguments:
#   Language name (all, python, node, go, rust, c)
#######################################
setup_specific_language_environments() {
  local language="$1"
  case $language in 
    all)
      setup_all_languages_environments ;;
    python|node|go|rust|c)
      eval "setup_${language}_environments" ;;
    *)
      warn "Unknown language: $language" ;;
  esac
}

#######################################
# Interactive menu for programming environments
# Arguments:
#   None
#######################################
setup_program_environments() {
  local languages=(all python node golang rust)
  select language in "${languages[@]}"; do
    setup_specific_language_environments "$language"
    break
  done
}

#######################################
# Set up all environments
# Arguments:
#   None
#######################################
setup_all_environments() {
  update_packages_index
  setup_basic_environments
  setup_gui_environments
  setup_wayland_environments
  setup_chromium_development_environments
  setup_all_languages_environments
  # setup_clash
  setup_dotfiles
  setup_doom
}

#######################################
# Set up various components based on argument
# Arguments:
#   Component to set up
#######################################
setup() {
  local action=${1:-all}
  case $action in 
    all|basic|program|gui|wayland|chromium)
      eval "setup_${action}_environments" ;;
    doom|vim|clash|dotfiles|ohmyzsh) 
      eval "setup_${action}" ;;
    update-index) 
      update_packages_index ;;
    *) 
      warn "Unknown action: $action" ;;
  esac
}

#######################################
# Set up Doom Emacs
# Arguments:
#   None
#######################################
setup_doom() {
  install_package emacs
  local repo="$REPO_DOOM"
  local emacs_home="$EMACS_HOME"
  local remove_flag=true

  ensure_proxy_enabled

  [[ -d "$emacs_home/.git" ]] && remove_flag=false

  ensure_directory "$emacs_home" "$remove_flag"
  run_cmd git clone --depth 1 "$repo" "$emacs_home"
  run_cmd "$emacs_home/bin/doom" install
}

#######################################
# Set up Vim configuration
# Arguments:
#   None
#######################################
setup_vim() {
  local output 
  local vim_home="$VIM_HOME"
  local vimrc_dir="$SCRIPT_DIR/vimrc.d"
  output="$vim_home/autoload/plug.vim"

  # Install NVM if Node.js is not installed
  is_executable node || setup_node_environments true

  ensure_proxy_enabled

  ensure_directory "$vim_home"
  ensure_directory "$vim_home/vimrc.d"

  info "Installing vim-plug"
  run_cmd curl -fsSLo "$output" --create-dirs "$URL_PLUG"

  run_cmd ln -fs "$vimrc_dir/*" "$vim_home/vimrc.d"
  run_cmd ln -fs "$vimrc_dir/.vimrc" "$vim_home/vimrc"

  if is_executable vim; then
    local nvm_dir="$(get_config_path nvm)"
    source "$nvm_dir/nvm.sh"
    vim -c "PlugInstall" -c "qa!"
  fi
}

#######################################
# Set up JetBrains Mono font
# Arguments:
#   None
#######################################
setup_jetbrains_mono() {
  ensure_proxy_enabled
  # https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/font-info.md
  local setup_script="https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh"
  bash -c "$(curl -fsSL "$setup_script")"
}

#######################################
# Set up Clash proxy
# Arguments:
#   None
#######################################
setup_clash() {
  local arch=$(get_arch)
  local platform=$(uname -s)
  local filename="clash-${platform,}-$arch-latest.gz"
  local url="https://release.dreamacro.workers.dev/latest/$filename"

  local tmpdir="$(get_config_path clash)"
  local tmpfile="$tmpdir/$filename"

  run_cmd curl -fsSL -o "$tmpfile" --create-dirs "$url" &&
    (cd "$tmpdir" &&
      run_cmd gunzip -f "$tmpfile" &&
      run_cmd chmod +x "${filename%.*}" &&
      run_cmd sudo install -m755 "${filename%.*}" /usr/bin/clash)
      
  if is_executable systemctl; then
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

#######################################
# Set up NVM (Node Version Manager)
# Arguments:
#   None
# Returns:
#   0 on success, non-zero on failure
#######################################
setup_nvm() {
  local nvm_dir="$(get_config_path nvm)"

  if [[ $? -eq 0 ]]; then
    ( 
      run_cmd git clone https://github.com/nvm-sh/nvm.git "$nvm_dir"
      cd "$nvm_dir"
      git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)")"
    ) && source "$nvm_dir/nvm.sh"
  fi
}

#######################################
# Set up Oh My Zsh
# Arguments:
#   None
#######################################
setup_ohmyzsh() {
  ensure_proxy_enabled
  install_package zsh

  declare -a repos=(
    "${REPO_OHMYZSH} $HOME/.oh-my-zsh"
    "${REPO_P10K} ${ZSH_CUSTOM}/themes/powerlevel10k"
    "${REPO_ZSH_SUGGESTION} ${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
    "${REPO_ZSH_LXD} ${ZSH_CUSTOM}/plugins/lxd-completion-zsh"
  )
  
  for repo in "${repos[@]}"; do 
    git clone --depth=1 $repo
  done
}

#######################################
# Set up Yay AUR helper
# Arguments:
#   None
#######################################
setup_yay() {
  local yay_home="$HOME/.cache/yay"

  ensure_directory "$yay_home" false

  sudo pacman -S --needed git base-devel &&
    git clone https://aur.archlinux.org/yay.git "$yay_home/yay" &&
      cd "$yay_home/yay" && makepkg -si --noconfirm
}

#######################################
# Set up dotfiles
# Arguments:
#   None
#######################################
setup_dotfiles() {
  debug_log "Setting up dotfiles..."
  local backup_dir="$HOME/.config_backups/$(date +%Y%m%d_%H%M%S)"
  
  # Create backup directory
  ensure_directory "$backup_dir" false
  info "Will create configuration backups in $backup_dir"

  # Set up configs, backup existing ones
  for config in ./configs/*; do
    if [[ -d "$config" ]]; then
      config=$(basename "$config")
      local target_path="$(get_config_path "$config")"
      
      # Backup existing config
      if [[ -d "$target_path" && ! -L "$target_path" ]]; then
        local backup_path="$backup_dir/$config"
        info "Backing up existing config: $target_path → $backup_path"
        cp -a "$target_path" "$backup_path"
      fi
      
      # Create symlink
      rm -rf "$target_path"
      ln -fs "$SCRIPT_DIR/configs/$config" "$target_path"
      info "Linked configuration: $config"
    fi
  done

  local ohmyzsh_home="$OHMYZSH_HOME"
  ensure_directory "$ohmyzsh_home" false

  if [[ ! -d "$ohmyzsh_home" ]]; then
    setup_ohmyzsh
  fi

  # Backup zshrc and tmux.conf
  for f in "$HOME/.zshrc" "$HOME/.tmux.conf"; do
    if [[ -f "$f" && ! -L "$f" ]]; then
      local fname=$(basename "$f")
      cp -a "$f" "$backup_dir/$fname"
      info "Backed up: $f → $backup_dir/$fname"
    fi
  done

  run_cmd ln -fs "$SCRIPT_DIR/zsh/zshrc.zsh" "$HOME/.zshrc"
  run_cmd ln -fs "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"

  run_cmd source "$SCRIPT_DIR/init-git.sh"
  
  info "Dotfiles setup completed"
}

#######################################
# Display interactive menu
# Arguments:
#   None
#######################################
show_menu() {
  clear
  echo -e "${COLOR_INFO}====================================${COLOR_RESET}"
  echo -e "${COLOR_INFO}  Development Environment Setup Tool v1.0.1 ${COLOR_RESET}"
  echo -e "${COLOR_INFO}====================================${COLOR_RESET}"
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
    1)  setup all ;;
    2)  setup basic ;;
    3)  setup program ;;
    4)  setup gui ;;
    5)  setup wayland ;;
    6)  setup chromium ;;
    7)  setup doom ;;
    8)  setup vim ;;
    9)  setup clash ;;
    10) setup dotfiles ;;
    11) setup ohmyzsh ;;
    12) setup update-index ;;
    13) echo "Exiting script"; exit 0 ;;
    *)  warn "Invalid option, please try again"; sleep 2; show_menu ;;
  esac
  
  # Ask to continue after operation
  echo ""
  read -rep "Operation completed. Return to main menu? [Y/n] " continue
  [[ ${continue,,} != "n" ]] && show_menu || echo "Exited"
}

#######################################
# Check for dependencies before running
# Arguments:
#   None
#######################################
check_dependencies() {
  local missing_deps=()
  local essential_cmds=(git curl bash)
  
  for cmd in "${essential_cmds[@]}"; do
    if ! is_executable "$cmd"; then
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

#######################################
# Main function - entry point
# Arguments:
#   Command line arguments
#######################################
main() {
  # Check dependencies
  check_dependencies
  
  # Process args or show menu
  if [[ $# -gt 0 ]]; then
    setup "$@"
    return
  fi
  
  # Display menu
  show_menu
}

# Run main with all arguments
main "$@"