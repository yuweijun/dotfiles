[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.bash_completion ] && source ~/.bash_completion

if [ -f ~/.bash-git-prompt/gitprompt.sh ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    GIT_PROMPT_FETCH_REMOTE_STATUS=0
    GIT_PROMPT_IGNORE_SUBMODULES=1
    GIT_PROMPT_THEME=Minimal
    source ~/.bash-git-prompt/gitprompt.sh
fi

