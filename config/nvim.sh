#!/bin/bash

mkdir -p "${HOME}/.config/nvim"
mkdir -p "${HOME}/.local/share/nvim/site"
mkdir -p "${HOME}/.local/share/nvim/tmp/backup" "${HOME}/.local/share/nvim/tmp/swap" "${HOME}/.local/share/nvim/tmp/undo"

if [ ! -e "${HOME}/.vim/tmp/plug.vim" ]; then
    DIR=${DIR:-$(pwd)}
    if [ ! -e "${HOME}/.vim" ]; then
        ln -sfn "${DIR}/vim" "${HOME}/.vim"
    fi

    curl -fLo "${HOME}/.vim/tmp/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -sfn "${DIR}/vim/nvim.init.vim" "${HOME}/.config/nvim/init.vim"
ln -sfn "${DIR}/vim/pack" "${HOME}/.local/share/nvim/site/pack"

if type nvim &> /dev/null; then
    nvim +PlugInstall +qall
fi
