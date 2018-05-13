#!/bin/bash

set -e
set -x

cd "$(dirname $0)"
dir="$(pwd)"

if [ ! -e .git/modules ]; then
    git submodule update --init --recursive
elif [ $# -gt 0 ] && [ "$1" = "init" ]; then
    git submodule update --init --recursive
elif [ $# -gt 0 ] && [ "$1" = "remote" ]; then
    git submodule update --init --recursive --remote
else
    echo "usage: ./install.sh [--init|--remote]"
fi

rcfile="$HOME/.bashrc"
if [[ "$SHELL" = "/bin/zsh" ]]; then
    rcfile="$HOME/.zshrc"
    if [ ! -e $HOME/.oh-my-zsh ]; then
        ln -sfn ${dir}/oh-my-zsh $HOME/.oh-my-zsh
    fi
    if [ ! -f ${rcfile} ]; then
        cp ${dir}/oh-my-zsh/zshrc ${rcfile}
    fi
else
    cd ${dir}/bash-it
    ./install.sh --silent
    cd -
fi

if type gls >/dev/null 2>&1; then
    if grep -q "alias lg" ${rcfile}; then
        echo "alias lg exists"
    else
        echo "alias ls='gls --color=auto'" >> ${rcfile}
        echo "alias lg='/bin/ls -laG'" >> ${rcfile}
    fi

    if [ -n "$GREP_OPTIONS" ]; then
        echo "GREP_OPTIONS config exists"
    else
        echo "export GREP_OPTIONS='--color=auto'" >> ${rcfile}
    fi

    if [ -n "$GREP_COLOR" ]; then
        echo "GREP_COLOR config exists"
    else
        echo "export GREP_COLOR='1;35;40'" >> ${rcfile}
    fi

    if [ -n "$CLICOLOR" ]; then
        echo "CLICOLOR config exists"
    else
        echo "export CLICOLOR=1" >> ${rcfile}
    fi

    if [ -n "$LSCOLORS" ]; then
        echo "LSCOLORS config exists"
    else
        echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> ${rcfile}
    fi
else
    echo "# brew install wget coreutils" >> ${rcfile}
    echo "# wget --no-check-certificate https://github.com/seebi/dircolors-solarized/raw/master/dircolors.256dark -O $HOME/.dir_colors" >> ${rcfile}
fi

if [ ! -e $HOME/.fzf ]; then
    ln -sfn ${dir}/fzf $HOME/.fzf
fi

if grep -q fzf ${rcfile}; then
    echo "fzf config exists"
else
    $HOME/.fzf/install
fi

if [ ! -f $HOME/.tmux.conf ]; then
    ln -sfn ${dir}/tmux/tmux.linux.conf $HOME/.tmux.conf
fi

if [ ! -f $HOME/.my.vim ]; then
    mkdir -p $HOME/.mysql/out
    ln -sfn ${dir}/mycli/myclirc $HOME/.myclirc
    ln -sfn ${dir}/mycli/my.cnf $HOME/.my.cnf
    ln -sfn ${dir}/mycli/my.vim $HOME/.my.vim
fi

if [ ! -e $HOME/.vim ]; then
    ln -sfn ${dir}/vim $HOME/.vim
    ln -sfn ${dir}/bundle $HOME/.vim/bundle
    mkdir -p $HOME/.vim/tmp/backup $HOME/.vim/tmp/swap $HOME/.vim/tmp/undo
else
    echo ".vim folder exists"
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${dir}/vim/terminal.vimrc $HOME/.vimrc
    ln -sfn ${dir}/vim/linux.gvimrc $HOME/.gvimrc
else
    echo ".vimrc file exists"
fi

if type nvim 2>/dev/null; then
    if ! grep nvim ${rcfile}; then
        echo "alias vi='nvim'" >> ${rcfile}
        echo "alias vim='nvim'" >> ${rcfile}
    fi
fi

if [ ! -e $HOME/.config/nvim ]; then
    mkdir -p $HOME/.config/nvim
    mkdir -p $HOME/.local/share/nvim/tmp/backup $HOME/.local/share/nvim/tmp/swap $HOME/.local/share/nvim/tmp/undo
fi

if [ ! -e $HOME/.config/nvim/init.vim ]; then
    ln -sfn ${dir}/vim/nvim.init.vim $HOME/.config/nvim/init.vim
fi

if [ -n "$NVM_DIR" ]; then
    echo "NVM_DIR config exist"
else
    echo "export NVM_DIR=\"${dir}/nvm\"" >> ${rcfile}
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\"" >> ${rcfile}
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && source \"\$NVM_DIR/bash_completion\"" >> ${rcfile}
fi

if [ ! -e $HOME/.autojump ]; then
    cd ${dir}/autojump
    ./install.py
    cd -
fi

if type -a j 2>/dev/null; then
    echo "j - autojump command exists"
else
    if [[ "$SHELL" = "/bin/zsh" ]]; then
        if ! grep -q autojump.zsh ${rcfile}; then
            echo "[ -f $HOME/.autojump/share/autojump/autojump.zsh ] && source $HOME/.autojump/share/autojump/autojump.zsh" >> ${rcfile}
        fi
    else
        if ! grep -q autojump.bash ${rcfile}; then
            echo "[ -f $HOME/.autojump/share/autojump/autojump.bash ] && source $HOME/.autojump/share/autojump/autojump.bash" >> ${rcfile}
        fi
    fi
fi

if [ ! -e $HOME/.ssh ]; then
    mkdir $HOME/.ssh
    echo "Host *\n    ForwardAgent yes" > $HOME/.ssh/config
    chmod -R 600 $HOME/.ssh
fi

if [ ${#SSH_AUTH_SOCK} -gt 1 ]; then
    echo "ssh-agent is running"
else
    echo "start running ssh-agent"
    eval "$(ssh-agent -s)"
    if [ -f $HOME/.ssh/id_rsa ]; then
        ssh-add $HOME/.ssh/id_rsa
    fi
fi

if [ -e $HOME/.jrebel ]; then
    if grep -q "jdebug" ${rcfile}; then
        echo "alias jdebug config exists"
    else
        echo "alias jrebel=\"MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so' mvn\"" >> ${rcfile}
        echo "alias jdebug=\"MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000' mvn\"" >> ${rcfile}
    fi
fi

if [[ "$SHELL" = "/bin/zsh" ]]; then
    if grep -q "zsh-autosuggestions.zsh" ${rcfile}; then
        echo "zsh-autosuggestions.zsh config exists"
    else
        echo "if [ -f ${dir}/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then" >> ${rcfile}
        echo "    source ${dir}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${rcfile}
        echo "    bindkey '^ ' autosuggest-accept" >> ${rcfile}
        echo "fi" >> ${rcfile}
    fi
    if grep -q "zsh-syntax-highlighting.zsh" ${rcfile}; then
        echo "zsh-syntax-highlighting.zsh config exists"
    else
        echo "[ -f ${dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ${dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${rcfile}
    fi

    exit 0
fi

if [ -f $HOME/.bash_profile ]; then
    if grep -q .bashrc $HOME/.bash_profile 2>/dev/null; then
        echo ".bashrc config exists"
    else
        echo "[ -f ~/.bashrc ] && source ~/.bashrc" >> $HOME/.bash_profile
    fi
fi

if grep -q "alias ll" $HOME/.bashrc; then
    echo "alias ll exists"
else
    echo "alias ll='ls -alF'" >> $HOME/.bashrc
    echo "alias lt='ls -lt'" >> $HOME/.bashrc
    echo "alias ld='ls -ad'" >> $HOME/.bashrc
    echo "alias la='ls -A'" >> $HOME/.bashrc
    echo "alias l='ls -CF'" >> $HOME/.bashrc
    echo "alias lg='/bin/ls -laG'" >> $HOME/.bashrc
fi

if grep -q "export PS1" $HOME/.bashrc; then
    echo "export PS1 config exists"
else
    echo '# export PS1="\[\033[1;36m\]┌\$(date \"+%H:%M:%S\")\[\033[00m\] [\u@\h: \[\033[1;32m\]\w\[\033[00m\]]\n\[\033[1;36m\]└$\[\033[00m\] "' >> $HOME/.bashrc
fi

if [ -f $HOME/.dircolors ]; then
    echo "$HOME/.dircolors file exists"
else
    ln -sfn ${dir}/dircolors-solarized/dircolors.256dark $HOME/.dircolors
fi

if type dircolors 2>/dev/null; then
    if grep dircolors $HOME/.bashrc 2>/dev/null; then
        echo "dircolors config exist"
    else
        echo 'eval "$(dircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
elif type gdircolors >/dev/null 2>&1; then
    if grep gdircolors $HOME/.bashrc 2>/dev/null; then
        echo "gdircolors config exist"
    else
        echo 'eval "$(gdircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
else
    echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> $HOME/.bashrc
fi

