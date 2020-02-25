#!/bin/bash

yum update  -y nss curl libcurl
yum install -y git wget zsh
yum install -y tmux mycli the_silver_searcher mosh multitail

if type pip > /dev/null 2>&1; then
    pip install virtualenv
fi

