#!/bin/bash

git submodule update --init

directory=$(dirname "$0")
cd ${directory}
dir="$(pwd)"

if type apt 2>/dev/null; then
    sudo apt install -y tmux neovim mycli
elif type yum 2>/dev/null; then
    yum install -y tmux mycli
elif type brew 2>/dev/null; then
    brew install tmux neovim mycli reattach-to-user-namespace
fi

# brew install tmux
# sudo apt install -y tmux
# yum install -y tmux
ln -sfn ${dir}/tmux/tmux.linux.conf ~/.tmux.conf

mkdir -p ~/.mysql/out
ln -sfn ${dir}/mycli/myclirc ~/.myclirc
ln -sfn ${dir}/mycli/my.cnf ~/.my.cnf
ln -sfn ${dir}/mycli/my.vim ~/.my.vim

ln -sfn ${dir}/fzf ~/.fzf
ln -sfn ${dir}/bash-completion/bash_completion ~/.bash_completion

if grep -q bash_completion ~/.bashrc; then
    echo "bash_completion config found in ~/.bashrc"
else
    cat bashrc >> ~/.bashrc
    ~/.fzf/install
fi

ln -sfn ${dir}/vim ~/.vim
# ln -sfn vim/server.vimrc ~/.vimrc # without powerline font and using plug
ln -sfn ${dir}/vim/terminal.vimrc ~/.vimrc # with powerline font and using vundle
ln -sfn ${dir}/vim/linux.gvimrc ~/.gvimrc
mkdir -p vim/bundle
mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
mkdir -p ~/.local/share/nvim/tmp/backup ~/.local/share/nvim/tmp/swap ~/.local/share/nvim/tmp/undo
git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -s ~/.vim/bundle/Vundle.vim ~/.vim/bundle/vundle
# install vim plugin at last
vi +PluginInstall +qall

