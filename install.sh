#!/bin/bash

# set -e
# set -x

cd "$(dirname $0)"
export DIR="$(pwd)"

git submodule update --init --recursive
git submodule foreach git checkout

if [[ "${SHELL}" =~ "zsh" ]]; then
    export RCFILE="${HOME}/.zshrc"
    mv ${RCFILE} ${RCFILE}.bak
    cp ${DIR}/zsh-custom/templates/zshrc.zsh-template ${RCFILE}
    ./config/oh-my-zsh.sh
else
    export RCFILE="${HOME}/.bashrc"
    ./config/bash-it.sh
fi

./config/tmux.sh
./config/nvm.sh
./config/mvn.sh
./config/virtualenv.sh
./config/mycli.sh
./config/fzf.sh
./config/autojump.sh
./config/ssh.sh
./config/bash-profile.sh
./config/homebrew.sh
./config/dircolors.sh
./config/fonts.sh
./config/alacritty.sh
./vim/install.sh
