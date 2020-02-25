#!/bin/bash

for cmd in zsh tmux mycli silversearcher-ag mosh multitail httpie bmon nethogs nmap tcpflow fontconfig python2.7
do
    if ! type "$cmd" &>/dev/null; then
        sudo apt install -y "$cmd"
    fi
done

if [ $(fc-list | grep 'Menlo for Powerline' | wc -l) -gt 1 ]; then
    echo "Menlo for Powerline Fond exists"
else
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    SHARE_FONTS=~/.local/share/fonts
    mkdir -p $SHARE_FONTS
    cp ${DIR}/../powerline-fonts/*.ttf $SHARE_FONTS
    fc-cache -vf $SHARE_FONTS
fi

