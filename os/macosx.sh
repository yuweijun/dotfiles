#!/bin/bash

set -x

if type brew 2>&1 >/dev/null; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install macvim nginx tmux neovim tldr shellcheck fzf cloc axel rougify mycli
brew install wget zsh-syntax-highlighting autojump coreutils the_silver_searcher
brew install git git-flow keepassx gnu-sed proxychains-ng
brew install mosh bash-completion
brew install caskroom/cask/iterm2
brew install caskroom/cask/visual-studio-code

brew cask install font-fira-code

brew install nmap tcpflow
brew install wireshark --with-qt
