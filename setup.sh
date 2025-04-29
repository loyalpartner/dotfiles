#!/usr/bin/env bash
#
# Development Environment Setup Script
# ==================================
#
# A comprehensive setup script for development environments on macOS and Linux.
# This script handles the installation and configuration of various development
# tools, programming languages, and utilities.
#
# Features:
# ---------
# - Cross-platform support (macOS and Linux)
# - Modular installation options
# - Extensive error handling and logging
# - XDG Base Directory compliance
# - Automatic backup of existing configurations
# - System-specific optimizations
#
# Usage:
# ------
#   ./setup.sh [OPTIONS] COMMAND
#
# Commands:
#   all         Install everything (recommended for new systems)
#   basic       Install basic development tools
#   gui         Install GUI applications
#   program     Install programming languages
#   vim         Configure Vim editor
#
# Options:
#   -h, --help     Show this help message
#   -v, --verbose  Enable verbose output
#   -f, --force    Force installation
#   -n, --dry-run  Show what would be done
#   --config FILE  Use custom config file
#
# Configuration:
# -------------
# The script can be configured via ~/.config/dotfiles/setup.conf
# See the README.md for detailed configuration options.
#
# Log Files:
# ----------
# - Logs are stored in ~/.local/state/dotfiles/logs/
# - Log rotation is automatic (keeps last 5 logs)
# - Old logs are compressed after 7 days
#
# Dependencies:
# ------------
# - bash 4.0+ (macOS users might need to upgrade)
# - curl or wget
# - git
# - sudo (for system package installation)
#
# Platform-Specific Notes:
# ----------------------
# macOS:
#   - Installs and uses Homebrew
#   - Installs GNU utilities
#   - Configures macOS-specific GUI apps
#
# Linux:
#   - Supports apt and pacman
#   - Configures Wayland/X11 environments
#   - Sets up input methods
#
# Security:
# ---------
# - Downloads are verified when possible
# - Configurations are backed up before modification
# - Permissions are preserved during installation
#
# Return Codes:
# ------------
#   0: Success
#   1: General error
#   2: Invalid argument
#   3: Permission denied
#   4: Required tool missing
#
# Author: Lee (loyalpartner@163.com)
# Version: 2.0.0
# License: MIT
# Repository: https://github.com/loyalpartner/dotfiles
#
# For complete documentation, see: https://github.com/loyalpartner/dotfiles/README.md

# Enable strict mode
set -euo pipefail
[[ "${TRACE:-0}" == "1" ]] && set -x

# Script constants
readonly SCRIPT_VERSION="2.0.0"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly START_TIME=$(date +%s)

# XDG Base Directories (with fallbacks)
readonly XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
readonly XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
readonly XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Application directories
readonly APP_NAME="dotfiles"
readonly APP_STATE_DIR="${XDG_STATE_HOME}/${APP_NAME}"
readonly APP_LOG_DIR="${APP_STATE_DIR}/logs"
readonly APP_CACHE_DIR="${XDG_CACHE_HOME}/${APP_NAME}"

# Files
readonly LOG_FILE="${APP_LOG_DIR}/setup_$(date +%Y%m%d_%H%M%S).log"
readonly CONFIG_FILE="${XDG_CONFIG_HOME}/${APP_NAME}/setup.conf"
readonly TMP_DIR="$(mktemp -d)"

# Configuration paths
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly VIM_HOME="$HOME/.vim"
readonly EMACS_HOME="$HOME/.emacs.d"
readonly OHMYZSH_HOME="$HOME/.oh-my-zsh"
readonly ZSH_CUSTOM="${ZSH_CUSTOM:-$OHMYZSH_HOME/custom}"
readonly NVM_HOME="$CONFIG_HOME/nvm"
readonly BACKUP_DIR="${HOME}/.config_backup/$(date +%Y%m%d_%H%M%S)"

# Repository URLs
readonly REPO_OHMYZSH="https://github.com/ohmyzsh/ohmyzsh"
readonly REPO_DOOM="https://github.com/hlissner/doom-emacs"
readonly REPO_P10K="https://github.com/romkatv/powerlevel10k.git"
readonly REPO_ZSH_SUGGESTION="https://github.com/zsh-users/zsh-autosuggestions"
readonly REPO_ZSH_LXD="https://github.com/endaaman/lxd-completion-zsh"
readonly URL_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

