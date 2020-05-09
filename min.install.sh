#!/bin/bash

# set -e
# set -x

cd "$(dirname $0)"
export DIR="$(pwd)"

git submodule update --init --recursive
git submodule foreach git checkout

if [[ "${SHELL}" =~ "zsh" ]]; then
    export RCFILE="${HOME}/.zshrc"
    cp ${DIR}/zsh-custom/templates/powerlevel9k.clean.zsh-template ${RCFILE}
    ./config/oh-my-zsh.sh
else
    export RCFILE="${HOME}/.bashrc"
    ./config/bash-it.sh
fi

if [ ! -e "${HOME}/.after.vimrc" ]; then
    echo "let g:airline_powerline_fonts=0" > "${HOME}/.after.vimrc"

    ln -sfn "${DIR}/vim" ~/.vim
    mkdir -p ~/.config/nvim ~/.local/share/nvim/site
    mkdir -p ~/.vim/tmp/backup ~/.vim/tmp/swap ~/.vim/tmp/undo

    ln -sfn "${DIR}/vim/pack" "${HOME}/.local/share/nvim/site/pack"
    ln -sfn "${DIR}/vim/server.vimrc" "${HOME}/.config/nvim/init.vim"
    ln -sfn "${DIR}/vim/server.vimrc" "${HOME}/.vimrc"
fi

