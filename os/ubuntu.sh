#!/bin/bash

apt install -y tmux mycli silversearcher-ag mosh multitail

SHARE_FONTS=~/.local/share/fonts
mkdir -p $SHARE_FONTS
cd $SHARE_FONTS
curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

fc-cache -vf $SHARE_FONTS

