#!/bin/bash

git submodule update --init

directory=$(dirname "$0")
cd ${directory}
dir="$(pwd)"

if type apt 2>/dev/null; then
    sudo apt install -y tmux mycli
elif type yum 2>/dev/null; then
    yum install -y tmux mycli
fi

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
if grep -q bash_completion ~/.bashrc; then
    echo "bash_completion config found in ~/.bashrc"
else
    echo "[ -f ~/.bash_completion ] && source ~/.bash_completion" >> ~/.bashrc
fi

if grep -q gitprompt.sh ~/.bashrc; then
    echo "gitprompt.sh config found in ~/.bashrc"
else
    echo "if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then" >> ~/.bashrc
    echo "    GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
    echo "    GIT_PROMPT_FETCH_REMOTE_STATUS=0" >> ~/.bashrc
    echo "    GIT_PROMPT_IGNORE_SUBMODULES=1" >> ~/.bashrc
    echo "    GIT_PROMPT_THEME=Minimal" >> ~/.bashrc
    echo "    source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

mkdir -p vim/bundle
mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
mkdir -p ~/.local/share/nvim/tmp/backup ~/.local/share/nvim/tmp/swap ~/.local/share/nvim/tmp/undo
ln -sfn ${dir}/Vundle.vim vim/bundle
ln -sfn ${dir}/vim ~/.vim
# ln -sfn vim/server.vimrc ~/.vimrc # without powerline font and using plug
ln -sfn ${dir}/vim/terminal.vimrc ~/.vimrc # with powerline font and using vundle
ln -sfn ${dir}/vim/linux.gvimrc ~/.gvimrc
# install vim plugin at last
vi -u ~/.vimrc +PluginInstall +qall

