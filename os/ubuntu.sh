#!/bin/bash

apt install -y tmux mycli silversearcher-ag mosh multitail

SHARE_FONTS=~/.local/share/fonts
mkdir -p $SHARE_FONTS
cd $SHARE_FONTS
curl -fLo "Meslo LG M DZ Regular Nerd Font Complete Mono.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/M-DZ/complete/Meslo%20LG%20S%20DZ%20Regular%20Nerd%20Font%20Complete%20Mono.otf

fc-cache -vf $SHARE_FONTS

