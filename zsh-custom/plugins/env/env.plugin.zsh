# env setting for zsh

export LANG=en_US.UTF-8
export HOMEBREW_NO_AUTO_UPDATE=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export USER_DISABLE_PROMPT=0
export HOSTNAME_DISABLE_PROMPT=0
export DISABLE_MAGIC_FUNCTIONS=true
export POWERLEVEL9K_MODE="nerdfont-complete"
export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh dir vcs newline status)
export POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(root_indicator background_jobs history time)
export PATH=$PATH:/usr/local/sbin:$HOME/bin

unsetopt BEEP

if [[ $OSTYPE =~ ^darwin ]]; then
    export CLICOLOR=1
    export LSCOLORS=GxFxCxDxBxegedabagaced
fi

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

