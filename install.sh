#!/bin/bash
script_dir="$( cd "$( dirname "$0" )" && pwd )"

if git clone https://github.com/loyalpartner/dotfiles.git dotfiles
then
    cd dotfiles
    ./setup.sh
fi
