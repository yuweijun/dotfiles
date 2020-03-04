#!/usr/bin/env zsh

autoload -Uz add-zsh-hook

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0' # Powerline characters 
  BLACK=0
  DEEP_SKY_BLUE3=32
  ORANGE_RED1=202
  GREEN4=28
  DEEP_PINK3=162
  DARK_RED=52
  GREY93=255
  GREY35=240
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
  prompt_segment $ORANGE_RED1 $GREY93 "%D{%F} %*"
}

prompt_user() {
  prompt_segment $DEEP_SKY_BLUE3 $GREY93 "$USER"
}

prompt_hostname() {
  if [[ "$(uname -s)" = "Darwin" ]]; then
    local APPLE=$'\uf8ff' # 
    prompt_segment $BLACK $GREY93 "${APPLE} $(hostname -s)"
  else
    prompt_segment $BLACK $GREY93 "@$(hostname -s)"
  fi
}

prompt_git() {
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0' # 
  }
  local ref dirty mode repo_path
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    local SNOW_FLAKE=$'\u2744'
    if [[ -n $dirty ]]; then
      if [ $(git status | grep 'fatal:\|deleted:\|modified:\|renamed:' | wc -l) 2> /dev/null -gt 0 ]; then
        prompt_segment $DEEP_PINK3 $GREY93
      elif [ $(git status | grep 'Untracked files:\|new file:' | wc -l) 2> /dev/null -gt 0 ]; then
        prompt_segment $GREEN4 $GREY93
      fi

      mode=" ${SNOW_FLAKE}${mode}"
    else
      prompt_segment $GREEN4 $GREY93
    fi

    setopt promptsubst
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${mode}"
  fi
}

prompt_virtualenv() {
  [[ -n ${VIRTUAL_ENV} ]] || return
  prompt_segment magenta white "${VIRTUAL_ENV:t}"
}

prompt_dir() {
  prompt_segment $GREY35 $GREY93 '%~'
}

prompt_status() {
  [[ $RETVAL -ne 0 ]] && prompt_segment $DARK_RED $GREY93 "$RETVAL"
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

