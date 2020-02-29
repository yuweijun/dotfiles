  #!/bin/bash

# set -e
# set -x

cd "$(dirname $0)"
export DIR="$(pwd)"

git submodule update --init --recursive
git submodule foreach git checkout master
git submodule foreach git pull

export RCFILE="${HOME}/.bashrc"
if [ "${SHELL}" = "/bin/zsh" ]; then
    export RCFILE="${HOME}/.zshrc"
    if [ ! -e ${HOME}/.oh-my-zsh ]; then
        ln -sfn ${DIR}/oh-my-zsh ${HOME}/.oh-my-zsh
    fi

    if [ -f ${RCFILE} ]; then
        mv ${RCFILE} ${RCFILE}.bak
    fi

    cp ${DIR}/zsh-custom/templates/zshrc.zsh-template ${RCFILE}
    ln -sfn ${DIR}/zsh-custom/themes/powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerline.zsh-theme
    ln -sfn ${DIR}/zsh-custom/themes/agnoster-powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/agnoster-powerline.zsh-theme
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

./config/tmux.sh
./config/mycli.sh
./config/vim.sh
./config/nvim.sh
./config/mvn.sh
./config/fzf.sh
./config/autojump.sh
./config/ssh.sh
./config/virtualenv.sh
./config/bash-profile.sh
./config/homebrew.sh
./config/dircolors.sh
./config/zsh-only.sh

