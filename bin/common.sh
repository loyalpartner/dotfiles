#!/bin/bash
function win_focused() {
  local selector='
    .nodes[].nodes[] | recurse(.nodes[]?) |
    select(.type == "workspace").nodes[]?, select(.type == "workspace").floating_nodes[]? |
    select(.focused == true)
  '
  echo "$(swaymsg -t get_tree | jq "$selector")"
}

function win_focused_is_float() {
  local result=$(win_focused)
  local type=$(echo $result | jq -r ".type")
  test "floating_con" = "$type" && return 0 || return 1
}

function win_focused_appid() {
  echo $(win_focused | jq -r ".app_id")
}

# unused
function floatwin_selected_by_appid() {
  local target="$1"
  local selector=$(printf '.. | select(.app_id? == "%s")' $target)
  local result=$(swaymsg -t get_tree | jq -e --args "$selector")
  if [ $? -eq 0 ] ; then
    echo $result
  else
    return 1
  fi
}

function floatwin_move_to_center_by_appid() {
  local app_id="$1"
  swaymsg "[app_id=$app_id]" 'resize set 95 ppt 95 ppt; move position center'
}

# 获取最左边的显示器
output_name=$(swaymsg -t get_outputs | jq -r '[.[] | select(.active) | {name, x: .rect.x}] | min_by(.x) | .name')

function floatwin_show_by_appid() {
  local app_id="$1"
  swaymsg "[app_id=$app_id]" move to output $output_name
  swaymsg "[app_id=$app_id]" focus
  floatwin_move_to_center_by_appid $app_id
}

function floatwin_back_to_last_window() {
  swaymsg "[con_mark=last_window]" focus
  unmark last_window
}

function floatwin_mark() {
  if win_focused_is_float; then
    return
  fi

  swaymsg mark last_window
}


# 获取当前激活的窗口
# 窗口是要切换的窗口
#   隐藏窗口
# 窗口不是要切换的窗口
#   激活窗口
#     如果目标窗口存在激活
#     启动应用
switch_to_() {
  local appid="$1"

  # 获取当前激活的窗口 id
  local focused_app_id=$(win_focused_appid)

  if [ "$focused_app_id" = "$appid" ]; then
    # swaymsg "[app_id=$appid]" scratchpad show
    floatwin_back_to_last_window
    return
  fi

  floatwin_mark

  local selector=$(printf '.. | select(.app_id? == "%s")' $appid)
  target_window=$(swaymsg -t get_tree | jq -e --args "$selector")
  if [ $? -eq 0 ] ; then
    local visible="$(echo $target_window | jq -e ".visible")"
    if [[ "$visible" == "true" ]]; then
      swaymsg "[app_id=$appid]" focus
    else
      floatwin_show_by_appid $appid
    fi

    floatwin_move_to_center_by_appid $appid
  else
    notify-send "switch_to_" "启动应用"
    ${@:2}
  fi
}

# fuzzy_switch_to 'chrome-chat.openai.com.*'  chromium --app=https://chat.openai.com
fuzzy_switch_to() {
  local app_id="$1"
  local focused_app_id=$(win_focused_appid)

  if [[ "$focused_app_id" =~ $app_id ]]; then
    floatwin_back_to_last_window
    return
  fi

  floatwin_mark

  local selector=$(printf '.. | select(.app_id? //"" | test("%s"))' $app_id)
  target_window=$(swaymsg -t get_tree | jq -e --args "$selector")
  if [ $? -eq 0 ] ; then
    # 检查窗口是隐藏还是显示的
    local visible="$(echo $target_window | jq ".visible")"
    if [[ "$visible" == "true" ]]; then
      swaymsg "[app_id=$app_id]" focus
    else
      floatwin_show_by_appid $app_id
    fi

    floatwin_move_to_center_by_appid $app_id
  else
    ${@:2}
  fi
}

switch_to_instance() {
  local instance="$1"

  local selector='
    .nodes[].nodes[] | recurse(.nodes[]?) |
    select(.type == "workspace").nodes[]?, select(.type == "workspace").floating_nodes[]? |
    select(.focused == true)
  '
  local focused_instance=$(swaymsg -t get_tree | jq "$selector" | jq -r ".window_properties?.instance")

  if [ "$focused_instance" = "$instance" ]; then
    swaymsg "[instance=$instance]" scratchpad show
    return
  fi

  local selector=$(printf '.. | select(.window_properties?.instance? == "%s")' $instance)
  target_window=$(swaymsg -t get_tree | jq -e "$selector")
  if [ $? -eq 0 ] ; then
    # 检查窗口是隐藏还是显示的
    local visible="$(echo $target_window | jq -e ".visible")"
    if [[ "$visible" == "true" ]]; then
      swaymsg "[instance=$instance]" focus
    else
      # swaymsg "[instance=$instance]" scratchpad show
      swaymsg "[instance=$instance]" focus
    fi

    swaymsg "[instance=$instance]" resize set 95 ppt 95 ppt
    swaymsg "[instance=$instance]" move position center
  else
    $2
  fi
}


hide_floatwin() {
  for id in $(swaymsg -t get_tree | jq '.. | select(.type? == "floating_con") | .id');do
    swaymsg "[con_id=$id]" move scratchpad
  done
}
