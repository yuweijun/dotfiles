#!/bin/bash

set -x

if type brew >/dev/null 2>&1; then
    echo "brew installed"
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install coreutils findutils gnu-tar gnu-sed gawk gnutls gnu-indent gnu-getopt
brew install nginx tmux neovim tldr shellcheck fzf cloc axel mycli
brew install wget zsh-syntax-highlighting autojump coreutils the_silver_searcher
brew install git git-flow keepassx proxychains-ng pstree
brew install mosh bash-completion zsh-autosuggestions multitail
brew install httpie

brew tap caskroom/versions

brew cask install google-chrome
brew cask install macvim
brew cask install iterm2
brew cask install visual-studio-code
brew cask install font-fira-code

brew install gradle maven
brew install nethogs nload
brew install nmap tcpflow
brew install wireshark --with-qt

pip install virtualenv

cd $HOME/Library/Fonts
MESLO_FONT="Meslo LG M Regular Nerd Font Complete Mono.otf"
if [ -f $MESLO_FONT ]; then
    echo "$MESLO_FONT exists"
else
    curl -fLo $MESLO_FONT https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Meslo/M/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete%20Mono.otf
    open $MESLO_FONT
fi

if ! type java &>/dev/null; then
    brew cask install java8
fi
