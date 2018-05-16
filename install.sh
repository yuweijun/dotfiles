#!/bin/bash

ARGV=$(getopt -o isr -l init,simple,remote -- "$@")
if [ $? != 0 ] ; then
    echo "getopt error"
fi

eval set -- "$ARGV"

INIT=false
REMOTE=false
SIMPLE=false

while true; do
  case "$1" in
    -i | --init ) INIT=true; shift ;;
    -r | --remote ) REMOTE=true; shift ;;
    -s | --simple ) SIMPLE=true; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# set -e
# set -x

cd "$(dirname $0)"
DIR="$(pwd)"

if $INIT; then
    git submodule update --init --recursive
elif $REMOTE; then
    git submodule update --init --recursive --remote
else
    echo "usage: ./install.sh [--init|--remote|--simple]"
    if [ ! -e .git/modules ]; then
        git submodule update --init --recursive
    fi
fi

RCFILE="$HOME/.bashrc"
if [[ "$SHELL" = "/bin/zsh" ]]; then
    RCFILE="$HOME/.zshrc"
    if [ ! -e $HOME/.oh-my-zsh ]; then
        ln -sfn ${DIR}/oh-my-zsh $HOME/.oh-my-zsh
    fi
    if [ ! -f ${RCFILE} ]; then
        cp ${DIR}/oh-my-zsh/zshrc ${RCFILE}
        echo -e "\n\n####### customize settings ####### \n" >> ${RCFILE}
    fi
else
    if $SIMPLE; then
        echo "create simple .bashrc file"
        if grep -q "export PS1" $HOME/.bashrc; then
            echo "export PS1 config exists"
        else
            echo 'export PS1="\[\033[1;36m\]┌\$(date \"+%H:%M:%S\")\[\033[00m\] [\u@\h: \[\033[1;32m\]\w\[\033[00m\]]\n\[\033[1;36m\]└$\[\033[00m\] "' >> $HOME/.bashrc
        fi
    else
        cd ${DIR}/bash-it
        ./install.sh --silent
        cd -
        echo -e "\n\n####### customize settings ####### \n" >> ${RCFILE}
    fi
fi

if type gls >/dev/null 2>&1; then
    if grep -q "alias lg" ${RCFILE}; then
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

if grep -q "export PATH" ${RCFILE}; then
    echo "export PATH config exists"
else
    echo "" >> ${RCFILE}
    echo "export PATH=\$PATH:/usr/local/sbin:\$HOME/bin:${DIR}/jenv/bin" >> ${RCFILE}
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

if type nvim >/dev/null 2>&1; then
    if ! grep nvim ${RCFILE}; then
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
else
    echo "" >> ${RCFILE}
    echo "export NVM_DIR=\"${DIR}/nvm\"" >> ${RCFILE}
    echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && source \"\$NVM_DIR/nvm.sh\"" >> ${RCFILE}
    echo "[ -s \"\$NVM_DIR/bash_completion\" ] && source \"\$NVM_DIR/bash_completion\"" >> ${RCFILE}
fi

if [ ! -e $HOME/.fzf ]; then
    ln -sfn ${DIR}/fzf $HOME/.fzf
fi

if grep -q fzf ${RCFILE}; then
    echo "fzf config exists"
else
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

if type -a j >/dev/null 2>&1; then
    echo "j - autojump command exists"
else
    if [[ "$SHELL" = "/bin/zsh" ]]; then
        if ! grep -q autojump.zsh ${RCFILE}; then
            echo "" >> ${RCFILE}
            echo "[ -f $HOME/.autojump/share/autojump/autojump.zsh ] && source $HOME/.autojump/share/autojump/autojump.zsh" >> ${RCFILE}
        fi
    else
        if ! grep -q autojump.bash ${RCFILE}; then
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

if [ -e $HOME/.jrebel ]; then
    if grep -q "jdebug" ${RCFILE}; then
        echo "alias jdebug config exists"
    else
        echo "" >> ${RCFILE}
        echo "alias jrebel=\"MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so' mvn\"" >> ${RCFILE}
        echo "alias jdebug=\"MAVEN_OPTS='-agentpath:$HOME/.jrebel/lib/libjrebel64.so -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8000' mvn\"" >> ${RCFILE}
    fi
fi

if grep -q "jenv init" ${RCFILE}; then
    echo "jenv init config exists"
else
    echo "" >> ${RCFILE}
    echo 'eval "$(jenv init -)"' >> ${RCFILE}
fi

if [ -e /usr/libexec/java_home ]; then
    if grep -q "export JAVA_HOME" ${RCFILE}; then
        echo "export JAVA_HOME config exists"
    else
        echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)' >> ${RCFILE}
    fi
fi

if [[ "$SHELL" = "/bin/zsh" ]]; then
    if grep -q "zsh-autosuggestions.zsh" ${RCFILE}; then
        echo "zsh-autosuggestions.zsh config exists"
    else
        echo "" >> ${RCFILE}
        echo "if [ -f ${DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then" >> ${RCFILE}
        echo "    source ${DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${RCFILE}
        echo "    bindkey '^ ' autosuggest-accept" >> ${RCFILE}
        echo "fi" >> ${RCFILE}
    fi
    if grep -q "zsh-syntax-highlighting.zsh" ${RCFILE}; then
        echo "zsh-syntax-highlighting.zsh config exists"
    else
        echo "" >> ${RCFILE}
        echo "[ -f ${DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ${DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${RCFILE}
    fi

    exit 0
fi

if [ -f $HOME/.bash_profile ]; then
    if grep -q .bashrc $HOME/.bash_profile 2>/dev/null; then
        echo ".bashrc config exists"
    else
        echo -e "\n####### add customize settings in ~/.bashrc #######" >> $HOME/.bash_profile
        echo "[ -f ~/.bashrc ] && source ~/.bashrc" >> $HOME/.bash_profile
    fi
fi

if type ll >/dev/null 2>&1; then
    echo "alias ll exists"
else
    echo "" >> ${RCFILE}
    echo "alias ll='ls -alF'" >> $HOME/.bashrc
    echo "alias lt='ls -lt'" >> $HOME/.bashrc
    echo "alias ld='ls -ad'" >> $HOME/.bashrc
    echo "alias la='ls -A'" >> $HOME/.bashrc
    echo "alias l='ls -CF'" >> $HOME/.bashrc
fi

if ls --color -d . >/dev/null 2>&1; then
    echo "ls is GNU's ls"
else
    if grep -q "alias lg" $HOME/.bashrc; then
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

if type dircolors >/dev/null 2>&1; then
    if grep dircolors $HOME/.bashrc 2>/dev/null; then
        echo "dircolors config exist"
    else
        echo "" >> ${RCFILE}
        echo 'eval "$(SHELL=$SHELL dircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
elif type gdircolors >/dev/null 2>&1; then
    if grep gdircolors $HOME/.bashrc 2>/dev/null; then
        echo "gdircolors config exist"
    else
        echo "" >> ${RCFILE}
        echo 'eval "$(gdircolors $HOME/.dircolors)"' >> $HOME/.bashrc
    fi
else
    echo "" >> ${RCFILE}
    echo "export LS_COLORS='rs=0:di=01;33:ln=01;36:mh=00:pi=40;33'" >> $HOME/.bashrc
fi

