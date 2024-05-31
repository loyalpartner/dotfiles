#!/usr/bin/env sh

executable="${1:-zsh}"

# sudo ip route add 10.218.0.119 via 192.168.10.10

ip_addr=$(ip addr show dev enp1s0 | grep inet | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
sudo ip netns exec hacknet ip route add $ip_addr via 100.200.10.10 > /dev/null 2>&1


shell_execute(){
  sudo ip netns exec hacknet su `whoami` -c \
    "scope exec --pid '$$';$executable -i"
}

shell(){
  # sudo ip netns exec hacknet su `whoami` -c \
  #   "scope exec --pid '$$';$executable -i"
  scope shell
}

app_execute(){
  sudo ip netns exec hacknet su `whoami` -c \
    "scope exec --pid '$$';$executable &"
}


if [[ "$executable" =~ (zsh|bash) ]]; then
  shell
elif [[ "$executable" =~ \.sh$ ]]; then
  shell_execute
else
  # app_execute
  # nohup firejail --noprofile --dns=114.114.114.114 --netns=hacknet "$@" > /dev/null 2>&1 &
  # scope exec --pid $!
  scope shell -c google-chrome-stable
fi

# cmd=""
# # -c shell command
# while getopts "ca:" opt
# do
#   case $opt in
#     c) shift; cmd=$@ ;;
#     *) ;;
#   esac
# done
