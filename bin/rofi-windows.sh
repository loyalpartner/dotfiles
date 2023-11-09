#!/bin/bash

function list_candidates {
  CANDIDATE_FORMAT='.window_properties.class+" "+.window_properties.title+"\\0info\\x1f"+(.id|tostring)+"\\n"'
  SELECTOR='..|select(.window?!=null and .name?!=null)|'"$CANDIDATE_FORMAT"

  CANDIDATES=$(swaymsg -t get_tree | jq -rj "$SELECTOR")
  echo -en $CANDIDATES
}

function switch_to_candidate {
  swaymsg [con_id=${COND_ID:-$ROFI_INFO}] focus > /dev/null
}

function main {
  if [[ "$ROFI_RETV" -eq "0" ]]; then
    list_candidates
  else
    switch_to_candidate
  fi
}

main
