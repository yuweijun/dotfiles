#!/bin/bash

if type brew >/dev/null 2>&1; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install gnu ls sed
brew install coreutils gnu-sed

# install fonts from https://github.com/Homebrew/homebrew-cask-fonts/tree/master/Casks
brew tap "homebrew/cask-fonts"
brew install --cask font-hack-nerd-font
