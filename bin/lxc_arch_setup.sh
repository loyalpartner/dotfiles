#!/usr/bin/env bash

declare instance user

lxc_create_arch() {
  lxc launch images:archlinux $instance
  if [[ $? != 0 ]]; then
    echo create archlinux instance faild
  fi

  local pattern sedcmd packages
  pattern="# %wheel ALL=(ALL:ALL) NOPASSWD: ALL"
  sedcmd="/$pattern/a $user ALL=(ALL:ALL) NOPASSWD: ALL"

  packages=(sudo git vim)
  container_exec -- pacman -S --needed --noconfirm $packages
  container_exec -- useradd -m $user
  container_exec -- sed -i "$sedcmd" /etc/sudoers
  # container_exec -- curl -fsSL https://raw.githubusercontent.com/loyalpartner/dotfiles/master/install.sh | bash
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
    -h            Display this message
    -v            Display script version"

}

while getopts "hvn:u:" opt
do
  case $opt in
    h|help     )  usage; exit 0   ;;
    v|version  )  echo "Version 0.0.1"; exit 0   ;;
    n|instance)   instance="$OPTARG" ;;
    u|user)   user="$OPTARG" ;;
    * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage; exit 1   ;;
  esac
done

if [[ -z $instance || -z $user ]]; then
  usage; exit 1
fi

shift $(($OPTIND-1))
lxc_create_arch