# Color definitions
readonly COLOR_ERROR='\033[0;31m'
readonly COLOR_INFO='\033[0;32m'
readonly COLOR_WARN='\033[0;33m'
readonly COLOR_DEBUG='\033[0;34m'
readonly COLOR_RESET='\033[0m'

# Default configuration values
DEBUG_ENABLE="${DEBUG_ENABLE:-0}"
VERBOSE="${VERBOSE:-0}"
DRY_RUN="${DRY_RUN:-0}"
FORCE_INSTALL="${FORCE_INSTALL:-0}"
PROXY_ENABLED="${PROXY_ENABLED:-0}"
PROXY_URL="${PROXY_URL:-http://127.0.0.1:7890}"

# Installation flags
INSTALL_BASIC=true
INSTALL_GUI=false
INSTALL_WAYLAND=false
INSTALL_PROGRAMMING=false
INSTALL_CHROMIUM_DEV=false
INSTALL_DOOM=false
INSTALL_VIM=true

# Programming language flags
INSTALL_PYTHON=false
INSTALL_NODE=false
INSTALL_GO=false
INSTALL_RUST=false
INSTALL_C=false

#######################################
# Print elapsed time since script start
# Arguments:
#   None
#######################################
show_elapsed_time() {
    local end_time=$(date +%s)
    local elapsed=$((end_time - START_TIME))
    info "Total execution time: $elapsed seconds"
}

#######################################
# Log a debug message if debug is enabled
# Arguments:
#   Message text
#######################################
debug_log() {
    [[ "${DEBUG_ENABLE}" == "1" ]] && echo -e "${COLOR_DEBUG}[DEBUG] $*${COLOR_RESET}"
    [[ "${VERBOSE}" == "1" ]] && echo -e "${COLOR_DEBUG}[DEBUG] $*${COLOR_RESET}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [DEBUG] $*" >> "${LOG_FILE}"
}

#######################################
# Log an informational message
# Arguments:
#   Message text
#######################################
info() {
    echo -e "${COLOR_INFO}[INFO] $*${COLOR_RESET}"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*" >> "${LOG_FILE}"
}

#######################################
# Log a warning message to stderr
# Arguments:
#   Message text
#######################################
warn() {
    echo -e "${COLOR_WARN}[WARN] $*${COLOR_RESET}" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $*" >> "${LOG_FILE}"
}

#######################################
# Log an error message to stderr
# Arguments:
#   Message text
#######################################
error() {
    echo -e "${COLOR_ERROR}[ERROR] $*${COLOR_RESET}" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" >> "${LOG_FILE}"
}

#######################################
# Handle script errors
# Arguments:
#   Exit code
#   Line number where error occurred
#######################################
handle_error() {
    local exit_code=$1
    local line_no=$2
    error "Error occurred in script at line ${line_no}, exit code: ${exit_code}"
    
    case $exit_code in
        1) error "General error occurred" ;;
        2) error "Invalid argument or option" ;;
        126) error "Command invoked cannot execute" ;;
        127) error "Command not found" ;;
        128) error "Invalid argument to exit" ;;
        129) error "SIGHUP signal received" ;;
        130) error "SIGINT signal received" ;;
        131) error "SIGQUIT signal received" ;;
        137) error "SIGKILL signal received" ;;
        143) error "SIGTERM signal received" ;;
        255) error "Exit status out of range" ;;
        *) error "Unknown error occurred" ;;
    esac
    
    cleanup
    exit "$exit_code"
}

#######################################
# Handle interrupt signal
# Arguments:
#   None
#######################################
handle_interrupt() {
    error "Interrupt signal received, cleaning up..."
    cleanup
    exit 130
}

