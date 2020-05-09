#!/usr/bin/env zsh

if [ -d "$HOME/.fzf" ]; then
    if [[ ! "$PATH" == *.fzf/bin* ]]; then
        export PATH="$PATH:$HOME/.fzf/bin"
    fi

    [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
    source "$HOME/.fzf/shell/key-bindings.zsh"
fi
