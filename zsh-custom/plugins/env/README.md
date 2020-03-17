# export global env for LANG and PATH

    export LANG=en_US.UTF-8
    export PATH=$PATH:/usr/local/sbin:$HOME/bin

# source extra env config from user home

    if [ -f $HOME/.envrc ]; then
        source $HOME/.envrc
    fi

