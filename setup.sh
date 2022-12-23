#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

REPO_OHMYZSH="https://github.com/ohmyzsh/ohmyzsh"
REPO_DOOM="https://github.com/hlissner/doom-emacs"
REPO_P10K="https://github.com/romkatv/powerlevel10k.git"
REPO_ZSH_SUGGESTION="https://github.com/zsh-users/zsh-autosuggestions"
URL_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

. $(_path_relative_script_home common.sh)

link_dot_configs() {
  ln -vfs $SCRIPT_DIR/zsh/zshrc.zsh $HOME/.zshrc
  ln -vfs $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf
}

link_config_dir() {
  if [[ -n $1 && -n $2 ]]; then
    rm -rf ${2:-/tmp/nonexist}; ln -vs $1 $2
  else
    echo "parameter is empty string"
  fi
}

_link_configs_to_xdg_dir_() {
  echo "prepare link $1's config"
  local targets to
  targets="$(_path_relative_script_home $1)/*"
  dir=$(_path_relative_xdg_config_home $1)
  ln -vfs $targets $dir
}

install_dotfiles() {
  local xdg_configs=(sway wofi alacritty ctags)
  for config in ${xdg_configs[@]}
  do
    _ensure_directory_exists $config
    _link_configs_to_xdg_dir_ $config
  done
  link_dot_configs
}

install_vim_config() {
  mkdir -p $HOME/.vim && link_config_dir $SCRIPT_DIR/vimrc/ $HOME/.vim/vimrc
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs $URL_PLUG
  ln -vfs $HOME/.vim/vimrc/.vimrc $HOME/.vimrc
}

function install_doom {
  git clone --depth 1 ${REPO_DOOM} $HOME/.emacs.d &&
    $HOME/.emacs.d/bin/doom install
}

function install_ohmyzsh {
  declare -a args=(
    "${REPO_OHMYZSH} $HOME/.oh-my-zsh"
    "${REPO_P10K} ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    "${REPO_ZSH_SUGGESTION} ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  )
  for arg in "${args[@]}"; do git clone --depth=1 $arg ; done
}

function install_go {
  go install github.com/grafana/jsonnet-language-server@latest
}

function git_config {
  source "$SCRIPT_DIR/init-git.sh"
}

function install {
  install_softs
  install_go
  install_dotfiles
  install_ohmyzsh
  install_vim_config
  git_config
}

finish=false
until $finish; do
  echo "select action to do:"
  select action in softs dotfiles doom ohmyzsh git vim go all; do
    case $action in 
      softs) install_softs;;
      dotfiles) install_dotfiles;;
      ohmyzsh) install_ohmyzsh;;
      doom) install_doom;;
      git) git_config;;
      vim) install_vim_config;;
      go) install_go;;
      all) install;;
      *) finish=true;;
    esac
    break
  done
done
