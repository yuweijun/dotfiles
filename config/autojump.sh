#!/bin/bash

if [ ! -e "$HOME/.autojump" ]; then
    DIR=${DIR:-$(pwd)}

    if type python &>/dev/null; then
        cd "${DIR}/autojump" || return
        ./install.py
        cd - || return
    fi
fi

