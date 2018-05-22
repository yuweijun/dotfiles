#!/bin/bash

if [ ! -e $HOME/.fzf ]; then
    ln -sfn ${DIR}/fzf $HOME/.fzf
fi

if grep -q "/.fzf." ${RCFILE} 2> /dev/null; then
    echo "fzf config exists"
elif ! $SIMPLE; then
    if [[ "$SHELL" = "/bin/zsh" ]]; then
        $HOME/.fzf/install --no-bash --no-zsh
    else
        $HOME/.fzf/install --no-bash --no-zsh
    fi
fi
