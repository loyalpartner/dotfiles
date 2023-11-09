#!/bin/bash

# dependences:
#  - jq
#  - chrome-remote-interface
#
#  ${XDG_HOME_CONFIG:-~/.config}/chrome-flags.conf
#
#  usage:
#   add `remote-debugging-port` flag
#   ```
#   --remote-debugging-port=9222
#   ```
# 
#   rofi -show -modes "tabs:rofi-chrome-tabs.sh"
#
REMOTE_BIN="chrome-remote-interface"

function executable {
  local cmd=$1
  which $cmd &> /dev/null
}

function check_deps {
  if ! executable $REMOTE_BIN; then
    REMOTE_BIN="$HOME/.yarn/bin/$REMOTE_BIN"
  else 
    REMOTE_BIN=$(which $REMOTE_BIN)
  fi

  [[ ! -f $REMOTE_BIN ]] &&
    echo "yarn global add chrome-remote-interface" &&
    exit 0
}

function list_candidates {
    SELECTOR='.[] | select(.type == "page") | .title + "\\0info\\x1f" + .id + "\\n"'
    CANDIDATES=$($REMOTE_BIN list |jq -rj "$SELECTOR")
    echo -en $CANDIDATES
}

function switch_to_selected_tab {
    $REMOTE_BIN activate "${TAB_ID:-$ROFI_INFO}"
}

function main {
  check_deps
  if [[ "$ROFI_RETV" -eq "0" ]]; then
    list_candidates
  else
    switch_to_selected_tab
  fi
}

main
