#!/usr/bin/env bash
# Symlink dotfiles from configs/ into XDG config dirs.

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Configs that map directly to $CONFIG_HOME/<name>
ALL_CONFIGS=(
    alacritty ctags foot gdb rofi starship
    sway swayr sxhkd vim waybar zsh
)

_link_dir() {
    local name=$1
    local src="$SCRIPT_DIR/configs/$name"
    local dst="$CONFIG_HOME/$name"

    [[ ! -d "$src" ]] && { warn "missing source: $src"; return 1; }

    mkdir -p "$CONFIG_HOME"
    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        warn "$dst exists and is not a symlink, skipping"
        return 1
    fi
    ln -s "$src" "$dst"
    info "linked $name -> $dst"
}

_link_tmux() {
    ln -sfn "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
    info "linked tmux.conf -> ~/.tmux.conf"
}

_link_zsh_extras() {
    ln -sfn "$SCRIPT_DIR/configs/zsh/zshrc.zsh" "$HOME/.zshrc"
    info "linked zshrc.zsh -> ~/.zshrc"

    local omz="$HOME/.oh-my-zsh"
    if [[ ! -d "$omz" ]]; then
        info "Cloning oh-my-zsh..."
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh "$omz"
    fi
    local custom="${ZSH_CUSTOM:-$omz/custom}"
    if [[ ! -d "$custom/plugins/zsh-autosuggestions" ]]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
            "$custom/plugins/zsh-autosuggestions"
    fi
}

_link_vim_extras() {
    ln -sfn "$SCRIPT_DIR/configs/vim/vimrc" "$HOME/.vimrc"
    info "linked vim/vimrc -> ~/.vimrc"

    local plug="$HOME/vim-dev/plug.nvim"
    if [[ ! -d "$plug" ]]; then
        info "Cloning vim-plug..."
        mkdir -p "$(dirname "$plug")"
        git clone https://github.com/junegunn/vim-plug.git "$plug"
    fi
}

install_configs() {
    local targets=()
    if [[ $# -eq 0 ]]; then
        targets=("${ALL_CONFIGS[@]}" tmux)
    else
        targets=("$@")
    fi

    for name in "${targets[@]}"; do
        case "$name" in
            tmux) _link_tmux ;;
            vim)  _link_dir vim && _link_vim_extras ;;
            zsh)  _link_dir zsh && _link_zsh_extras ;;
            *)    _link_dir "$name" ;;
        esac
    done
}
