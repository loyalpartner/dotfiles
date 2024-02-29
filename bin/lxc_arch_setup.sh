#!/usr/bin/env bash

declare instance user

lxc_create_arch() {
  lxc launch mirror-images:archlinux $instance ||
    echo create archlinux instance faild

  sleep 1
  local pattern sedcmd packages
  pattern="# %wheel ALL=(ALL:ALL) NOPASSWD: ALL"
  sedcmd="/$pattern/a $user ALL=(ALL:ALL) NOPASSWD: ALL"

  packages=(sudo git vim)
  container_exec -- pacman -Sy --needed --noconfirm ${packages[@]}
  container_exec -- useradd -m $user
  container_exec -- sed -i "$sedcmd" /etc/sudoers

  [[ $full ]] && full_setup

}

full_setup() {
  container_exec -- curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash
}

container_exec(){
  lxc exec $instance "$@"
}

usage (){
  local script=${0##*/}
  echo "Usage: $script -n <instance_name> -u <user>

    Options:
    -n            Instance name
    -u            User name
    -f            Full setup
    -h            Display this message
    -v            Display script version"

}

while getopts "hfvn:u:" opt
do
  case $opt in
    h|help    ) usage; exit 0 ;;
    v|version ) echo "Version 0.0.1"; exit 0 ;;
    f|full    ) full=true ;;
    n|instance) instance="$OPTARG" ;;
    u|user    ) user="$OPTARG" ;;
    * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage; exit 1   ;;
  esac
done

if [[ -z $instance || -z $user ]]; then
  usage; exit 1
fi

shift $(($OPTIND-1))
lxc_create_arch
