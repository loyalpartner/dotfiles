#!/bin/bash
script_dir="$( cd "$( dirname "$0" )" && pwd )"

git_clone()
{
    if git clone https://github.com/loyalpartner/dotfiles.git dotfiles
    then
        cd dotfiles
        cat setup.sh | sh
    fi
}

[ -d dotfiles ] && mv dotfiles dotfiles.bak -fv
git_clone

