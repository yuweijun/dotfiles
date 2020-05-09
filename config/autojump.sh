#!/bin/bash

if [ ! -e "$HOME/.autojump" ]; then
    if type python &>/dev/null; then
        DIR=${DIR:-$(pwd)}
        if [ ! -d "${DIR}/autojump" ]; then
            git clone --depth=1 https://github.com/yuweijun/autojump.git "${DIR}/autojump"
        fi
        cd "${DIR}/autojump" || return
        ./install.py
        cd - || return
    fi
fi

