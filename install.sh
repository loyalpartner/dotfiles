#!/usr/bin/env bash

# Default command if no arguments provided
COMMAND=${1:-all}

# Clone repository if it doesn't exist
if [ ! -d "$HOME/dotfiles" ]; then
    git clone https://github.com/loyalpartner/dotfiles.git "$HOME/dotfiles"
fi

# Execute setup script with provided arguments or default command
bash "$HOME/dotfiles/setup.sh" "$COMMAND"

