#!/bin/bash

set -e
set -x

cd $(dirname "$0")
dir="$(pwd)"

if [ $# -gt 0 ] && [ "$1" = "init" ]; then
    if git submodule update --init --remote --recursive 2>/dev/null; then
        echo "git version is too old"
    else
        git submodule update --init --recursive
    fi
else
    echo "# git submodule update --init --remote --recursive"
fi

rcfile="${HOME}/.bashrc"
if [ "$SHELL" = "/bin/zsh" ]; then
    rcfile="${HOME}/.zshrc"
    if [ ! -f ${rcfile} ]; then
        ln -sfn ${dir}/oh-my-zsh ~/.oh-my-zsh
        cp ${dir}/oh-my-zsh/zshrc.linux ${rcfile}
    fi
fi

if [ ! -e ~/.fzf ]; then
    ln -sfn ${dir}/fzf ~/.fzf
    ~/.fzf/install
fi

if [ ! -f ~/.tmux.conf ]; then
    ln -sfn ${dir}/tmux/tmux.linux.conf ~/.tmux.conf
fi

if [ ! -f ~/.my.vim ]; then
    mkdir -p ~/.mysql/out
    ln -sfn ${dir}/mycli/myclirc ~/.myclirc
    ln -sfn ${dir}/mycli/my.cnf ~/.my.cnf
    ln -sfn ${dir}/mycli/my.vim ~/.my.vim
fi

if [ ! -e ~/.autojump ]; then
    cd ${dir}/autojump
    ./install.py
    cd -
fi

if grep -q autojump.sh ${rcfile}; then
    echo "autojump.sh config found in ${rcfile}"
else
    echo "[ -f ~/.autojump/share/autojump/autojump.bash ] && source ~/.autojump/share/autojump/autojump.bash" >> ${rcfile}
fi

if [ ! -e ~/.vim ]; then
    mkdir -p vim/tmp/backup vim/tmp/swap vim/tmp/undo
    mkdir -p ~/.local/share/nvim/tmp/backup ~/.local/share/nvim/tmp/swap ~/.local/share/nvim/tmp/undo
    ln -sfn ${dir}/bundle vim/bundle
    ln -sfn ${dir}/vim ~/.vim
else
    echo ".vim folder exists"
fi

if [ ! -e ~/.vimrc ]; then
    ln -sfn ${dir}/vim/terminal.vimrc ~/.vimrc
    ln -sfn ${dir}/vim/linux.gvimrc ~/.gvimrc
else
    echo ".vimrc file exists"
fi

if [ ! -e ~/.ssh ]; then
    mkdir ~/.ssh
    echo "Host *\n    ForwardAgent yes" > ~/.ssh/config
    chmod -R 600 ~/.ssh
fi

if [ ${#SSH_AUTH_SOCK} -gt 1 ]; then
    echo "ssh-agent is running"
else
    echo "start running ssh-agent"
    eval "$(ssh-agent -s)"
    if [ -f ~/.ssh/id_rsa ]; then
        ssh-add ~/.ssh/id_rsa
    fi
fi

if [ "$SHELL" = "/bin/zsh" ]; then
    exit 0
fi

if grep -q "alias ll" ~.bashrc; then
    echo "alias ll exists"
else
    echo "alias ls='ls --color=auto'" >> ~.bashrc
    echo "alias ll='ls -alF'" >> ~.bashrc
    echo "alias lt='ls -lt'" >> ~.bashrc
    echo "alias ld='ls -ad'" >> ~.bashrc
    echo "alias la='ls -A'" >> ~.bashrc
    echo "alias l='ls -CF'" >> ~.bashrc
fi

if grep -q "export PS1" ~/.bashrc; then
    echo "PS1 has been set"
else
    if [[ "$SHELL" = "/bin/bash" ]]; then
        echo 'export PS1="\[\033[1;36m\]\$(date \"+%H:%M:%S\")\[\033[00m\] [\u@\h: \[\033[1;32m\]\w\[\033[00m\]]\n$ "' >> ~/.bashrc
    fi
fi

if grep -q "alias grep" ~/.bashrc; then
    echo "alias grep exists"
else
    echo "alias grep='grep --color=auto'" >> ~/.bashrc
fi

if type dircolors 2>/dev/null; then
    if [ -f ~/.dircolors ]; then
        echo "~/.dircolors has exists"
    else
        ln -sfn ${dir}/dircolors-solarized/dircolors.256dark ~/.dircolors
    fi
    if grep dircolors ~/.bashrc 2>/dev/null; then
        echo "dircolors config exist in ~/.bashrc"
    else
        echo 'eval "$(dircolors ~/.dircolors)"' >> ~/.bashrc
    fi
else
    if grep -q "export LS_COLORS" ~/.bashrc; then
        echo "export LS_COLORS config exists"
    else
        echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> ~/.bashrc
    fi
fi

if grep -q bash_completion ~.bashrc; then
    echo "bash_completion config found in ~.bashrc"
elif type complete 2>/dev/null; then
    echo "bash command complete exists and not create ~/.bash_completion"
elif [ ! -f ~/.bash_completion ]; then
    ln -sfn ${dir}/bash-completion/bash_completion ~/.bash_completion
    echo "[ -f ~/.bash_completion ] && source ~/.bash_completion" >> ~.bashrc
fi

if [ ! -e ~/.bash-git-prompt ]; then
    ln -sfn ${dir}/bash-git-prompt ~/.bash-git-prompt
fi

if grep -q gitprompt.sh ~.bashrc; then
    echo "gitprompt.sh config found in ~.bashrc"
else
    echo "if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then" >> ~.bashrc
    echo "    GIT_PROMPT_ONLY_IN_REPO=1" >> ~.bashrc
    echo "    GIT_PROMPT_FETCH_REMOTE_STATUS=0" >> ~.bashrc
    echo "    GIT_PROMPT_IGNORE_SUBMODULES=1" >> ~.bashrc
    echo "    GIT_PROMPT_THEME=TruncatedPwd_WindowTitle_NoExitState" >> ~.bashrc
    echo "    source ~/.bash-git-prompt/gitprompt.sh" >> ~.bashrc
    echo "fi" >> ~.bashrc
fi

source ~/.bashrc

