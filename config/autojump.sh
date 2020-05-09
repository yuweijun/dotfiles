#!/bin/bash

if [ ! -e "$HOME/.autojump" ]; then
    if type python &>/dev/null; then
        DIR=${DIR:-$(pwd)}
        cd "${DIR}/autojump" || return
        ./install.py
        cd - || return
    fi
fi

