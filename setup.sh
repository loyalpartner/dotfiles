#!/usr/bin/env bash
# Dotfiles setup entry point.
# Detects OS, sources the matching module, dispatches subcommands.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

info() { printf '\033[0;32m[INFO]\033[0m %s\n' "$*"; }
warn() { printf '\033[0;33m[WARN]\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[0;31m[ERR ]\033[0m %s\n' "$*" >&2; }

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo macos
    elif [[ -f /etc/arch-release ]] || grep -qi 'arch' /etc/os-release 2>/dev/null; then
        echo arch
    elif grep -qi 'ubuntu\|debian' /etc/os-release 2>/dev/null; then
        echo ubuntu
    else
        err "unsupported OS"
        exit 1
    fi
}

OS=$(detect_os)

# shellcheck source=/dev/null
. "$SCRIPT_DIR/setup/$OS.sh"
# shellcheck source=/dev/null
. "$SCRIPT_DIR/setup/lang.sh"
# shellcheck source=/dev/null
. "$SCRIPT_DIR/setup/configs.sh"

usage() {
    cat <<EOF
Dotfiles setup (detected OS: $OS)

Usage: $(basename "$0") <command> [args...]

Commands:
    basic                Install basic CLI tools
    gui                  Install GUI applications
    wayland              Install Wayland desktop (Linux only)
    configs [NAME...]    Symlink dotfiles into ~/.config (all if no args)
    lang LANG...         Install language toolchain(s): python|node|go|rust|c|all
    all                  basic + gui + configs

Examples:
    $(basename "$0") basic
    $(basename "$0") configs vim zsh
    $(basename "$0") lang go rust
    $(basename "$0") lang all
EOF
}

cmd=${1:-help}
shift || true

case "$cmd" in
    basic)   install_basic ;;
    gui)     install_gui ;;
    wayland) install_wayland ;;
    configs) install_configs "$@" ;;
    lang)
        [[ $# -eq 0 ]] && { err "specify language(s)"; usage; exit 1; }
        for l in "$@"; do
            case "$l" in
                all)        lang_all ;;
                python|py)  lang_python ;;
                node|js)    lang_node ;;
                go)         lang_go ;;
                rust|rs)    lang_rust ;;
                c|cpp|c++)  lang_c ;;
                *) err "unknown language: $l"; exit 1 ;;
            esac
        done
        ;;
    all)
        install_basic
        install_gui
        install_configs
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        err "unknown command: $cmd"
        usage
        exit 1
        ;;
esac
