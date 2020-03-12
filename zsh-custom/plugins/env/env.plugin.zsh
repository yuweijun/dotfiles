# env setting for zsh

LANG=en_US.UTF-8
HOMEBREW_NO_AUTO_UPDATE=1
VIRTUAL_ENV_DISABLE_PROMPT=1
USER_DISABLE_PROMPT=0
HOSTNAME_DISABLE_PROMPT=0
DISABLE_MAGIC_FUNCTIONS=true
POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh dir vcs newline status)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(root_indicator background_jobs history time)
PATH=$PATH:/usr/local/sbin:$HOME/bin

unsetopt BEEP

if [[ $OSTYPE =~ ^darwin ]]; then
    CLICOLOR=1
    LSCOLORS=GxFxCxDxBxegedabagaced
fi

if [ -f $HOME/.envrc ]; then
    source $HOME/.envrc
fi

