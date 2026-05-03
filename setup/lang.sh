#!/usr/bin/env bash
# Programming language toolchains
# Each lang_* function is independent and can be invoked separately.

lang_python() {
    info "Installing Python..."
    case "$OS" in
        arch)        pkg_install python python-pip ;;
        ubuntu)      pkg_install python3 python3-pip python3-venv ;;
        macos)       pkg_install python ;;
    esac

    local pip_pkgs=(wordfreq nltk bs4 pudb)
    if command -v pip3 >/dev/null 2>&1; then
        pip3 install --user --break-system-packages "${pip_pkgs[@]}" 2>/dev/null \
            || pip3 install --user "${pip_pkgs[@]}"
        python3 -m nltk.downloader popular || true
    fi
}

lang_node() {
    info "Installing Node.js..."
    if [[ "$OS" == "macos" ]]; then
        command -v node >/dev/null 2>&1 || pkg_install node
    else
        local nvm_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
        export NVM_DIR="$nvm_dir"
        if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
            mkdir -p "$NVM_DIR"
            PROFILE=/dev/null bash -c \
                "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash"
        fi
        # shellcheck source=/dev/null
        . "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm use --lts
    fi

    local npm_pkgs=(yarn prettier eslint typescript ts-node source-map-support)
    npm install -g "${npm_pkgs[@]}"
}

lang_go() {
    info "Installing Go..."
    pkg_install go
    export GOPATH="${GOPATH:-$HOME/go}"
    export PATH="$PATH:$GOPATH/bin"
    mkdir -p "$GOPATH/bin"

    local go_pkgs=(
        github.com/go-delve/delve/cmd/dlv@latest
        github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    )
    for pkg in "${go_pkgs[@]}"; do
        go install "$pkg" || warn "go install failed: $pkg"
    done
}

lang_rust() {
    info "Installing Rust..."
    if ! command -v rustup >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
            | sh -s -- -y --default-toolchain stable
    fi
    # shellcheck source=/dev/null
    [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
    rustup component add rust-analyzer clippy rustfmt
}

lang_c() {
    info "Installing C/C++ toolchain..."
    case "$OS" in
        arch)   pkg_install gcc llvm clang clangd gdb cgdb ;;
        ubuntu) pkg_install gcc g++ clang clangd gdb cgdb ;;
        macos)  pkg_install llvm gdb ;;
    esac
}

lang_all() {
    lang_python
    lang_node
    lang_go
    lang_rust
    lang_c
}
