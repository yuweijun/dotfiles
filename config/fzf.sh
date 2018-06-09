#!/bin/bash

if [ ! -e $HOME/.fzf ]; then
    ln -sfn ${DIR}/fzf $HOME/.fzf
fi

