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
echo $ROFI_RETV >> /tmp/logs
if [[ "$ROFI_RETV" -eq "0" ]]; then
    SELECTOR='.[] | select(.type == "page") | .title + "\\0info\\x1f" + .id + "\\n"'
    CANDIDATES=$(chrome-remote-interface list |jq -rj "$SELECTOR")
    echo -en $CANDIDATES
else
    TAB_ID="$ROFI_INFO"
    # TAB_TITLE="$(chrome-remote-interface list | jq -r --arg tab_id "$TAB_ID" 'map(select(.id == $tab_id))[] | .title')"

    chrome-remote-interface activate "$TAB_ID"
fi
