#!/usr/bin/env bash

# set -e

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
_path_relative_xdg_config_home() {
  echo ${XDG_CONFIG_HOME:-$HOME/.config}/$1
}

_path_relative_script_home() {
  echo $SCRIPT_DIR/$1
}

_ensure_directory_exists() {
  local dir
  dir=$(_path_relative_xdg_config_home $1)
  echo "ensure $dir exists"
  rm -rf ${dir:-/tmp/nonexist}
  mkdir -p $dir
}

ERROR='\033[0;31m'
WARN='\033[0;33m'

warn() {
  echo ${WARN} $@
}

info() {
  echo $@
}

error() {
  echo ${ERROR} $@
}

_executable() {
  local cmd=$1
  which $cmd >> /dev/null
}

_is_ubuntu() { [[ "$(lsb_release -is)" =~ "Ubunutu" ]] }

_is_arch() { [[ "$(lsb_release -is)" =~ "Arch" ]] }

_arch() {
  architecture=""
  case $(uname -m) in
    i386)   architecture="386" ;;
    i686)   architecture="386" ;;
    x86_64) architecture="amd64" ;;
    arm)    dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
  esac
  echo $architecture
}

_install_package() {
  _executable sudo || (error "sudo isn't installed" && return 1)

  local package=$1

  if _executable yay; then
    yay -Sy --noconfirm $package
  elif _executable pacman; then
    sudo pacman -Sy --noconfirm $package
  elif _executable apt; then
    sudo apt install $package
  fi
}

_install_packages() {
  _executable sudo || (error "sudo isn't installed" && return 1)

  if _executable yay; then
    yay -Syu
    yay -S --noconfirm $@
  elif _executable pacman; then
    sudo pacman -Syu
    sudo -S --noconfirm $@
  elif _executable apt; then
    sudo apt update
    sudo apt install $@
  fi
}

_setup_wayland_enviroments() {
  local packages=(sway dmenu)

  if _is_arch; then
    # add otf-font-awesome if waybar icon not appeared
    packages+=( 
      waybar wofi clipman
      xorg-xwayland xorg-xlsclients qt5-wayland glfw-wayland
    )
  elif _is_ubuntu; then
    packages+=(fonts-font-awesome)
  fi

  _install_packages ${packages[@]}
  _jetbrains_mono_setup
}

_jetbrains_mono_setup() {
  # https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/font-info.md
  setup_script="https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh"
  bash -c $("curl -fsSL $setup_script)")
}

_setup_gui_enviroments() {
  local packages=(
    alacritty google-chrome
    gvim emacs
  )

  if _is_arch; then
    packages+=( 
      tigervnc wqy-microhei 
      fcitx5 fcitx5-chinese-addons fcitx5-qt
      fcitx5-pinyin-zhwiki fcitx5-configtool kcm-fcitx5
      alsa-utils pulseaudio pamixer pavucontrol pulseaudio-alsa
      nutstore-experimental
      # nerd-fonts-source-code-pro
      # nerd-fonts-jetbrains-mono
    )
  elif _is_ubuntu; then
    packages+=( 
      fcitx5 fcitx5-chinese-addons
      fcitx5-frontend-gtk3 fcitx5-frontend-gtk2
      fcitx5-frontend-qt5
    )
  fi

  _install_packages ${packages[@]}
}

_clash_setup() {
  local arch url filename
  arch=$(_arch)
  platform=$(uname -s)
  # filename=clash-${platform@L}-$arch-latest.gz
  filename=clash-${platform,}-$arch-latest.gz
  url=https://release.dreamacro.workers.dev/latest/$filename

  tmpdir=$(_path_relative_xdg_config_home clash)
  tmpfile=$tmpdir/$filename

  # warn create temp directory $tmpdir
  curl -fsSL -o $tmpfile --create-dirs $url &&
    (cd $tmpdir &&
      gunzip -f $tmpfile &&
      chmod +x ${filename%.*} &&
      sudo install -m755 ${filename%.*} /usr/bin/clash)
  if _executable systemctl; then
    cat << EOF | sudo tee /etc/systemd/system/clash.service > /dev/null
[Unit]
Description=Clash daemon, A rule-based proxy in Go.
After=network.target network-online.target nss-lookup.target 

[Service]
Type=simple
Restart=always
ExecStart=/usr/bin/clash -d /etc/clash

[Install]
WantedBy=multi-user.target
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart clash
  fi

}

_update_packages_index() {
  if _executable yay; then
    yay -Syu
  elif _executable pacman; then
    sudo pacman -Syu
  elif _executable apt; then
    sudo apt update
  fi
}

