#!/bin/bash
script_dir="$( cd "$( dirname "$0" )" && pwd )"

git_clone()
{
    
    echo 'choose ssh or https:'
    echo '1) ssh'
    echo '2) https'

    read url_no
    
    case $url_no in
        1)
            url=git@github.com:loyalpartner/dotfiles.git
            ;;
        *)
            url=https://github.com/loyalpartner/dotfiles.git
            ;;
    esac

    if git clone $url dotfiles > /dev/null
    then
        cd dotfiles
        cat setup.sh | sh
    fi
}

[ -d dotfiles ] && mv dotfiles dotfiles.bak -fv 
git_clone

