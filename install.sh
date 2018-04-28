#!/bin/bash

git submodule update --init --remote --recursive

if grep -q "alias ll" ~/.bashrc; then
    echo "alias ll exists"
else
    echo "alias ls='ls --color=auto'" >> ~/.bashrc
    echo "alias ll='ls -alF'" >> ~/.bashrc
    echo "alias la='ls -A'" >> ~/.bashrc
    echo "alias l='ls -CF'" >> ~/.bashrc
fi

if grep -q "alias grep" ~/.bashrc; then
    echo "alias grep exists"
else
    echo "alias grep='grep --color=auto'" >> ~/.bashrc
fi

if grep -q PS1 ~/.bashrc; then
    echo 'PS1="\033[1;36m\]\$(date \"+%H:%M:%S\") \[\033[00m\]\u@\W\[\033[00m\] \[\033[1;35m\]$\[\033[00m\] "' >> ~/.bashrc
fi

directory=$(dirname "$0")
cd ${directory}
dir="$(pwd)"

if [ ! -e ~/.fzf ]; then
    ln -sfn ${dir}/fzf ~/.fzf && ~/.fzf/install
fi

if [ ! -f ~/.my.vim ]; then
    mkdir -p ~/.mysql/out
    ln -sfn ${dir}/tmux/tmux.linux.conf ~/.tmux.conf
    ln -sfn ${dir}/mycli/myclirc ~/.myclirc
    ln -sfn ${dir}/mycli/my.cnf ~/.my.cnf
    ln -sfn ${dir}/mycli/my.vim ~/.my.vim
fi

if grep -q bash_completion ~/.bashrc; then
    echo "bash_completion config found in ~/.bashrc"
else
    if [ ! -f ~/.bash_completion ]; then
        ln -sfn ${dir}/bash-completion/bash_completion ~/.bash_completion
        echo "[ -f ~/.bash_completion ] && source ~/.bash_completion" >> ~/.bashrc
    fi
fi

if grep -q gitprompt.sh ~/.bashrc; then
    echo "gitprompt.sh config found in ~/.bashrc"
else
    if [ ! -e ~/.bash-git-prompt ]; then
        ln -sfn ${dir}/bash-git-prompt ~/.bash-git-prompt
        echo "if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then" >> ~/.bashrc
        echo "    GIT_PROMPT_ONLY_IN_REPO=1" >> ~/.bashrc
        echo "    GIT_PROMPT_FETCH_REMOTE_STATUS=0" >> ~/.bashrc
        echo "    GIT_PROMPT_IGNORE_SUBMODULES=1" >> ~/.bashrc
        echo "    GIT_PROMPT_THEME=Minimal" >> ~/.bashrc
        echo "    source ~/.bash-git-prompt/gitprompt.sh" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
fi

if [ ! -e ~/.vim ]; then
    mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
    mkdir -p ~/.local/share/nvim/tmp/backup ~/.local/share/nvim/tmp/swap ~/.local/share/nvim/tmp/undo
    ln -sfn ${dir}/bundle vim/bundle
    ln -sfn ${dir}/vim ~/.vim
    ln -sfn ${dir}/vim/terminal.vimrc ~/.vimrc
    ln -sfn ${dir}/vim/linux.gvimrc ~/.gvimrc
else
    echo ".vim folder exists"
fi

