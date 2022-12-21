#!/usr/bin/env sh

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

REPO_OHMYZSH="https://github.com/ohmyzsh/ohmyzsh"
REPO_DOOM="https://github.com/hlissner/doom-emacs"
REPO_P10K="https://github.com/romkatv/powerlevel10k.git"
REPO_ZSH_SUGGESTION="https://github.com/zsh-users/zsh-autosuggestions"

URL_PLUG="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

function install_softs {
  if which pacman &>/dev/null
  then
    sudo pacman -S --noconfirm sway \
      alacritty gvim emacs tigervnc \
      wqy-microhei bash-completion \
      tmux ctags zsh alacritty \
      dmenu waybar wofi \
      xorg-xwayland xorg-xlsclients \
      qt5-wayland glfw-wayland \
      fcitx5-chinese-addons fcitx5 fcitx5-qt \
      fcitx5-pinyin-zhwiki fcitx5-configtool kcm-fcitx5 \
      alsa-utils pulseaudio pamixer pavucontrol pulseaudio-alsa \
      nodejs npm clash fd sshuttle man-db python-pip \
      go
    yay -S --noconfirm clipman \
      google-chrome \
      nutstore-experimental \
      nerd-fonts-source-code-pro \
      nerd-fonts-jetbrains-mono

    pip install wordfreq
    pip install nltk
    pip install bs4
    python -m nltk.downloader popular
  elif which apt &>/dev/null
  then
    sudo apt install alacritty rust fzf ripgrep autojump golang
  fi
}

function link_dot_configs {
  ln -vfs $SCRIPT_DIR/zsh/zshrc.zsh $HOME/.zshrc
  ln -vfs $SCRIPT_DIR/tmux.conf $HOME/.tmux.conf
}

function link_config_dir {
  rm -rf ${2:-/tmp/nonexist}; ln -vs $1 $2
}

function install_dotfiles {
  local xdg_configs=(sway wofi alacritty)
  for config in ${xdg_configs[@]}
  do
    link_config_dir $SCRIPT_DIR/$config/ $HOME/.config/$config
  done
  link_config_dir $SCRIPT_DIR/ctags.d $HOME/.ctags.d
  link_dot_configs
}

function install_vim_config {
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

stop=false
until $stop; do
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
      *) stop=true;;
    esac
    break
  done
done
