#!/usr/bin/env sh

script_dir="$( cd "$( dirname "$0" )" && pwd )"

function install_softs {
  if which pacman > /dev/null
  then
    sudo pacman -S --noconfirm sway \
      alacritty vim tigervnc \
      wqy-microhei bash-completion \
      tmux ctags zsh alacritty \
      dmenu waybar wofi \
      xorg-xwayland xorg-xlsclients \
      qt5-wayland glfw-wayland \
      fcitx5-chinese-addons fcitx5-git fcitx5-gtk fcitx5-qt \
      fcitx5-pinyin-zhwiki fcitx5-configtool kcm-fcitx5 \
      alsa-utils pulseaudio pamixer pavucontrol pulseaudio-alsa \
      nodejs npm clash fd nutstore-experimental
    yay -S --noconfirm clipman \
      google-chrome \
      nerd-fonts-source-code-pro \
      nerd-fonts-jetbrains-mono
  fi
}

function link_dot_configs {
  ln -vfs $script_dir/zsh/zshrc.zsh ~/.zshrc
  ln -vfs $script_dir/tmux.conf ~/.tmux.conf
}

function link_config_dir {
  [[ -h "$2" ]] || ln -vfs $1 $2
}

function install_dotfiles {
  cp -rf $script_dir/ctags.d $HOME/.ctags.d
  link_config_dir $script_dir/sway/ $HOME/.config/sway
  link_config_dir $script_dir/waybar/ $HOME/.config/waybar
  link_config_dir $script_dir/wofi/ $HOME/.config/wofi
  link_config_dir $script_dir/alacritty/ $HOME/.config/alacritty
  link_dot_configs
}

function install_ohmyzsh {
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh $HOME/.oh-my-zsh && sh $HOME/.oh-my-zsh/tools/install.sh
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

function git_config {
  source "$script_dir/init-git.sh"
}

function install {
  install_softs
  install_dotfiles
  install_ohmyzsh
  git_config
}

echo "select action to do:"
select action in softs dotfiles ohmyzsh git all; do
  case $action in 
    softs) install_softs;;
    dotfiles) install_dotfiles;;
    ohmyzsh) install_ohmyzsh;;
    git) git_config;;
    all) install;;
    *) break;;
  esac
done

