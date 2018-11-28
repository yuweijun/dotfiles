#!/bin/bash

apt install -y tmux mycli silversearcher-ag mosh multitail

SHARE_FONTS=~/.local/share/fonts
mkdir -p $SHARE_FONTS
cd $SHARE_FONTS
curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
curl -fLo "Meslo LG S DZ Regular Nerd Font Complete Mono.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/S-DZ/complete/Meslo%20LG%20S%20DZ%20Regular%20Nerd%20Font%20Complete%20Mono.otf

fc-cache -vf $SHARE_FONTS

