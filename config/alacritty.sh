#!/bin/bash

DIR=${DIR:-$(pwd)}

mkdir -p $HOME/.config/alacritty
if [[ $OSTYPE =~ ^darwin ]]; then
    ln -sfn $DIR/alacritty/alacritty.macosx.yml $HOME/.config/alacritty/alacritty.yml
else
    ln -sfn $DIR/alacritty/alacritty.linux.yml $HOME/.config/alacritty/alacritty.yml
fi