#######################################
# Clean old cache files
# Arguments:
#   None
#######################################
clean_old_cache() {
    if [[ -d "${APP_CACHE_DIR}" ]]; then
        local old_files
        if is_macos; then
            # On macOS, use stat to get access time
            old_files=$(find "${APP_CACHE_DIR}" -type f -exec bash -c '
                now=$(date +%s)
                atime=$(stat -f %a "$1")
                age=$(( (now - atime) / 86400 ))
                if [ $age -gt 30 ]; then echo "$1"; fi
            ' bash {} \;)
        else
            # On Linux, we can use -atime directly
            old_files=$(find "${APP_CACHE_DIR}" -type f -atime +30)
        fi
        
        # Remove old files
        if [[ -n "${old_files}" ]]; then
            echo "${old_files}" | while read -r file; do
                if [[ -f "${file}" ]]; then
                    rm -f "${file}"
                fi
            done
        fi
        
        # Remove empty directories
        find "${APP_CACHE_DIR}" -type d -empty -delete
    fi
}

#######################################
# Compress old log files
# Arguments:
#   None
#######################################
compress_old_logs() {
    if [[ -d "${APP_LOG_DIR}" ]]; then
        local files_to_compress
        if is_macos; then
            # On macOS, use stat to get file age
            files_to_compress=$(find "${APP_LOG_DIR}" -type f -name "*.log" -exec bash -c '
                now=$(date +%s)
                fdate=$(stat -f %m "$1")
                age=$(( (now - fdate) / 86400 ))
                if [ $age -gt 7 ]; then echo "$1"; fi
            ' bash {} \;)
        else
            # On Linux, we can use -mtime directly
            files_to_compress=$(find "${APP_LOG_DIR}" -type f -name "*.log" -mtime +7)
        fi
        
        if [[ -n "${files_to_compress}" ]]; then
            echo "${files_to_compress}" | while read -r file; do
                if [[ -f "${file}" ]]; then
                    gzip -f "${file}"
                fi
            done
        fi
    fi
}

#######################################
# Cleanup function called on script exit
# Arguments:
#   None
#######################################
cleanup() {
    local exit_code=$?
    
    # Remove temporary directory
    if [[ -d "${TMP_DIR}" ]]; then
        rm -rf "${TMP_DIR}"
        debug_log "Removed temporary directory: ${TMP_DIR}"
    fi
    
    # Clean old cache files
    clean_old_cache
    
    # Compress old logs
    compress_old_logs
    
    # Show completion message and elapsed time
    if [[ $exit_code -eq 0 ]]; then
        info "Script execution completed successfully"
        info "Log file: ${LOG_FILE}"
    else
        error "Script execution failed with exit code: ${exit_code}"
        error "Check log file for details: ${LOG_FILE}"
    fi
    
    show_elapsed_time
    
    # Restore original file descriptors
    exec 1>&3 2>&4 3>&- 4>&-
}

#######################################
# Initialize logging system and create necessary directories
#
# This function sets up the logging system according to XDG base directory
# specification. It creates required directories, manages log rotation,
# and initializes log files with system information.
#
# Globals:
#   APP_LOG_DIR
#   APP_CACHE_DIR
#   XDG_CONFIG_HOME
#   LOG_FILE
#
# Arguments:
#   None
#
# Returns:
#   0 on success, non-zero on failure
#
# Example:
#   setup_logging
#   echo "Logging initialized to $LOG_FILE"
#######################################
setup_logging() {
    # Create necessary directories
    mkdir -p "${APP_LOG_DIR}" "${APP_CACHE_DIR}" "${XDG_CONFIG_HOME}/${APP_NAME}"
    
    # Set up log rotation (keep last 5 logs)
    if [[ -d "${APP_LOG_DIR}" ]]; then
        # List all log files sorted by time (newest first)
        local old_logs
        if is_macos; then
            old_logs=$(find "${APP_LOG_DIR}" -name "setup_*.log" -exec stat -f "%m %N" {} \; | sort -rn | tail -n +6 | cut -d' ' -f2-)
        else
            old_logs=$(find "${APP_LOG_DIR}" -name "setup_*.log" -printf "%T@ %p\n" | sort -rn | tail -n +6 | cut -d' ' -f2-)
        fi
        
        # Remove old logs if they exist
        if [[ -n "${old_logs}" ]]; then
            echo "${old_logs}" | xargs rm -f
        fi
    fi
    
    # Save original file descriptors
    exec 3>&1 4>&2
    
    # Redirect stdout and stderr to both console and log file
    exec 1> >(tee -a "${LOG_FILE}") 2>&1
    
    # Log initial information
    info "Started logging to ${LOG_FILE}"
    info "Script version: ${SCRIPT_VERSION}"
    info "OS type: $(uname -s)"
    info "Shell: ${SHELL}"
    info "User: ${USER}"
    info "Home: ${HOME}"
    
    # Log system information
    if is_macos; then
        info "macOS version: $(sw_vers -productVersion)"
    else
        info "Linux distribution: $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
    fi
}

#######################################
# Create default configuration file
# Arguments:
#   None
#######################################
create_default_config() {
    if [[ -f "${CONFIG_FILE}" ]]; then
        debug_log "Configuration file already exists: ${CONFIG_FILE}"
        return 0
    fi
    
    cat > "${CONFIG_FILE}" <<EOF
# Setup configuration file
# Created on: $(date)
# Version: ${SCRIPT_VERSION}

# Debug and logging
DEBUG_ENABLE=0
VERBOSE=0

# Installation behavior
DRY_RUN=0
FORCE_INSTALL=0

# Proxy settings
PROXY_ENABLED=0
PROXY_URL="http://127.0.0.1:7890"

# Component selection
INSTALL_BASIC=true
INSTALL_GUI=false
INSTALL_WAYLAND=false
INSTALL_PROGRAMMING=false
INSTALL_CHROMIUM_DEV=false
INSTALL_DOOM=false
INSTALL_VIM=true

# Programming languages
INSTALL_PYTHON=false
INSTALL_NODE=false
INSTALL_GO=false
INSTALL_RUST=false
INSTALL_C=false
EOF
    
    info "Created default configuration file: ${CONFIG_FILE}"
}

#######################################
# Load configuration from file
# Arguments:
#   None
#######################################
load_config() {
    if [[ ! -f "${CONFIG_FILE}" ]]; then
        debug_log "No configuration file found, creating default"
        create_default_config
    fi
    
    debug_log "Loading configuration from ${CONFIG_FILE}"
    # shellcheck source=/dev/null
    source "${CONFIG_FILE}"
}

#######################################
# Check system resources
# Arguments:
#   None
#######################################
check_system_resources() {
    local min_memory=2048  # 2GB in MB
    local min_disk=5120    # 5GB in MB
    
    # Check memory
    local total_memory
    if is_macos; then
        # Get memory in MB on macOS
        total_memory=$(sysctl -n hw.memsize | awk '{print $1/1024/1024}')
    else
        # Get memory in MB on Linux
        total_memory=$(awk '/MemTotal/ {print $2/1024}' /proc/meminfo)
    fi
    
    if [[ -n "$total_memory" ]] && (( ${total_memory%.*} < min_memory )); then
        warn "Low memory: ${total_memory%.*}MB available, ${min_memory}MB recommended"
    fi
    
    # Check disk space
    local available_space
    if is_macos; then
        available_space=$(df -m "${HOME}" | awk 'NR==2 {print $4}')
    else
        available_space=$(df -m "${HOME}" | awk 'NR==2 {print $4}')
    fi
    
    if [[ -n "$available_space" ]] && (( available_space < min_disk )); then
        warn "Low disk space: ${available_space}MB available, ${min_disk}MB recommended"
    fi
    
    debug_log "System resources check completed"
}

#######################################
# Check network connectivity
# Arguments:
#   None
#######################################
check_network() {
    local test_urls=(
        "https://github.com"
        "https://www.google.com"
    )
    
    for url in "${test_urls[@]}"; do
        if ! curl --silent --head --fail "$url" >/dev/null; then
            warn "Unable to reach ${url}"
            if [[ "$url" == "https://github.com" ]]; then
                warn "GitHub is not accessible, some features may not work"
                prompt_proxy_setup
            fi
        fi
    done
    
    debug_log "Network connectivity check completed"
}

#######################################
# Check if a command exists
# Arguments:
#   Command name
# Returns:
#   0 if command exists, 1 otherwise
#######################################
is_executable() {
    command -v "$1" &>/dev/null
}

#######################################
# Check for required dependencies
# Arguments:
#   None
#######################################
check_dependencies() {
    local missing_deps=()
    local required_cmds=(
        git curl wget sudo
    )
    
    for cmd in "${required_cmds[@]}"; do
        if ! is_executable "$cmd"; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -ne 0 ]]; then
        error "Missing required dependencies: ${missing_deps[*]}"
        info "Please install the missing dependencies and try again"
        exit 1
    fi
    
    debug_log "Dependency check completed"
}

