# current workspace name
# WORKSPACE_NAME=$(swaymsg -t get_workspaces |
#   jq '.[] | select(.focused==true).name')
# S1=".. | select(.name?==$WORKSPACE_NAME and .type==\"workspace\")"
# S2='.. | select(.type?=="floating_con" and .visible==true).pid'
# PIDS="$(swaymsg -t get_tree | jq "$S1 | $S2")"

# for _ in $PIDS; do
#   swaymsg "scratchpad show"
# done && swaymsg "$1"

for id in $(swaymsg -t get_tree | jq '.. | select(.type? == "floating_con") | .id');do
  swaymsg "[con_id=$id]" move scratchpad
done
