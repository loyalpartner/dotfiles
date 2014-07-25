#!/bin/bash
script_dir="$( cd "$( dirname "$0" )" && pwd )"

git_clone()
{
    if git clone https://github.com/loyalpartner/dotfiles.git dotfiles >> /dev/null
    then
        cd dotfiles
        cat setup.sh | sh
    fi
}

[ -d dotfiles ] && rm dotfiles.bak ||  mv dotfiles dotfiles.bak -fv && git_clone

