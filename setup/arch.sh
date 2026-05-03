#!/usr/bin/env bash
# Arch Linux package definitions

pkg_install() {
    if command -v yay >/dev/null 2>&1; then
        yay -S --needed --noconfirm "$@"
    else
        sudo pacman -S --needed --noconfirm "$@"
    fi
}

install_basic() {
    info "Installing basic CLI tools (Arch)..."
    pkg_install \
        gvim tmux ctags bash-completion zsh man-db \
        jq ripgrep fzf fd autojump curl wget \
        sshuttle tree lsb-release \
        mlocate unzip git
}

install_gui() {
    info "Installing GUI apps (Arch)..."
    pkg_install \
        alacritty google-chrome foot \
        tigervnc wqy-microhei \
        fcitx5 fcitx5-chinese-addons fcitx5-qt \
        fcitx5-pinyin-zhwiki fcitx5-configtool kcm-fcitx5 \
        alsa-utils pipewire pipewire-pulse pipewire-alsa \
        wireplumber pamixer pavucontrol \
        nutstore-experimental
}

install_wayland() {
    info "Installing Wayland desktop (Arch)..."
    pkg_install \
        sway swayr greetd greetd-tuigreet \
        waybar rofi-lbonn-wayland swayidle swaylock clipman \
        xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland \
        ttf-font-awesome
}
