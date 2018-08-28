#!/bin/bash

if [[ "$SHELL" != "/bin/zsh" ]]; then
    exit 0
fi

for plugin in autojump zsh-autosuggestions zsh-syntax-highlighting fzf
do
    echo $plugin
    mkdir -p ${DIR}/oh-my-zsh/custom/plugins/${plugin}
    ln -snf ${DIR}/zsh-custom/plugins/${plugin}/${plugin}.plugin.zsh ${DIR}/oh-my-zsh/custom/plugins/${plugin}/${plugin}.plugin.zsh
done

echo "" >> ${RCFILE}
echo "bindkey '^ ' autosuggest-accept" >> ${RCFILE}

