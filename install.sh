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

if [ -d dotfiles ]
then

    echo 'dotfiles alread exists:'
    echo '是否备份(Y|N)：'

    read CONFIRM

    if [ "X$CONFIRM" = "Xy" ] || [ "X$CONFIRM" = "XY" ]
    then
        mv dotfiles dotfiles.bak -fv
        git_clone
    fi
else
    git_clone
fi

