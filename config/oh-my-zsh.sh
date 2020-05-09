#!/bin/bash

if [[ ! "$SHELL" =~ "zsh" ]]; then
    exit 0
fi

DIR=${DIR:-$(pwd)}
export RCFILE="${HOME}/.zshrc"

if [ ! -d "${DIR}/oh-my-zsh" ]; then
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "${DIR}/oh-my-zsh"
fi

if [ ! -d "${DIR}/powerlevel9k" ]; then
    git clone --depth=1 https://github.com/bhilburn/powerlevel9k.git "${DIR}/powerlevel9k"
fi

if [ ! -e ${HOME}/.oh-my-zsh ]; then
    ln -sfn ${DIR}/oh-my-zsh ${HOME}/.oh-my-zsh
fi

if [ -f ${RCFILE} ]; then
    mv ${RCFILE} ${RCFILE}.bak
fi

ln -sfn ${DIR}/zsh-custom/themes/powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerline.zsh-theme
ln -sfn ${DIR}/zsh-custom/themes/powerlevel9k.vm.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.vm.zsh-theme
ln -sfn ${DIR}/zsh-custom/themes/powerlevel9k.kiss.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.kiss.zsh-theme
ln -sfn ${DIR}/zsh-custom/themes/powerlevel9k.clean.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.clean.zsh-theme
ln -sfn ${DIR}/powerlevel9k/powerlevel9k.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerlevel9k.zsh-theme
echo "###########################################" >> ${RCFILE}

if [ ! -d "${DIR}/zsh-custom/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${DIR}/zsh-custom/plugins/zsh-syntax-highlighting"
fi

if [ ! -d "${DIR}/zsh-custom/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${DIR}/zsh-custom/plugins/zsh-autosuggestions"
fi

for plugin in $(ls ${DIR}/zsh-custom/plugins)
do
    echo $plugin
    mkdir -p ${DIR}/oh-my-zsh/custom/plugins/${plugin}
    ln -snf ${DIR}/zsh-custom/plugins/${plugin}/${plugin}.plugin.zsh ${DIR}/oh-my-zsh/custom/plugins/${plugin}/${plugin}.plugin.zsh
done

echo "" >> ${RCFILE}
echo "bindkey '^ ' autosuggest-accept" >> ${RCFILE}

