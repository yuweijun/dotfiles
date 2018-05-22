#!/bin/bash

INIT=false
REMOTE=false
SIMPLE=false

while getopts irs arg; do
    case "$arg" in
        i) INIT=true ;;
        r) REMOTE=true ;;
        s) SIMPLE=true ;;
        ?) printf "Usage: %s: [-i] [-r] [-s]\n" $0
            exit 2;;
    esac
done

# set -e
# set -x

cd "$(dirname $0)"
export DIR="$(pwd)"
export SIMPLE

if $INIT; then
    git submodule update --init --recursive 2> /dev/null
elif $REMOTE; then
    git submodule update --init --recursive --remote 2> /dev/null
else
    if [ ! -e .git/modules ] && ! $SIMPLE; then
        git submodule update --init --recursive 2> /dev/null
    fi
fi

export RCFILE="${HOME}/.bashrc"
if [[ "$SHELL" = "/bin/zsh" ]]; then
    RCFILE="${HOME}/.zshrc"
    if [ ! -e ${HOME}/.oh-my-zsh ]; then
        ln -sfn ${DIR}/oh-my-zsh ${HOME}/.oh-my-zsh
    fi

    if [ -f ${RCFILE} ]; then
        mv ${RCFILE} ${RCFILE}.bak
    fi

    cp ${DIR}/zsh-custom/templates/zshrc.zsh-template ${RCFILE}
    ln -sfn ${DIR}/zsh-custom/themes/powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerline.zsh-theme
    ln -sfn ${DIR}/zsh-custom/themes/agnoster-powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/agnoster-powerline.zsh-theme
    echo -e "\n###########################################\n" >> ${RCFILE}
else
    if $SIMPLE; then
        echo "create simple .bashrc file"
        touch ${RCFILE}
        if grep -q "export PS1" ${RCFILE} 2> /dev/null; then
            echo "export PS1 config exists"
        else
            echo -e "\n###########################################\n" >> ${RCFILE}
            echo 'export PS1="\[\033[1;36m\]┌\$(date \"+%H:%M:%S\")\[\033[00m\] [\u@\h: \[\033[1;32m\]\w\[\033[00m\]]\n\[\033[1;36m\]└$\[\033[00m\] "' >> ${HOME}/.bashrc
        fi
    else
        ln -sfn ${DIR}/bash-it ${HOME}/.bash-it
        cd ${HOME}/.bash-it
        ./install.sh --silent --no-modify-config
        cp ${DIR}/bash-custom/template/bash_profile.template.bash ${RCFILE}
        cd -

        ln -sfn ${DIR}/bash-custom/themes ${DIR}/bash-it/custom/themes
        ln -sfn ${DIR}/bash-custom/plugins ${DIR}/bash-it/custom/plugins
        echo -e "\n###########################################\n" >> ${RCFILE}
    fi
fi

if grep -q "export PATH" ${RCFILE} 2> /dev/null; then
    echo "export PATH config exists"
else
    echo "" >> ${RCFILE}
    echo "export PATH=\$PATH:/usr/local/sbin:\$HOME/bin" >> ${RCFILE}
fi

./config/tmux.sh
./config/mycli.sh
./config/vim.sh
./config/nvim.sh
./config/nvm.sh
./config/fzf.sh
./config/autojump.sh
./config/ssh.sh
./config/java-home.sh
./config/virtualenv.sh
./config/jenv.sh
./config/bash-profile.sh
./config/homebrew.sh
./config/gnu-ls.sh
./config/ls-la.sh
./config/dircolors.sh
./config/zsh-only.sh

