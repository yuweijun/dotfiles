#!/bin/bash

if [ ! -f $HOME/.tmux.conf ]; then
    DIR=${DIR:-$(pwd)}

    ln -sfn ${DIR}/tmux/tmux.linux.conf $HOME/.tmux.conf
fi

