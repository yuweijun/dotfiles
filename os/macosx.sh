#!/bin/bash

set -ex

if type brew >/dev/null 2>&1; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
brew install nginx tmux neovim tldr shellcheck fzf cloc axel mycli
brew install wget zsh-syntax-highlighting autojump coreutils the_silver_searcher
brew install git git-flow proxychains-ng pstree
brew install mosh bash-completion zsh-autosuggestions multitail
brew install httpie macvim

brew tap homebrew/cask-versions

brew cask install google-chrome
brew cask install macvim
brew cask install iterm2

brew install groovy gradle maven
brew install bmon nethogs nmap tcpflow

pip install virtualenv

