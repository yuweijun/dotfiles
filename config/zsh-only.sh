#!/bin/bash

if [[ "$SHELL" != "/bin/zsh" ]]; then
    exit 0
fi

DIR=${DIR:-$(pwd)}

for plugin in $(ls ${DIR}/zsh-custom/plugins)
do
    echo $plugin
    mkdir -p ${DIR}/oh-my-zsh/custom/plugins/${plugin}
    ln -snf ${DIR}/zsh-custom/plugins/${plugin}/${plugin}.plugin.zsh ${DIR}/oh-my-zsh/custom/plugins/${plugin}/${plugin}.plugin.zsh
done

echo "" >> ${RCFILE}
echo "bindkey '^ ' autosuggest-accept" >> ${RCFILE}

