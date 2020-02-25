#!/bin/bash

yum update  -y nss curl libcurl
yum install -y git wget zsh
yum install -y vim tmux
yum install -y nmap-ncat bash-completion

if type pip > /dev/null 2>&1; then
    pip install virtualenv
fi