#######################################
# Backup existing configurations
# Arguments:
#   None
#######################################
backup_configs() {
    local files_to_backup=(
        "${HOME}/.zshrc"
        "${HOME}/.vimrc"
        "${HOME}/.tmux.conf"
        "${HOME}/.gitconfig"
        "${CONFIG_HOME}/nvim"
    )
    
    info "Creating backup of existing configurations..."
    mkdir -p "${BACKUP_DIR}"
    
    for file in "${files_to_backup[@]}"; do
        if [[ -e "${file}" ]]; then
            cp -rp "${file}" "${BACKUP_DIR}/"
            debug_log "Backed up ${file}"
        fi
    done
    
    info "Configurations backed up to ${BACKUP_DIR}"
}

#######################################
# Check if running on macOS
# Returns:
#   0 if macOS, 1 otherwise
#######################################
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
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
# Show progress bar
# Arguments:
#   Current progress
#   Total steps
#   Optional description
#######################################
show_progress() {
    local current=$1
    local total=$2
    local desc=${3:-"Progress"}
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((width * current / total))
    local remaining=$((width - completed))
    
    printf "\r%s: [%${completed}s%${remaining}s] %d%%" \
           "$desc" \
           "$(printf '#%.0s' $(seq 1 $completed))" \
           "$(printf ' %.0s' $(seq 1 $remaining))" \
           "$percentage"
    
    [[ $current -eq $total ]] && echo
}

