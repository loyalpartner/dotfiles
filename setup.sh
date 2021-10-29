#!/usr/bin/env bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"

install_softs(){
  if which pacman > /dev/null
  then
    sudo pacman -S --noconfirm sway \
      alacritty vim tigervnc \
      nerd-fonts-source-code-pro \
      google-chrome-stable \
      wqy-microhei bash-completion \
      tmux ctags
    yay -S --noconfirm clipman
  fi
}

install_softs

link_dot_configs(){
  ln -vfs $script_dir/zsh/zshrc.zsh ~/.zshrc
  ln -vfs $script_dir/tmux.conf ~/.tmux.conf
}

link_config_dir(){
  [[ -h "$2" ]] || ln -vfs $script_dir/$1 $2
}

link_config_dir "$script_dir/.ctags.d" "$HOME/.ctags.d"
link_config_dir "$script_dir/sway" "$HOME/.config/sway"
link_config_dir "$script_dir/alacritty" "$HOME/.config/alacritty"


source "$script_dir/init-git.sh"

if [[ ! -d $HOME/.oh-my-zsh ]]
then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

link_dot_configs
