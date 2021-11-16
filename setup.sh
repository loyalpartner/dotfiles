#!/usr/bin/env bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

install_softs(){
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
      nodejs npm clash
    yay -S --noconfirm clipman \
      google-chrome \
      nerd-fonts-source-code-pro
  fi
}

install_softs
if [[ ! -d $HOME/.oh-my-zsh ]]
then
  git clone https://github.com/ohmyzsh/ohmyzsh $HOME/.oh-my-zsh && sh $HOME/.oh-my-zsh/tools/install.sh
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
link_dot_configs(){
  ln -vfs $script_dir/zsh/zshrc.zsh ~/.zshrc
  ln -vfs $script_dir/tmux.conf ~/.tmux.conf
}

link_config_dir(){
  [[ -h "$2" ]] || ln -vfs $1 $2
}

# link_config_dir $script_dir/ctags.d/ $HOME/.ctags.d
cp -rf $script_dir/ctags.d $HOME/.ctags.d
link_config_dir $script_dir/sway/ $HOME/.config/sway
link_config_dir $script_dir/waybar/ $HOME/.config/waybar
link_config_dir $script_dir/wofi/ $HOME/.config/wofi
link_config_dir $script_dir/alacritty/ $HOME/.config/alacritty
link_dot_configs

source "$script_dir/init-git.sh"

