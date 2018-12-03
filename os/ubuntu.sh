#!/bin/bash

for comm in tmux mycli silversearcher-ag mosh multitail
do
    if ! type "$comm" &>/dev/null; then
        sudo apt install -y "$comm"
    fi
done

if [ $(fc-list | grep 'Meslo LG M DZ .* Nerd Font .* Mono' | wc -l) -gt 1 ]; then
    echo "Nerd Fond exists"
else
    # Meslo fonts not being listed on gnome-terminal #846
    # Workaround = Goto Releases, Click Tags, Select 1.2, Download.
    # [https://github.com/ryanoasis/nerd-fonts/releases/tag/v1.2.0](https://github.com/ryanoasis/nerd-fonts/releases/tag/v1.2.0)

    SHARE_FONTS=~/.local/share/fonts
    mkdir -p $SHARE_FONTS
    cd $SHARE_FONTS
    curl -fLo "Meslo LG M DZ Regular Nerd Font Complete Mono.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/M-DZ/complete/Meslo%20LG%20S%20DZ%20Regular%20Nerd%20Font%20Complete%20Mono.otf

    fc-cache -vf $SHARE_FONTS
fi

