#!/usr/bin/env bash
# Ubuntu/Debian package definitions

pkg_install() {
    sudo apt update
    sudo apt install -y "$@"
}

install_basic() {
    info "Installing basic CLI tools (Ubuntu)..."
    pkg_install \
        vim tmux exuberant-ctags bash-completion zsh man-db \
        jq ripgrep fzf fd-find autojump curl wget \
        sshuttle tree lsb-release locate git
}

install_gui() {
    info "Installing GUI apps (Ubuntu)..."
    pkg_install \
        alacritty foot vim-gtk3 \
        fcitx5 fcitx5-chinese-addons \
        fcitx5-frontend-gtk3 fcitx5-frontend-gtk2 fcitx5-frontend-qt5 \
        pipewire pipewire-pulse wireplumber pavucontrol
}

install_wayland() {
    info "Installing Wayland desktop (Ubuntu)..."
    pkg_install \
        sway waybar swayidle swaylock \
        fonts-font-awesome
}
