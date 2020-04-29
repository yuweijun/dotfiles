#!/usr/bin/env zsh

autoload -Uz add-zsh-hook

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0' # Powerline characters 

  # curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
  BLACK=0
  BLUE32=32
  GREEN28=28
  PINK162=162
  RED52=52
  GREY235=235
  GREY240=240
  GREY242=242
  GREY255=255
}

CWD_DISABLE_PROMPT=${CWD_DISABLE_PROMPT:=0}
GIT_DISABLE_PROMPT=${GIT_DISABLE_PROMPT:=0}
USER_DISABLE_PROMPT=${USER_DISABLE_PROMPT:=0}
HOSTNAME_DISABLE_PROMPT=${HOSTNAME_DISABLE_PROMPT:=0}
DATETIME_DISABLE_PROMPT=${DATETIME_DISABLE_PROMPT:=0}
VIRTUAL_ENV_DISABLE_PROMPT=${VIRTUAL_ENV_DISABLE_PROMPT:=0}

CURRENT_BG='NONE'

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

prompt_datetime() {
  prompt_segment $GREY242 $GREY255 "%*"
}

prompt_user() {
  prompt_segment $BLUE32 $GREY255 "$USER"
}

prompt_hostname() {
  if [[ "$(uname -s)" = "Darwin" ]]; then
    local APPLE=$'\ue711' # \uf8ff \uf179 
    prompt_segment $BLACK $GREY255 "${APPLE} $(hostname -s)"
  else
    prompt_segment $BLACK $GREY255 "@$(hostname -s)"
  fi
}

prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
        prompt_segment $PINK162 $GREY255
    else
      prompt_segment $GREEN28 $GREY255
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '❄'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
}

prompt_virtualenv() {
  [[ -n ${VIRTUAL_ENV} ]] || return
  prompt_segment magenta white "${VIRTUAL_ENV:t}"
}

prompt_dir() {
  prompt_segment $GREY240 $GREY255 '%~'
}

prompt_status() {
  [[ $RETVAL -ne 0 ]] && prompt_segment $RED52 $GREY255 "$RETVAL"
}

build_prompt() {
  RETVAL=$?
  [[ -n $DATETIME_DISABLE_PROMPT    ]] && [ $DATETIME_DISABLE_PROMPT    -ne 1 ] && prompt_datetime
  [[ -n $USER_DISABLE_PROMPT        ]] && [ $USER_DISABLE_PROMPT        -ne 1 ] && prompt_user
  [[ -n $HOSTNAME_DISABLE_PROMPT    ]] && [ $HOSTNAME_DISABLE_PROMPT    -ne 1 ] && prompt_hostname
  [[ -n $VIRTUAL_ENV_DISABLE_PROMPT ]] && [ $VIRTUAL_ENV_DISABLE_PROMPT -ne 1 ] && prompt_virtualenv
  [[ -n $CWD_DISABLE_PROMPT         ]] && [ $CWD_DISABLE_PROMPT         -ne 1 ] && prompt_dir
  [[ -n $GIT_DISABLE_PROMPT         ]] && [ $GIT_DISABLE_PROMPT         -ne 1 ] && prompt_git
  prompt_status
  prompt_end
}

function println {
  print
}

add-zsh-hook precmd println

PROMPT='%{%f%b%k%}$(build_prompt) '

