#!/bin/bash

is_tmux() {
  if [ -n "$TMUX" ]; then
    return 0
  else
    return 1
  fi
}
