# Mac OS ls original command
alias lo="/bin/ls"
alias lt='ls -lat'
alias ll='ls -la'
alias ld='ls -ad'
alias la='ls -a'
alias l='ls -a'

if type nvim &>/dev/null; then
    alias vim="nvim"
fi

alias vi="vim -u NONE"
alias vzrc='vi ~/.zshrc'
alias vbrc='vi ~/.bashrc'

if type gls &>/dev/null; then
    # gnu-ls command for Mac OS
    alias ls="gls --color=auto"
elif type colorls &>/dev/null; then
    # sudo gem install colorls
    alias ls="colorls"
elif type exa &>/dev/null; then
    alias ls="exa"
    alias lt="exa -la -t modified"
fi

if type gsed &>/dev/null; then
    alias sed="gsed"
fi

if type mosh &>/dev/null; then
    alias mosh='LC_ALL="en_US.UTF-8" mosh'
fi

if type bat &>/dev/null; then
    alias cat="bat -p"
fi

if type systemctl &>/dev/null; then
    alias sc-running='systemctl list-units --type=service --state=running'
fi

function gll {
    find . -type d -name '.git' -print0 \
        | xargs -P 10 -n 1 -0 -I '{}' \
        sh -c "cd \"{}\"/../ && git pull && pwd && echo '--------------------'" \;
}