_setup_basic_enviroments() {
  local packages=(
    gvim tmux ctags bash-completion zsh man-db
    jq ripgrep fzf fd autojump curl
    sshuttle tree
  )

  if _is_arch; then
    packages+=(mlocate)
  elif _is_ubuntu; then
    packages+=(locate)
  fi

  _install_packages ${packages[@]}
}

_nltk_setup() {
  python3 -m nltk.downloader popular
}

_setup_python_enviroments() {
  local packages=()

  if _is_arch; then
    packages+=(pyenv python python-pip)
  elif _is_ubuntu; then
    packages+=(python)
  fi

  _install_packages ${packages[@]}

  if _executable pip; then
    pip_packages=( 
      wordfreq nltk bs4 # basic
      pudb # python debugger
    )
    pip install ${pip_packages[@]}
    _nltk_setup
  fi
}

_setup_go_enviroments() {
  local packages=(protobuf)

  if _is_arch; then
    packages+=(go)
  elif _is_ubuntu; then
    packages+=(golang)
  fi

  go env -w GOPATH=$HOME/go
  go env -w GOBIN=$HOME/go/bin
  go env -w GOPROXY=https://goproxy.cn,direct

  # setup vim.go
  go_packages=(
    github.com/klauspost/asmfmt/cmd/asmfmt@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/kisielk/errcheck@latest
    github.com/rogpeppe/godef@latest
    github.com/mgechev/revive@latest
    golang.org/x/tools/gopls@latest
    github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    honnef.co/go/tools/cmd/staticcheck@latest
    github.com/fatih/gomodifytags@latest
    github.com/fatih/motion@latest
    golang.org/x/tools/cmd/goimports@master
    github.com/davidrjenni/reftools/cmd/fillstruct@master
    golang.org/x/tools/cmd/gorename@master
    github.com/jstemmer/gotags@master
    golang.org/x/tools/cmd/guru@master
    github.com/josharian/impl@master
    honnef.co/go/tools/cmd/keyify@master
    github.com/koron/iferr@master
  )

  for pkg in ${go_packages[@]}; do
    go install ${go_packages[@]}
  done
}

_setup_rust_enviroments() {
  warn TODO
}

_nvm_setup() {
  export NVM_DIR="$HOME/.nvm" && (
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cd "$NVM_DIR"
    git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  ) && \. "$NVM_DIR/nvm.sh"
}

_setup_node_enviroments() {
  _nvm_setup || (error nvm setup failed && return 0)

  nvm install node
  npm install -g yarn

  npm_packages=(
    source-map-support prettier eslint ts-node
  )

  yarn global add ${npm_packages[@]}
}

_setup_chromium_development_enviroments() {
    packages=(
      python perl gcc gcc-libs bison flex gperf
      pkgconfig nss alsa-lib glib2 gtk3 nspr 
      freetype2 cairo dbus libgnome-keyring
      xorg-server-xvfb xorg-xdpyinfo
    )
    if _is_arch; then 
      _install_packages ${packages[@]}
    else
      error unspport platform
    fi
}

_setup_c_enviroments() {
  local packages=(
    gcc llvm clang clangd gdb cgdb
  )

  if _is_arch; then
    packages+=()
  elif _is_ubuntu; then
    packages+=()
  fi

  _install_packages ${packages[@]}
}

_setup_all_languages_enviroments() {
  _setup_python_enviroments
  _setup_node_enviroments
  _setup_go_enviroments
  _setup_rust_enviroments
  _setup_c_enviroments
}

_setup_specific_language_enviroments() {
  local language=$1
  case $language in 
    all   )
      _setup_all_languages_enviroments
      break;;
    python|node|go|rust|c) 
      eval _setup_${language}_enviroments
      break
      ;;
    *     ) break ;;
  esac
}

_setup_program_enviroments() {
  languages=(all python node golang rust)
  select language in ${languages[@]}; do
    _setup_specific_language_enviroments $language
  done
}

_setup_all_enviroments() {
  _update_packages_index
  _setup_basic_enviroments
  _setup_gui_enviroments
  _setup_wayland_enviroments
  _setup_chromium_development_enviroments
  _setup_all_languages_enviroments
  _clash_setup
}

_setup() {
  actions=(all basic gui wayland program update-index)
  select action in ${actions[@]}; do
    case $action in 
      all|basic|gui|wayland|chromium) 
        eval _setup_${action}_enviroments
        break
        ;;
      update-index) _update_packages_index; break ;;
      *     ) warn selected none; break ;;
    esac
  done
}
