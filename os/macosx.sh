#!/bin/bash

if type brew >/dev/null 2>&1; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install fonts from https://github.com/Homebrew/homebrew-cask-fonts/tree/master/Casks
brew tap "homebrew/cask-fonts"
brew cask install font-hack-nerd-font

# brwe tap "homebrew/cask"
# brew cask install iterm2
# brew cask install fliqlo clocksaver
# xattr -rc "$HOME/Library/Screen Savers"

################### some other fonts ###################
# brew cask install font-dejavu-sans-mono-for-powerline
# brew cask install font-menlo-for-powerline
# brew cask install font-meslo-for-powerline
# brew cask install font-source-code-pro-for-powerline
# brew cask install font-meslo-nerd-font-mono
# brew cask install font-droid-sans-mono-for-powerline
# brew cask install font-fira-mono-for-powerline
# brew cask install font-fira-code
# brew cask install font-firacode-nerd-font-mono
# brew cask install font-fontawesome font-awesome-terminal-fonts
