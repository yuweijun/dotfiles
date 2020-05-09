#!/bin/bash

# set -e
# set -x

cd "$(dirname $0)"
export DIR="$(pwd)"

git submodule update --init --recursive
git submodule foreach git checkout

export RCFILE="${HOME}/.bashrc"
if [[ "${SHELL}" =~ "zsh" ]]; then
    export RCFILE="${HOME}/.zshrc"
    if [ ! -e ${HOME}/.oh-my-zsh ]; then
        ln -sfn ${DIR}/oh-my-zsh ${HOME}/.oh-my-zsh
    fi

    if [ -f ${RCFILE} ]; then
        mv ${RCFILE} ${RCFILE}.bak
    fi

    cp ${DIR}/zsh-custom/templates/zshrc.zsh-template ${RCFILE}
    ln -sfn ${DIR}/zsh-custom/themes/powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerline.zsh-theme
    ln -sfn ${DIR}/zsh-custom/themes/powerlevel9k.vm.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.vm.zsh-theme
    ln -sfn ${DIR}/zsh-custom/themes/powerlevel9k.kiss.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.kiss.zsh-theme
    ln -sfn ${DIR}/zsh-custom/themes/powerlevel9k.clean.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.clean.zsh-theme
    ln -sfn ${DIR}/powerlevel9k/powerlevel9k.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.zsh-theme
    ln -sfn ${DIR}/powerlevel10k/powerlevel10k.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel10k.zsh-theme
    echo "###########################################" >> ${RCFILE}
else
    ln -sfn ${DIR}/bash-it ${HOME}/.bash-it
    cd ${HOME}/.bash-it
    ./install.sh --silent --no-modify-config
    cp ${DIR}/bash-custom/template/bash_profile.template.bash ${RCFILE}
    cd -

    ln -sfn ${DIR}/bash-custom/themes ${DIR}/bash-it/custom/themes
    ln -sfn ${DIR}/bash-custom/plugins ${DIR}/bash-it/custom/plugins
    echo "###########################################" >> ${RCFILE}
fi

./config/ssh.sh
./config/zsh-only.sh
./config/vim.sh

