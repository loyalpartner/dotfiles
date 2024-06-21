#!/bin/bash

#
# 获取当前激活的窗口
# 窗口是要切换的窗口
#   隐藏窗口
# 窗口不是要切换的窗口
#   激活窗口
#     如果目标窗口存在激活
#     启动应用
switch_to_() {
  local target="$1"
  local executable=$2

  local selector='
    .nodes[].nodes[] | recurse(.nodes[]?) |
    select(.type == "workspace").nodes[]?, select(.type == "workspace").floating_nodes[]? |
    select(.focused == true)
  '
  local app_id=$(swaymsg -t get_tree | jq "$selector" | jq -r ".app_id")

  if [ "$app_id" = "$target" ]; then
    swaymsg "[app_id=$target]" scratchpad show
    return
  fi

  local selector=$(printf '.. | select(.app_id? == "%s")' $target)
  target_window=$(swaymsg -t get_tree | jq -e --args "$selector")
  if [ $? -eq 0 ] ; then
    # 检查窗口是隐藏还是显示的
    local visible="$(echo $target_window | jq -e ".visible")"
    if [[ "$visible" == "true" ]]; then
      swaymsg "[app_id=$target]" scratchpad show
      swaymsg "[app_id=$target]" scratchpad show
    else
      swaymsg "[app_id=$target]" scratchpad show
    fi
  else
    $2
  fi
}

# fuzzy_switch_to 'chrome-chat.openai.com.*'  chromium --app=https://chat.openai.com
fuzzy_switch_to() {
  local target="$1"

  local selector='
    .nodes[].nodes[] | recurse(.nodes[]?) |
    select(.type == "workspace").nodes[]?, select(.type == "workspace").floating_nodes[]? |
    select(.focused == true)
  '
  local app_id=$(swaymsg -t get_tree | jq "$selector" | jq -r ".app_id")
  if [[ "$app_id" =~ $target ]]; then
    swaymsg "[app_id=$target]" scratchpad show
    return
  fi

  local selector=$(printf '.. | select(.app_id? //"" | test("%s"))' $target)
  target_window=$(swaymsg -t get_tree | jq -e --args "$selector")
  if [ $? -eq 0 ] ; then
    # 检查窗口是隐藏还是显示的
    local visible="$(echo $target_window | jq -e ".visible")"
    if [[ "$visible" == "true" ]]; then
      swaymsg "[app_id=$target]" scratchpad show
      swaymsg "[app_id=$target]" scratchpad show
    else
      swaymsg "[app_id=$target]" scratchpad show
    fi
  else
    ${@:2}
  fi
}
