#!/usr/bin/env sh

executable="${1:-zsh}"

# sudo ip route add 10.218.0.119 via 192.168.10.10

export HTTP{,S}_PROXY=
export http{,s}_proxy=

ip_addr=$(ip addr show dev enp1s0 | grep inet | awk '{print $2}' | cut -d'/' -f1 | head -n 1)
sudo ip netns exec hacknet ip route add $ip_addr via 100.200.10.10 > /dev/null 2>&1

if [[ "$executable" =~ (zsh|bash) ]]; then
  sudo ip netns exec hacknet su `whoami` -c \
    "scope exec --pid '$$';$executable -i"
else
  nohup firejail --noprofile --dns=114.114.114.114 --netns=hacknet "$@" > /dev/null 2>&1 &
  scope exec --pid $!
fi
