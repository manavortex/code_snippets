#!/usr/bin/env zsh

#.oh-my-zsh config file

source $ZSH/oh-my-zsh.sh

plugins=(git zsh-syntax-highlighting)

setopt prompt_subst

autoload -U colors && colors
autoload -Uz vcs_info

# set prompt
zstyle ':vcs_info:git:*' formats '%b '
PROMPT='%F{white}%*%f %F{green}%~%f %F{cyan}${vcs_info_msg_0_}%f$ '

precmd() { vcs_info }
