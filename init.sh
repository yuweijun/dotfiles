#!/bin/bash

if type apt 2>/dev/null; then
    sudo apt install -y tmux neovim mycli bash-completion
elif type yum 2>/dev/null; then
    yum install -y tmux mycli bash-completion
elif type brew 2>/dev/null; then
    brew install tmux neovim mycli reattach-to-user-namespace bash-completion
    ln -sfn tmux/tmux.macosx.10.13.conf ~/.tmux.conf
fi

ln -sfn vim/ ~/.vim
# ln -sfn vim/terminal.vimrc ~/.vimrc # with powerline font
ln -sfn vim/server.vimrc ~/.vimrc
ln -sfn vim/linux.gvimrc ~/.gvimrc
mkdir vim/bundle
mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
mkdir -p ~/.local/share/nvim/tmp/backup ~/.local/share/nvim/tmp/swap ~/.local/share/nvim/tmp/undo
vim +PluginInstall +qall

# brew install tmux
# sudo apt install -y tmux
# yum install -y tmux
ln -sfn tmux/tmux.linux.conf ~/.tmux.conf

mkdir -p ~/.mysql/out
ln -sfn mycli/myclirc ~/.myclirc
ln -sfn mycli/my.cnf ~/.my.cnf
ln -sfn mycli/my.vim ~/.my.vim

ln -sfn fzf ~/.fzf
~/.fzf/install

lns -sfn bash-completion/bash_completion ~/.bash_completion

cat bashrc >> ~/.bashrc

