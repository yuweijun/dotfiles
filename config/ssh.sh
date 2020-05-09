#!/bin/bash

if [ ! -e $HOME/.ssh ]; then
    mkdir $HOME/.ssh
    chmod 700 $HOME/.ssh
fi

if [ ! -e $HOME/.ssh/config ]; then
    echo "Host *" >> $HOME/.ssh/config
    echo "    ForwardAgent yes" >> $HOME/.ssh/config
    chmod -R 600 $HOME/.ssh/config
fi

if [ ${#SSH_AUTH_SOCK} -gt 1 ]; then
    echo "ssh-agent is running"
else
    echo "start running ssh-agent"
    eval "$(ssh-agent -s)"
    if [ -f $HOME/.ssh/id_rsa ]; then
        ssh-add $HOME/.ssh/id_rsa
    fi
fi
