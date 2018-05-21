#!/bin/bash

INIT=false
REMOTE=false
SIMPLE=false

while getopts irs arg; do
    case "$arg" in
        i) INIT=true ;;
        r) REMOTE=true ;;
        s) SIMPLE=true ;;
        ?) printf "Usage: %s: [-i] [-r] [-s]\n" $0
            exit 2;;
    esac
done

# set -e
# set -x

cd "$(dirname $0)"
DIR="$(pwd)"

if $INIT; then
    git submodule update --init --recursive 2> /dev/null
elif $REMOTE; then
    git submodule update --init --recursive --remote 2> /dev/null
else
    if [ ! -e .git/modules ] && ! $SIMPLE; then
        git submodule update --init --recursive 2> /dev/null
    fi
fi

RCFILE="$HOME/.bashrc"
if [[ "$SHELL" = "/bin/zsh" ]]; then
    RCFILE="$HOME/.zshrc"
    if [ ! -e $HOME/.oh-my-zsh ]; then
        ln -sfn ${DIR}/oh-my-zsh $HOME/.oh-my-zsh
    fi

    if [ -f ${RCFILE} ]; then
        mv ${RCFILE} ${RCFILE}.bak
    fi

    cp ${DIR}/zsh-custom/templates/zshrc.zsh-template ${RCFILE}
    ln -sfn ${DIR}/zsh-custom/themes/powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/powerline.zsh-theme
    ln -sfn ${DIR}/zsh-custom/themes/agnoster-powerline.zsh-theme ${DIR}/oh-my-zsh/custom/themes/agnoster-powerline.zsh-theme
    echo "" >> ${RCFILE}
    echo "export DOTFILES=${DIR}" >> ${RCFILE}

    echo -e "\n####### customize settings ####### \n" >> ${RCFILE}
else
    if $SIMPLE; then
        echo "create simple .bashrc file"
        touch $HOME/.bashrc
        if grep -q "export PS1" $HOME/.bashrc 2> /dev/null; then
            echo "export PS1 config exists"
        else
            echo -e "\n####### customize settings ####### \n" >> ${RCFILE}
            echo 'export PS1="\[\033[1;36m\]┌\$(date \"+%H:%M:%S\")\[\033[00m\] [\u@\h: \[\033[1;32m\]\w\[\033[00m\]]\n\[\033[1;36m\]└$\[\033[00m\] "' >> $HOME/.bashrc
        fi
    else
        cd ${DIR}/bash-it
        ./install.sh --silent
        cd -
    fi
fi

if type gls > /dev/null 2>&1; then
    if grep -q "alias lg" ${RCFILE} 2> /dev/null; then
        echo "alias lg exists"
    else
        echo "alias ls='gls --color=auto'" >> ${RCFILE}
        echo "alias lg='/bin/ls -laG'" >> ${RCFILE}
    fi

    if [ -n "$CLICOLOR" ]; then
        echo "CLICOLOR config exists"
    else
        echo "export CLICOLOR=1" >> ${RCFILE}
    fi

    if [ -n "$LSCOLORS" ]; then
        echo "LSCOLORS config exists"
    else
        echo "export LSCOLORS=GxFxCxDxBxegedabagaced" >> ${RCFILE}
    fi
fi

if grep -q "export PATH" ${RCFILE} 2> /dev/null; then
    echo "export PATH config exists"
else
    echo "" >> ${RCFILE}
    echo "export PATH=\$PATH:/usr/local/sbin:\$HOME/bin" >> ${RCFILE}
fi

if [ ! -f $HOME/.tmux.conf ]; then
    ln -sfn ${DIR}/tmux/tmux.linux.conf $HOME/.tmux.conf
fi

if [ ! -f $HOME/.my.vim ]; then
    mkdir -p $HOME/.mysql/out
    ln -sfn ${DIR}/mycli/myclirc $HOME/.myclirc
    ln -sfn ${DIR}/mycli/my.cnf $HOME/.my.cnf
    ln -sfn ${DIR}/mycli/my.vim $HOME/.my.vim
fi

if [ ! -e $HOME/.vim ]; then
    ln -sfn ${DIR}/vim $HOME/.vim
    ln -sfn ${DIR}/bundle $HOME/.vim/bundle
    mkdir -p $HOME/.vim/tmp/backup $HOME/.vim/tmp/swap $HOME/.vim/tmp/undo
else
    echo ".vim folder exists"
fi

if [ ! -e $HOME/.vimrc ]; then
    ln -sfn ${DIR}/vim/terminal.vimrc $HOME/.vimrc
    ln -sfn ${DIR}/vim/linux.gvimrc $HOME/.gvimrc
else
    echo ".vimrc file exists"
fi

if type nvim > /dev/null 2>&1; then
    if ! grep nvim ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "alias vi='nvim'" >> ${RCFILE}
        echo "alias vim='nvim'" >> ${RCFILE}
    fi
fi

if [ ! -e $HOME/.config/nvim ]; then
    mkdir -p $HOME/.config/nvim
    mkdir -p $HOME/.local/share/nvim/tmp/backup $HOME/.local/share/nvim/tmp/swap $HOME/.local/share/nvim/tmp/undo
fi

if [ ! -e $HOME/.config/nvim/init.vim ]; then
    ln -sfn ${DIR}/vim/nvim.init.vim $HOME/.config/nvim/init.vim
fi

if [ -n "$NVM_DIR" ]; then
    echo "NVM_DIR config exist"
