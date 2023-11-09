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

function prepare {
  if ! executable $REMOTE_BIN; then
    REMOTE_BIN="$HOME/.yarn/bin/$REMOTE_BIN"
  else 
    REMOTE_BIN=$(which $REMOTE_BIN)
  fi

  [[ ! -f $REMOTE_BIN ]] &&
    echo "yarn global add chrome-remote-interface" &&
    exit 0
}

function main {
  if [[ "$ROFI_RETV" -eq "0" ]]; then
    SELECTOR='.[] | select(.type == "page") | .title + "\\0info\\x1f" + .id + "\\n"'
    CANDIDATES=$($REMOTE_BIN list |jq -rj "$SELECTOR")
    echo -en $CANDIDATES
  else
    TAB_ID="$ROFI_INFO"
    # TAB_TITLE="$(chrome-remote-interface list | jq -r --arg tab_id "$TAB_ID" 'map(select(.id == $tab_id))[] | .title')"

    chrome-remote-interface activate "$TAB_ID"
  fi
}

prepare
main
