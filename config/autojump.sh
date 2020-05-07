#!/bin/bash

if [ ! -e "$HOME/.autojump" ]; then
    DIR=${DIR:-$(pwd)}

    if type python 2&>/dev/null; then
        cd "${DIR}/autojump" || return
        export SHELL=/bin/bash
        ./install.py
        cd - || return
    fi
fi

