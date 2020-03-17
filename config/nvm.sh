#!/bin/bash

if [ ! -d $HOME/.nvm ]; then
    cd ${HOME}
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
else
    echo "~/.nvm directory exists"
fi