elif ! $SIMPLE; then
    echo "" >> ${RCFILE}
    echo "export NVM_DIR=\"${DIR}/nvm\"" >> ${RCFILE}
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\"" >> ${RCFILE}
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && source \"\$NVM_DIR/bash_completion\"" >> ${RCFILE}
fi

if [ ! -e $HOME/.fzf ]; then
    ln -sfn ${DIR}/fzf $HOME/.fzf
fi

if grep -q fzf ${RCFILE} 2> /dev/null; then
    echo "fzf config exists"
elif ! $SIMPLE; then
    if [[ "$SHELL" = "/bin/zsh" ]]; then
        $HOME/.fzf/install --no-bash
    else
        $HOME/.fzf/install --no-zsh
    fi
fi

if [ ! -e $HOME/.autojump ]; then
    cd ${DIR}/autojump
    ./install.py
    cd -
fi

if type -a j > /dev/null 2>&1; then
    echo "j - autojump command exists"
else
    if [[ "$SHELL" = "/bin/zsh" ]]; then
        echo "autojump enabled by zsh plugins"
    else
        if ! grep -q autojump.bash ${RCFILE} 2> /dev/null; then
            echo "" >> ${RCFILE}
            echo "[ -f $HOME/.autojump/share/autojump/autojump.bash ] && source $HOME/.autojump/share/autojump/autojump.bash" >> ${RCFILE}
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

if type virtualenv > /dev/null 2>&1; then
    if ! grep -q "bin/activate" ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        if type python3 2> /dev/null; then
            mkdir -p $HOME/.virtualenv/python3
            virtualenv -p $(which python3) $HOME/.virtualenv/python3
            echo 'source $HOME/.virtualenv/python3/bin/activate' >> ${RCFILE}
        elif type python2 2> /dev/null; then
            mkdir -p $HOME/.virtualenv/python2
            virtualenv -p $(which python2) $HOME/.virtualenv/python2
            echo 'source $HOME/.virtualenv/python2/bin/activate' >> ${RCFILE}
        fi
    fi
fi

if type jenv > /dev/null 2>&1; then
    if ! grep -q "jenv init" ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(jenv init -)"' >> ${RCFILE}
        echo "" >> ${RCFILE}
        echo "export PATH=\$PATH:/usr/local/sbin:\$HOME/bin:${DIR}/jenv/bin" >> ${RCFILE}
    fi
fi

if [ -e /usr/libexec/java_home ]; then
    if ! grep -q "export JAVA_HOME" ${RCFILE} 2> /dev/null; then
        echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)' >> ${RCFILE}
    fi
fi

if [ -e $HOME/.jrebel ]; then
    if grep -q "jdebug" ${RCFILE} 2> /dev/null; then
        echo "alias jdebug config exists"
    else
        echo "" >> ${RCFILE}
        echo "alias jrebel=\"MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so' mvn\"" >> ${RCFILE}
        echo "alias jdebug=\"MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000' mvn\"" >> ${RCFILE}
    fi
fi

if [[ "$SHELL" = "/bin/zsh" ]]; then
    mkdir -p ${DIR}/oh-my-zsh/custom/plugins/zsh-autosuggestions
    ln -snf ${DIR}/zsh-custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ${DIR}/oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh

    mkdir -p ${DIR}/oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    ln -snf ${DIR}/zsh-custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh ${DIR}/oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

    exit 0
fi

if [ -f $HOME/.bash_profile ]; then
    if grep -q .bashrc $HOME/.bash_profile 2> /dev/null; then
        echo ".bashrc config exists"
    else
        echo -e "\n####### add customize settings in ~/.bashrc #######" >> $HOME/.bash_profile
        echo "[ -f ~/.bashrc ] && source ~/.bashrc" >> $HOME/.bash_profile
    fi
fi

if type brew 2> /dev/null; then
    if ! grep -q git-completion.bash ${RCFILE} 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo "HOMEBREW_NO_AUTO_UPDATE=1 brew install bash-completion"
        echo '[ -f $(brew --prefix)/etc/bash_completion.d/git-completion.bash ] && source $(brew --prefix)/etc/bash_completion.d/git-completion.bash' >> ${RCFILE}
    fi
fi

if ! grep -q "alias ll" ${RCFILE} > /dev/null 2>&1; then
    echo "" >> ${RCFILE}
    echo "alias ll='ls -alF'" >> $HOME/.bashrc
    echo "alias lt='ls -lt'" >> $HOME/.bashrc
    echo "alias ld='ls -ad'" >> $HOME/.bashrc
    echo "alias la='ls -A'" >> $HOME/.bashrc
    echo "alias l='ls -CF'" >> $HOME/.bashrc
fi

if ls --color -d . > /dev/null 2>&1; then
    echo "ls is GNU's ls"
else
    if grep -q "alias lg" $HOME/.bashrc 2> /dev/null; then
        echo "alias lg config for ls of Mac OS X which is different with ls of GUN"
    else
        echo "alias lg='/bin/ls -laG'" >> $HOME/.bashrc
    fi
fi

if [ -f $HOME/.dircolors ]; then
    echo "$HOME/.dircolors file exists"
else
    ln -sfn ${DIR}/dircolors-solarized/dircolors.256dark $HOME/.dircolors
fi

if type dircolors > /dev/null 2>&1; then
    if ! grep dircolors $HOME/.bashrc 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(SHELL=$SHELL dircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
elif type gdircolors > /dev/null 2>&1; then
    if ! grep gdircolors $HOME/.bashrc 2> /dev/null; then
        echo "" >> ${RCFILE}
        echo 'eval "$(gdircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
else
    echo "" >> ${RCFILE}
    echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> $HOME/.bashrc
fi

