#!/bin/bash

git submodule init
git submodule update --remote --recursive

dir=$(dirname "$0")

if type apt 2>/dev/null; then
    sudo apt install -y tmux neovim mycli bash-completion
elif type yum 2>/dev/null; then
    yum install -y tmux mycli bash-completion
elif type brew 2>/dev/null; then
    brew install tmux neovim mycli reattach-to-user-namespace bash-completion
fi

ln -sfn ${dir}/vim/ ~/.vim
# ln -sfn vim/terminal.vimrc ~/.vimrc # with powerline font
ln -sfn ${dir}/vim/server.vimrc ~/.vimrc
ln -sfn ${dir}/vim/linux.gvimrc ~/.gvimrc
mkdir vim/bundle
mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
mkdir -p ~/.local/share/nvim/tmp/backup ~/.local/share/nvim/tmp/swap ~/.local/share/nvim/tmp/undo
vim +PluginInstall +qall

# brew install tmux
# sudo apt install -y tmux
# yum install -y tmux
ln -sfn ${dir}/tmux/tmux.linux.conf ~/.tmux.conf

mkdir -p ~/.mysql/out
ln -sfn ${dir}/mycli/myclirc ~/.myclirc
ln -sfn ${dir}/mycli/my.cnf ~/.my.cnf
ln -sfn ${dir}/mycli/my.vim ~/.my.vim

ln -sfn ${dir}/fzf ~/.fzf
~/.fzf/install

ln -sfn ${dir}/bash-completion/bash_completion ~/.bash_completion

cat bashrc >> ~/.bashrc

