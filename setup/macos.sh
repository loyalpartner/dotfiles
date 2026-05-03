#!/usr/bin/env bash
# macOS package definitions (Homebrew)

ensure_brew() {
    if ! command -v brew >/dev/null 2>&1; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

pkg_install() {
    ensure_brew
    brew install "$@"
}

cask_install() {
    ensure_brew
    brew install --cask "$@"
}

install_basic() {
    info "Installing basic CLI tools (macOS)..."
    pkg_install \
        macvim tmux ctags zsh \
        jq ripgrep fzf fd autojump \
        curl wget tree \
        coreutils gnu-sed bash bash-completion@2
}

install_gui() {
    info "Installing GUI apps (macOS)..."
    cask_install \
        alacritty google-chrome visual-studio-code iterm2 \
        alt-tab rectangle \
        font-jetbrains-mono-nerd-font
}

install_wayland() {
    warn "Wayland is not applicable on macOS"
    return 0
}