#######################################
# Prompt for proxy setup
# Arguments:
#   None
#######################################
prompt_proxy_setup() {
    if [[ "${PROXY_ENABLED}" != "1" ]]; then
        local response
        read -rp "Would you like to configure a proxy? (y/N) " response
        if [[ "${response}" =~ ^[Yy]$ ]]; then
            read -rp "Enter proxy URL [${PROXY_URL}]: " input_url
            PROXY_URL="${input_url:-${PROXY_URL}}"
            PROXY_ENABLED=1
            export http_proxy="${PROXY_URL}"
            export https_proxy="${PROXY_URL}"
            export HTTP_PROXY="${PROXY_URL}"
            export HTTPS_PROXY="${PROXY_URL}"
            info "Proxy configured: ${PROXY_URL}"
        fi
    fi
}

#######################################
# Install Homebrew if not present (macOS only)
# Arguments:
#   None
# Returns:
#   0 on success, 1 on failure
#######################################
ensure_homebrew() {
    if ! is_macos; then
        return 0
    fi

    if ! is_executable brew; then
        info "Installing Homebrew..."
        if [[ "${DRY_RUN}" != "1" ]]; then
            # Download and verify the install script
            local install_script
            install_script="$(mktemp)"
            curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh > "$install_script"
            
            # Check if download was successful
            if [[ ! -s "$install_script" ]]; then
                error "Failed to download Homebrew install script"
                rm -f "$install_script"
                return 1
            fi
            
            # Execute the install script
            /bin/bash "$install_script"
            local exit_code=$?
            rm -f "$install_script"
            
            if [[ $exit_code -ne 0 ]]; then
                error "Homebrew installation failed"
                return 1
            fi
        fi
    fi

    if ! is_executable brew; then
        error "Failed to find or install Homebrew"
        return 1
    fi

    # Update Homebrew
    if [[ "${DRY_RUN}" != "1" ]]; then
        info "Updating Homebrew..."
        if ! brew update; then
            warn "Failed to update Homebrew, but continuing anyway..."
        fi
    fi

    return 0
}

