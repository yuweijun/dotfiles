#!/bin/bash

if type brew >/dev/null 2>&1; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew tap "homebrew/cask-fonts"
brew cask install font-hack-nerd-font

