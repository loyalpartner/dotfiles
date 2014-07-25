#!/bin/bash
script_dir="$( cd "$( dirname "$0" )" && pwd )"

if git clone https://github.com/loyalpartner/dotvim.git dotvim
then
    cd dotvim
    echo `pwd`
    #echo $script_dir
fi
