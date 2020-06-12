#!/usr/bin/env bash

wid=$(xdotool search --class $1 | tail -1)

# if [[ -z "$wid" ]]; then 
#   nohup $1 &
# elif [[ "$wid" == "$(xdotool getactivewindow)" ]]; then
#   xdotool windowminimize $wid 
# else
#   xdotool windowactivate $wid 
# fi

[[ -z "$wid" ]] && nohup $1 || [[ "$wid" == "$(xdotool getactivewindow)" ]] && xdotool windowminimize $wid || xdotool windowactivate $wid 
