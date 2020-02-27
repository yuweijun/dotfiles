#!/bin/bash

set -ex

if type brew >/dev/null 2>&1; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

export HOMEBREW_NO_AUTO_UPDATE=1

brew install git git-flow
brew install privoxy proxychains-ng pstree tree
brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
brew install nginx tmux neovim tldr shellcheck fzf cloc axel mycli
brew install wget zsh-syntax-highlighting autojump coreutils
brew install mosh bash-completion zsh-autosuggestions multitail
brew install httpie aria2
brew install bat jq exa fd ripgrep the_silver_searcher
brew install groovy gradle maven
brew install bmon nethogs nmap tcpflow

brew tap homebrew/cask-versions

brew cask install iterm2
brew cask install google-chrome

if type pip > /dev/null 2>&1; then
    pip install virtualenv
fi

