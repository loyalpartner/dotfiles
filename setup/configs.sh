#!/usr/bin/env bash
# Symlink dotfiles into ~/.config and $HOME.

CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# src-relative-to-repo : dest-absolute
LINKS=(
    "configs/alacritty:$CONFIG_HOME/alacritty"
    "configs/ctags:$CONFIG_HOME/ctags"
    "configs/foot:$CONFIG_HOME/foot"
    "configs/gdb:$CONFIG_HOME/gdb"
    "configs/rofi:$CONFIG_HOME/rofi"
    "configs/starship:$CONFIG_HOME/starship"
    "configs/sway:$CONFIG_HOME/sway"
    "configs/swayr:$CONFIG_HOME/swayr"
    "configs/sxhkd:$CONFIG_HOME/sxhkd"
    "configs/vim:$CONFIG_HOME/vim"
    "configs/waybar:$CONFIG_HOME/waybar"
    "configs/zsh:$CONFIG_HOME/zsh"
    "tmux.conf:$HOME/.tmux.conf"
    "configs/zsh/zshrc.zsh:$HOME/.zshrc"
    "configs/vim/vimrc:$HOME/.vimrc"
)

install_configs() {
    for pair in "${LINKS[@]}"; do
        local rel=${pair%%:*} dst=${pair##*:}

        if [[ $# -gt 0 ]]; then
            local match=0
            for f in "$@"; do [[ "$rel" == *"$f"* ]] && match=1; done
            (( match )) || continue
        fi

        local src="$SCRIPT_DIR/$rel"
        [[ ! -e "$src" ]] && { warn "missing: $rel"; continue; }

        mkdir -p "$(dirname "$dst")"
        [[ -L "$dst" ]] && rm "$dst"
        [[ -e "$dst" ]] && { warn "exists: $dst (skip)"; continue; }

        ln -s "$src" "$dst"
        info "linked $rel -> $dst"
    done

    # Bootstrap frameworks needed by zsh/vim configs
    local omz="$HOME/.oh-my-zsh"
    if [[ ! -d "$omz" ]]; then
        info "Cloning oh-my-zsh..."
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh "$omz"
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
            "$omz/custom/plugins/zsh-autosuggestions"
    fi

    local plug="$HOME/vim-dev/plug.nvim"
    if [[ ! -d "$plug" ]]; then
        info "Cloning vim-plug..."
        git clone --depth=1 https://github.com/junegunn/vim-plug "$plug"
    fi
}