#######################################
# Install packages based on package manager
# Arguments:
#   Package names
# Returns:
#   0 on success, 1 on failure
#######################################
install_packages() {
    local total_packages=$#
    local current=0
    
    # Handle macOS with Homebrew
    if is_macos; then
        ensure_homebrew || return 1
        
        # First, check what needs to be installed
        local pkgs_to_install=()
        for pkg in "$@"; do
            if ! brew list "$pkg" &>/dev/null; then
                pkgs_to_install+=("$pkg")
            else
                debug_log "Package already installed: ${pkg}"
            fi
        done
        
        # If there are packages to install
        if [[ ${#pkgs_to_install[@]} -gt 0 ]]; then
            if [[ "${DRY_RUN}" == "1" ]]; then
                debug_log "Would install: ${pkgs_to_install[*]}"
            else
                info "Installing packages: ${pkgs_to_install[*]}"
                if ! brew install "${pkgs_to_install[@]}"; then
                    error "Failed to install some packages. Check the log for details."
                    return 1
                fi
            fi
        else
            info "All packages are already installed"
        fi
        return 0
    fi
    
    # Handle Linux systems
    if ! is_executable sudo; then
        error "sudo isn't installed"
        return 1
    fi
    
    if is_executable yay; then
        for pkg in "$@"; do
            current=$((current + 1))
            show_progress "$current" "$total_packages" "Installing ${pkg}"
            if [[ "${DRY_RUN}" == "1" ]]; then
                debug_log "Would install: ${pkg}"
            else
                yay -S --needed --noconfirm "$pkg" || warn "Failed to install ${pkg}"
            fi
        done
    elif is_executable pacman; then
        for pkg in "$@"; do
            current=$((current + 1))
            show_progress "$current" "$total_packages" "Installing ${pkg}"
            if [[ "${DRY_RUN}" == "1" ]]; then
                debug_log "Would install: ${pkg}"
            else
                sudo pacman -S --needed --noconfirm "$pkg" || warn "Failed to install ${pkg}"
            fi
        done
    elif is_executable apt; then
        if [[ "${DRY_RUN}" == "1" ]]; then
            debug_log "Would install: $*"
        else
            sudo apt update
            sudo apt install -y "$@"
        fi
    else
        error "No supported package manager found"
        return 1
    fi
    
    return 0
}

#######################################
# Setup basic environment
# Arguments:
#   None
#######################################
setup_basic_environments() {
    info "Setting up basic environment..."
    
    local packages=()
    
    if is_macos; then
        packages+=(
            macvim tmux ctags zsh
            jq ripgrep fzf fd
            autojump curl tree
            coreutils wget gnu-sed
            bash bash-completion@2
        )
    else
        packages+=(
            gvim tmux ctags bash-completion zsh man-db
            jq ripgrep fzf fd autojump curl
            sshuttle tree lsb-release
        )
        
        if is_arch; then
            packages+=(mlocate unzip)
        elif is_ubuntu; then
            packages+=(locate)
        fi
    fi
    
    install_packages "${packages[@]}"
    verify_installation "basic"
}

#######################################
# Setup GUI environment
# Arguments:
#   None
#######################################
setup_gui_environments() {
    info "Setting up GUI environment..."
    
    if is_macos; then
        local casks=(
            alacritty
            google-chrome
            visual-studio-code
            iterm2
            alt-tab
            rectangle
        )
        
        # Install Homebrew Casks
        for cask in "${casks[@]}"; do
            if [[ "${DRY_RUN}" == "1" ]]; then
                debug_log "Would install cask: ${cask}"
            else
                brew list --cask "$cask" &>/dev/null || brew install --cask "$cask" || warn "Failed to install ${cask}"
            fi
        done
        
        # Install font
        brew tap homebrew/cask-fonts
        brew install --cask font-jetbrains-mono-nerd-font
        
    else
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
            )
        elif is_ubuntu; then
            packages+=(
                vim-gtk3
                fcitx5 fcitx5-chinese-addons
                fcitx5-frontend-gtk3 fcitx5-frontend-gtk2
                fcitx5-frontend-qt5
            )
        fi
        
        install_packages "${packages[@]}"
    fi
    
    verify_installation "gui"
}

#######################################
# Setup Wayland environment
# Arguments:
#   None
#######################################
setup_wayland_environments() {
    info "Setting up Wayland environment..."
    
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
    verify_installation "wayland"
}

#######################################
# Setup programming environments
# Arguments:
#   None
#######################################
setup_programming_environments() {
    info "Setting up programming environments..."
    
    [[ "${INSTALL_PYTHON}" == "true" ]] && setup_python_environments
    [[ "${INSTALL_NODE}" == "true" ]] && setup_node_environments
    [[ "${INSTALL_GO}" == "true" ]] && setup_go_environments
    [[ "${INSTALL_RUST}" == "true" ]] && setup_rust_environments
    [[ "${INSTALL_C}" == "true" ]] && setup_c_environments
}

#######################################
# Setup Python environment
# Arguments:
#   None
#######################################
setup_python_environments() {
    info "Setting up Python environment..."
    
    local packages=(python python-pip)
    install_packages "${packages[@]}"
    
    if is_executable pip; then
        local pip_packages=(
            wordfreq nltk bs4  # basic
            pudb  # python debugger
        )
        
        if [[ "${DRY_RUN}" != "1" ]]; then
            pip install "${pip_packages[@]}"
            python3 -m nltk.downloader popular
        fi
    fi
    
    verify_installation "python"
}

#######################################
# Setup Node environment
# Arguments:
#   None
#######################################
setup_node_environments() {
    info "Setting up Node.js environment..."
    
    if is_macos; then
        # On macOS, prefer installing Node.js via Homebrew
        if ! is_executable node; then
            brew install node
        fi
    else
        # Install NVM
        if [[ ! -d "${NVM_HOME}" ]]; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
        fi
        
        # Load NVM
        export NVM_DIR="${NVM_HOME}"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        if [[ "${DRY_RUN}" != "1" ]]; then
            nvm install node
            nvm use node
        fi
    fi
    
    if [[ "${DRY_RUN}" != "1" ]]; then
        # Install global packages
        if ! is_executable yarn; then
            npm install -g yarn
        fi
        
        local npm_packages=(
            source-map-support
            prettier
            eslint
            ts-node
            typescript
        )
        
        if is_macos; then
            npm install -g "${npm_packages[@]}"
        else
            yarn global add "${npm_packages[@]}"
        fi
    fi
    
    verify_installation "node"
}

#######################################
# Setup Go environment
# Arguments:
#   None
#######################################
setup_go_environments() {
    info "Setting up Go environment..."
    
    local packages=(go)
    install_packages "${packages[@]}"
    
    if [[ "${DRY_RUN}" != "1" ]]; then
        # Configure Go environment
        export GOPATH=$HOME/go
        export GOBIN=$HOME/go/bin
        export PATH=$PATH:$GOBIN
        
        # Install Go packages
        local go_packages=(
            github.com/go-delve/delve/cmd/dlv@latest
            github.com/golangci/golangci-lint/cmd/golangci-lint@latest
            github.com/grafana/jsonnet-language-server@latest
        )
        
        for pkg in "${go_packages[@]}"; do
            go install "$pkg"
        done
    fi
    
    verify_installation "go"
}

#######################################
# Setup Rust environment
# Arguments:
#   None
#######################################
setup_rust_environments() {
    info "Setting up Rust environment..."
    
    if [[ "${DRY_RUN}" != "1" ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        rustup default nightly
        rustup component add rust-analyzer
    fi
    
    verify_installation "rust"
}

#######################################
# Setup C/C++ environment
# Arguments:
#   None
#######################################
setup_c_environments() {
    info "Setting up C/C++ environment..."
    
    local packages=(
        gcc llvm clang clangd gdb cgdb
    )
    
    install_packages "${packages[@]}"
    verify_installation "c"
}

#######################################
# Setup Vim environment
# Arguments:
#   None
#######################################
setup_vim() {
    info "Setting up Vim environment..."
    
    # Install Vim-plug
    if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
        curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    
    # Link configuration files
    ln -sf "${SCRIPT_DIR}/vimrc.d/.vimrc" "${HOME}/.vimrc"
    
    if [[ "${DRY_RUN}" != "1" ]]; then
        vim +PlugInstall +qall
    fi
    
    verify_installation "vim"
}

#######################################
# Verify component installation
# Arguments:
#   Component name
# Returns:
#   0 if verified, 1 if failed
#######################################
verify_installation() {
    local component=$1
    local failed=false
    
    case $component in
        "basic")
            local basic_tools=(zsh git curl)
            if is_macos; then
                basic_tools+=(mvim tmux gsed)
            else
                basic_tools+=(vim tmux)
            fi
            
            for cmd in "${basic_tools[@]}"; do
                if ! is_executable "$cmd"; then
                    error "Basic tool $cmd not found"
                    failed=true
                fi
            done
            ;;
        "vim")
            if is_macos; then
                if ! is_executable mvim || [[ ! -f "${HOME}/.vimrc" ]]; then
                    error "MacVim installation or configuration incomplete"
                    failed=true
                fi
            else
                if [[ ! -f "${HOME}/.vimrc" ]]; then
                    error "Vim configuration not found"
                    failed=true
                fi
            fi
            ;;
        "gui")
            if is_macos; then
                local apps=(
                    "/Applications/Alacritty.app"
                    "/Applications/Google Chrome.app"
                    "/Applications/Visual Studio Code.app"
                    "/Applications/iTerm.app"
                )
                for app in "${apps[@]}"; do
                    if [[ ! -d "$app" ]]; then
                        warn "GUI application not found: $app"
                    fi
                done
            else
                if ! is_executable alacritty; then
                    error "Alacritty not found"
                    failed=true
                fi
            fi
            ;;
        "python")
            if ! is_executable python3 || ! is_executable pip3; then
                error "Python installation incomplete"
                failed=true
            fi
            ;;
        "node")
            if ! is_executable node || ! is_executable npm; then
                error "Node.js installation incomplete"
                failed=true
            fi
            ;;
        "go")
            if ! is_executable go; then
                error "Go installation incomplete"
                failed=true
            fi
            ;;
        "rust")
            if ! is_executable rustc || ! is_executable cargo; then
                error "Rust installation incomplete"
                failed=true
            fi
            ;;
        "c")
            if is_macos; then
                if ! is_executable clang; then
                    error "Clang installation incomplete"
                    failed=true
                fi
            else
                if ! is_executable gcc || ! is_executable clang; then
                    error "C/C++ installation incomplete"
                    failed=true
                fi
            fi
            ;;
    esac
    
    $failed && return 1
    debug_log "Verification successful for $component"
    return 0
}

