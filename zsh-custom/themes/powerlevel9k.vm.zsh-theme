#!/usr/bin/env zsh

zsh_custom_ip(){
  ip=$(ip addr | grep 'dynamic ens3' | awk '{print $2}' | cut -f1 -d '/')
  echo -n "%F{green}$ip"
}

POWERLEVEL9K_MODE="nerdfont-complete"
POWERLEVEL9K_CUSTOM_IP="zsh_custom_ip"
POWERLEVEL9K_CUSTOM_IP_BACKGROUND="black"
POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="252"
POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="blueviolet"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="deepskyblue3"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="252"
POWERLEVEL9K_DIR_HOME_BACKGROUND="black"
POWERLEVEL9K_DIR_HOME_FOREGROUND="249"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="deepskyblue3"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="249"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%F{014}\u2570%F{cyan}\uF460%F{073}\uF460%F{109}\uF460%f "
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RAM_BACKGROUND='grey35'
POWERLEVEL9K_RAM_FOREGROUND="252"
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_STATUS_CROSS=true
POWERLEVEL9K_STATUS_VERBOSE=true
POWERLEVEL9K_TIME_BACKGROUND='white'
POWERLEVEL9K_TIME_FORMAT="%D{\uf017 %H:%M \uf073 %d/%m/%y}"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='yellow'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir vcs status)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(custom_ip ram background_jobs time)

ZSH_THEMES_DIR="${ZSH}/custom/themes"
POWERLEVEL9K_THEME="${ZSH_THEMES_DIR}/powerlevel9k.zsh-theme"

if [ -f $POWERLEVEL9K_THEME ]; then
    source $POWERLEVEL9K_THEME;
else
    source "${ZSH_THEME_DIR}/powerline.zsh-theme"
fi

