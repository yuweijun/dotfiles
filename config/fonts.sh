#!/bin/bash

DIR=${DIR:-$(pwd)}
NAME="Hack Regular Nerd Font Complete.ttf"
FONT="$DIR/nerd-fonts/$NAME"

if [[ $OSTYPE =~ ^darwin ]]; then
    cd ~/Library/Fonts
    if [ -f "$NAME" ]; then
        echo "$NAME font exists"
    else
        echo "$NAME not exists"
        cp "$FONT" .
    fi
else
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    if [ -f "$NAME" ]; then
        echo "$NAME font exists"
    else
        echo "$NAME not exists"
        cp "$FONT" .
        # install fontconfig for linux
        fc-config -fv
    fi
fi

