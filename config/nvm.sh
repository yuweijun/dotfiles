#!/bin/bash

if [ ! -e $HOME/.nvm ]; then
    cd ${HOME}
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
fi