#######################################
# Show script usage
# Arguments:
#   None
#######################################
show_usage() {
    cat <<EOF
Development Environment Setup Script v${SCRIPT_VERSION}

Usage: $(basename "$0") [OPTIONS] COMMAND

Commands:
    all         Install everything (recommended for new systems)
    basic       Install basic development tools
    gui         Install GUI applications
    wayland     Set up Wayland environment
    vim         Configure Vim editor
    doom        Install Doom Emacs
    program     Install programming languages
    clean       Clean up temporary files

Options:
    -h, --help     Show this help message
    -v, --verbose  Enable verbose output
    -f, --force    Force installation (skip confirmations)
    -n, --dry-run  Show what would be done
    --no-proxy     Disable proxy configuration
    --config FILE  Use custom configuration file

Examples:
    $(basename "$0") basic            # Install basic environment
    $(basename "$0") -v program       # Install programming tools with verbose output
    $(basename "$0") --config my.conf # Use custom configuration

For more information, visit: https://github.com/loyalpartner/dotfiles
EOF
}

#######################################
# Parse command line arguments
# Arguments:
#   Command line arguments
#######################################
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=1
                shift
                ;;
            -f|--force)
                FORCE_INSTALL=1
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=1
                shift
                ;;
            --no-proxy)
                PROXY_ENABLED=0
                shift
                ;;
            --config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            all)
                INSTALL_BASIC=true
                INSTALL_GUI=true
                INSTALL_WAYLAND=true
                INSTALL_PROGRAMMING=true
                INSTALL_VIM=true
                shift
                ;;
            basic)
                INSTALL_BASIC=true
                shift
                ;;
            gui)
                INSTALL_GUI=true
                shift
                ;;
            wayland)
                INSTALL_WAYLAND=true
                shift
                ;;
            vim)
                INSTALL_VIM=true
                shift
                ;;
            program)
                INSTALL_PROGRAMMING=true
                INSTALL_PYTHON=true
                INSTALL_NODE=true
                INSTALL_GO=true
                INSTALL_RUST=true
                INSTALL_C=true
                shift
                ;;
            *)
                error "Unknown argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done
}

#######################################
# Main function
# Arguments:
#   Command line arguments
#######################################
main() {
    # Initialize script
    setup_logging
    load_config
    parse_args "$@"
    
    # Perform pre-installation checks
    check_dependencies
    check_system_resources
    check_network
    
    # Backup existing configurations
    [[ "${FORCE_INSTALL}" != "1" ]] && backup_configs
    
    # Perform installation based on flags
    [[ "${INSTALL_BASIC}" == "true" ]] && setup_basic_environments
    [[ "${INSTALL_GUI}" == "true" ]] && setup_gui_environments
    [[ "${INSTALL_WAYLAND}" == "true" ]] && setup_wayland_environments
    [[ "${INSTALL_PROGRAMMING}" == "true" ]] && setup_programming_environments
    [[ "${INSTALL_VIM}" == "true" ]] && setup_vim
    
    info "Installation completed successfully!"
}

# Set up signal handlers
trap 'handle_error $? ${LINENO}' ERR
trap handle_interrupt INT TERM

# Run main function with all arguments
main "$@"