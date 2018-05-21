if [[ -n $DOTFILES ]]; then
    if [ -f ${DOTFILES}/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source ${DOTFILES}/zsh-autosuggestions/zsh-autosuggestions.zsh
        bindkey '^ ' autosuggest-accept
    fi
fi
