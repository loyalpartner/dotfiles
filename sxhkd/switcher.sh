#!/usr/bin/env bash

# wid=$(xdotool search --class $1 | tail -1)

# v1
# if [[ -z "$wid" ]]; then 
#   nohup $1 &
# elif [[ "$wid" == "$(xdotool getactivewindow)" ]]; then
#   xdotool windowminimize $wid 
# else
#   xdotool windowactivate $wid 
# fi

# v2
# [[ -z "$wid" ]] && nohup $1 || [[ "$wid" == "$(xdotool getactivewindow)" ]] && xdotool windowminimize $wid || xdotool windowactivate $wid 

# v3
# xdotool search --desktop "$(xdotool get_desktop)" --onlyvisible --class $1 windowactivate || $1 &


# v4
desktop="$(xdotool get_desktop)"
awid="$(xdotool getactivewindow)" # 获取当前窗口id
nwid="$(xdotool search --desktop $desktop --onlyvisible --class $1 | tail -1)" # 获取上次 xxx 程序使用的窗口id

# 上次使用的窗口是活动窗口，选择该程序的下一个窗口
if [[ $awid == $nwid  ]]; then
  xdotool search --desktop "$(xdotool get_desktop)" --onlyvisible --class $1 windowactivate || $1 &
else
  xdotool windowactivate $nwid || $1 &
fi
