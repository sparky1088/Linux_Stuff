# .bashrc
#include Files for alias, functions and ldap functions
. ~/.aliases
## Adding ldap aliases
. ~/scripts/ldapfunctions
. ~/.functions
## adding host specific aliases
. ~/.aliases_hostSpecific

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PS1="\[\033[38;5;34m\]\u\[\033[0:36;15m\]@\[\033[38;5;27m\]\h \[\033[01;33m\]\w\\[\033[01;00m\]\n$ "
#PS1="$(tput setaf 2)\u\[$(tput setaf 6)\]@\$(tput setaf 4)\h \$(tput setaf 3)\w\[\$(tput sgr0)\] "

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
#test -f ~/.wttr.in || curl -sk wttr.in -o ~/.wttr.in
#find ~ -maxdepth 1 -name .wttr.in -cmin +5 -exec curl -sk wttr.in -o ~/.wttr.in \;
#head -7 ~/.wttr.in | tail -5
#W(){ find ~ -maxdepth 1 -name .wttr.in -cmin +5 -exec curl -sk wttr.in -o ~/.wttr.in \;; head -27 ~/.wttr.in; }

# add this configuration to ~/.bashrc
export HH_CONFIG=hicolor         # get more colors
shopt -s histappend              # append new history items to .bash_history
export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc) (currently not working)
#if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi 

export PAGER="most"

# used to make hostnames not require .ccb
export HOSTALIASES=~/.hosts

# adding scripts directory to path
export PATH="$PATH:$HOME/scripts:$HOME/scripts/wcsscripts"

# ubuntu fix for sudo graphical interfaces
gks () { xhost +si:localuser:root; sudo -H "$@"; xhost -si:localuser:root; }
