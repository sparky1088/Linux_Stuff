# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#PS1="\[\033[38;5;34m\]\u\[\033[0:36;15m\]@\[\033[38;5;27m\]\h \[\033[01;33m\]\w\\[\033[01;00m\]\n$ "
#PS1="$(tput setaf 2)\u\[$(tput setaf 6)\]@\$(tput setaf 4)\h \$(tput setaf 3)\w\[\$(tput sgr0)\] "

__prompt_command() {
    local exit_status="$?"
    #local check_mark="$(printf '\\U%08x' 10003)"
    if [[ "${LANG}" == *"utf-8"* || "${LANG}" == *"UTF-8"* ]] ; then
        local check_mark="$(printf '\u2714')"
        local x_mark="$(printf '\u2718')"
    else
        local check_mark="V"
        local x_mark="X"
    fi
    local green_color='\[\e[0;32m\]'
    local red_color='\[\e[0;31m\]'
    local reset_color='\[\e[0m\]'
    if [ ! -z "${VIRTUAL_ENV+set}" ]; then
        local python_venv=$(basename ${VIRTUAL_ENV})
    fi
    if [ "$exit_status" -eq 0 ] && [[ -z "${VIRTUAL_ENV+set}" ]] ; then
        PS1="${green_color}${check_mark}${reset_color} ${PS1_ORIG}"
    elif [ "$exit_status" -eq 0 ] && [[ ! -z "${VIRTUAL_ENV+set}" ]] ; then
        PS1="${green_color}${check_mark}${reset_color} (\[\e[38;5;217m\]${python_venv}${reset_color}) ${PS1_ORIG}"
    elif [ "$exit_status" -eq 1 ] && [[ ! -z "${VIRTUAL_ENV+set}" ]] ; then
        PS1="${red_color}${x_mark}${reset_color} (\[\e[38;5;217m\]${python_venv}${reset_color}) ${PS1_ORIG}"
    else
        PS1="${red_color}${x_mark}${reset_color} ${PS1_ORIG}"
    fi
}

PS1_ORIG="\[\e[38;5;222m\]\d \t\n\[\e[38;5;226m\]\u\[\e[38;5;220m\]@\[\e[38;5;214m\]\h \n\e[38;5;112m\]jobs: \j \n \[\e[38;5;33m\]\w \n\[\033[0m\]\$ "

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
#test -f ~/.wttr.in || curl -sk wttr.in -o ~/.wttr.in
#find ~ -maxdepth 1 -name .wttr.in -cmin +5 -exec curl -sk wttr.in -o ~/.wttr.in \;
#head -7 ~/.wttr.in | tail -5
#W(){ find ~ -maxdepth 1 -name .wttr.in -cmin +5 -exec curl -sk wttr.in -o ~/.wttr.in \;; head -27 ~/.wttr.in; }

# get more colors
export HH_CONFIG=hicolor

# Bash History
# append new history items to .bash_history
shopt -s histappend 
# ignorespace is leading space hides commands from history,use erasedups remove duplicates in same line and testing ignore duplicates (ignoredups)
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync

# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc) (currently not working)
#if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi 

export PAGER="most"

# Personalized Host file
if [ -f ~/.hosts ]; then
    export HOSTALIASES=~/.hosts
fi

# adding scripts directory to path
export PATH="$PATH:$HOME/scripts:$HOME/scripts/wcsscripts"

# Sourcing additional dot files:
# default python venv, aliases, and functions 
declare -a dot_files
dot_files=( ".venv/bin/activate" ".aliases" "scripts/ldapfunctions" ".functions" ".aliases_hostSpecific" )
for i in ${!dot_files[@]}; do
    if [ -f $HOME/${dot_files[$i]} ]; then
        . ${dot_files[$i]}
    fi
done

# ubuntu fix for sudo graphical interfaces
gks () { xhost +si:localuser:root; sudo -H "$@"; xhost -si:localuser:root; }
