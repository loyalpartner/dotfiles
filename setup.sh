#!/usr/bin/env sh

SCRIPTDIR="$( cd "$( dirname "$0" )" && pwd )"

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
      nodejs npm clash fd sshuttle man-db
    yay -S --noconfirm clipman \
      google-chrome \
      nutstore-experimental \
      nerd-fonts-source-code-pro \
      nerd-fonts-jetbrains-mono
  fi
}

function link_dot_configs {
  ln -vfs $SCRIPTDIR/zsh/zshrc.zsh $HOME/.zshrc
  ln -vfs $SCRIPTDIR/tmux.conf $HOME/.tmux.conf
}

function link_config_dir {
  [[ -h "$2" ]] || ln -vfs $1 $2
}

function install_dotfiles {
  cp -rf $SCRIPTDIR/ctags.d $HOME/.ctags.d
  local dir_to_links=(sway waybar wofi alacritty)
  for name in ${dir_to_links[@]}
  do
    link_config_dir $SCRIPTDIR/$name/ $HOME/.config/$name
  done
  link_dot_configs
}

function install_vim_config {
  mkdir -p $HOME/.vim && link_config_dir $SCRIPTDIR/vimrc/ $HOME/.vim/vimrc
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
	  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  ln -vfs $HOME/.vim/vimrc/.vimrc $HOME/.vimrc
}

function install_doom {
  git clone --depth 1 https://github.com/hlissner/doom-emacs $HOME/.emacs.d
  $HOME/.emacs.d/bin/doom install
}

function install_ohmyzsh {
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh $HOME/.oh-my-zsh
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

function git_config {
  source "$SCRIPTDIR/init-git.sh"
}

function install {
  install_softs
  install_dotfiles
  install_ohmyzsh
  install_vim_config
  git_config
}

stop=false
until $stop; do
  echo "select action to do:"
  select action in softs dotfiles doom ohmyzsh git vim all; do
    case $action in 
      softs) install_softs;;
      dotfiles) install_dotfiles;;
      ohmyzsh) install_ohmyzsh;;
      doom) install_doom;;
      git) git_config;;
      vim) install_vim_config;;
      all) install;;
      *) stop=true;;
    esac
    break
  done
done
