# swaymsg -t get_workspaces | jq '.[] | select(.focused==true).num'
SELECTOR='.. | select(.type?=="floating_con" and .visible==true).pid'
PIDS="$(swaymsg -t get_tree | jq "$SELECTOR" )"

for _ in $PIDS; do
  swaymsg "scratchpad show"
done && swaymsg "$1"
