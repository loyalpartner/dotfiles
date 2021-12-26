# swaymsg -t get_workspaces | jq '.[] | select(.focused==true).num'

for pid in $(swaymsg -t get_tree | jq '.. | select(.type?=="floating_con" and .visible==true).pid'); do
  swaymsg "scratchpad show"
done
