# set umask
umask 0002
#
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# append to the history file, don't overwrite it
shopt -s histappend
setterm -regtabs 4

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

unset color_prompt force_color_prompt


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_environment ]; then
    . ~/.bash_environment
fi

# server specific file
if [ -f ~/.bash_server ]; then
    . ~/.bash_server
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

function we_are_in_git_work_tree {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function parse_git_branch {
  if we_are_in_git_work_tree; then
    local BR=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2> /dev/null)
    if [ "$BR" == HEAD ]; then
        local NM=$(git name-rev --name-only HEAD 2> /dev/null)
        if [ "$NM" != undefined ];then
          echo -n "(@$NM)"
        else
          git rev-parse --short HEAD 2> /dev/null
        fi
    else
      echo -n "($BR)"
    fi
  fi
}

function parse_git_status {
  if we_are_in_git_work_tree; then
    local ST=$(git status --short 2> /dev/null)
    if [ -n "$ST" ]; then
      echo -n " + "
    else
      echo -n " - "
    fi
  fi
}

function pwd_depth_limit_2 {
  if [ "$PWD" = "$HOME" ]; then
    echo -n "~"
  else
    pwd | sed -e "s|.*/\(.*/.*\)|\1|"
  fi
}

C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"

# export all these for subshells
export -f parse_git_branch parse_git_status we_are_in_git_work_tree pwd_depth_limit_2
export PS1="\n$C_PURPLE\u$C_DARKGRAY @ $C_BLUE\h $C_DARKGRAY[$C_RED`id -gn`$C_DARKGRAY] $C_DARKGRAY[$C_GREEN\$(parse_git_status)\$(parse_git_branch)$C_DARKGRAY] $C_DARKGRAY: $C_LIGHTYELLOW\w\n$C_DARKGRAY\$$C_DEFAULT "

export TERM="xterm-color"
