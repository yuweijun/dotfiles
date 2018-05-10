#!/bin/bash

set -e
set -x

cd $(dirname "$0")
dir="$(pwd)"

if grep -q "alias ll" ~/.bashrc; then
    echo "alias ll exists"
else
    echo "alias ls='ls --color=auto'" >> ~/.bashrc
    echo "alias ll='ls -alF'" >> ~/.bashrc
    echo "alias lt='ls -lt'" >> ~/.bashrc
    echo "alias ld='ls -ad'" >> ~/.bashrc
    echo "alias la='ls -A'" >> ~/.bashrc
    echo "alias l='ls -CF'" >> ~/.bashrc
fi

if grep -q "alias grep" ~/.bashrc; then
    echo "alias grep exists"
else
    echo "alias grep='grep --color=auto'" >> ~/.bashrc
fi

if grep -q "export PS1" ~/.bashrc; then
    echo "PS1 has been set"
else
    echo 'export PS1="\[\033[1;36m\]\$(date \"+%H:%M:%S\")\[\033[00m\] [\u@\h: \[\033[1;32m\]\w\[\033[00m\]]\n$ "' >> ~/.bashrc
fi

if [ ! -e ~/.vim/bundle ]; then
    if git submodule update --init --remote --recursive 2>/dev/null; then
        echo "git version is too old"
    else
        git submodule update --init --recursive
    fi
else
    echo "git submodule update --init --remote --recursive # not run because of # ~/.vim/bundle exists"
fi

if type dircolors 2>/dev/null; then
    if [ ! -f ~/.dircolors ]; then
        ln -sfn ${dir}/dircolors-solarized/dircolors.256dark ~/.dircolors
        echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.bashrc
    else
        echo "~/.dircolors has exists"
    fi
else
    if grep -q "export LS_COLORS" ~/.bashrc; then
        echo "export LS_COLORS settings found"
    else
        echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> ~/.bashrc
    fi
fi

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
elif type complete 2>/dev/null; then
    echo "bash command complete exists and not create ~/.bash_completion"
elif [ ! -f ~/.bash_completion ]; then
    ln -sfn ${dir}/bash-completion/bash_completion ~/.bash_completion
    echo "[ -f ~/.bash_completion ] && source ~/.bash_completion" >> ~/.bashrc
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
        echo "    GIT_PROMPT_THEME=TruncatedPwd_WindowTitle_NoExitState" >> ~/.bashrc
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

if [ ! -e ~/.ssh ]; then
    mkdir ~/.ssh
    echo "Host *\n    ForwardAgent yes" > ~/.ssh/config
    chmod -R 600 ~/.ssh
fi

