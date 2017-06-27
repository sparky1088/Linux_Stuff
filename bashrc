# /etc/bashrc

# System wide functions and aliases
# Environment stuff goes in /etc/profile

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*|vte*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
          PROMPT_COMMAND="__vte_prompt_command"
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
      fi
      ;;
    screen*)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
  shopt -s histappend
  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
#  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="\[\033[38;5;34m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;27m\]\h\[$(tput sgr0)\] "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

if ! shopt -q login_shell ; then # We're not a login shell
    # Need to redefine pathmunge, it get's undefined at the end of /etc/profile
    pathmunge () {
        case ":${PATH}:" in
            *:"$1":*)
                ;;
            *)
                if [ "$2" = "after" ] ; then
                    PATH=$PATH:$1
                else
                    PATH=$1:$PATH
                fi
        esac
    }

    # By default, we want umask to get set. This sets it for non-login shell.
    # Current threshold for system reserved uid/gids is 200
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
       umask 002
    else
       umask 022
    fi

    SHELL=/bin/bash
    # Only display echos from profile.d scripts if we are no login shell
    # and interactive - otherwise just process them to set envvars
    for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
            if [ "$PS1" ]; then
                . "$i"
            else
                . "$i" >/dev/null
            fi
        fi
    done

    unset i
    unset -f pathmunge
fi

export HISTCONTROL=ignoreboth:erasedups
# vim:ts=4:sw=4
## sudo alias for sudo
alias sudo='sudo '

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ssh="TERM=linux ssh"
alias doMagic="pithos"
alias df="df -H"
alias today='cal | grep -C7 --color=auto "\<$(date +%Oe)\>"'
alias calloop='while true;do clear; today; sleep 30m; done'
alias rand="/bin/bash /home/mwaldorf/randomwordgen.sh"
alias chbg="/bin/bash /home/mwaldorf/backgroundchanger.sh"
alias changebg="chbg"
alias vpnstart="sudo iked;qikea"
alias reloadxdefaults="xrdb -merge $HOME/.Xresources"
alias update="sudo dnf update"
alias updatey="sudo dnf -y update"
alias hist="history"
alias ping="ping -c 5"
alias bashreload="source ~/.bashrc"
alias reloadbash="bashreload"
alias freem="free -hm"
#install colordiff package
alias diff="colordiff"
alias ports="sudo netstat -tuplan"
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'
# confirmation #
alias mv='mv -i'
alias cp='cp -ai'
alias ln='ln -i'
# Parenting changing perms on / #
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
#change according to system
alias update='sudo dnf update'
#alias update='yum update'
#alias updatey='yum -y update'
## All of our servers enp0s25 is connected to the Internets via vlan / router etc  ##
#download packages for vnstat,iftop,tcpdump,ethtool
alias dnstop='dnstop -l 5  enp0s25'
alias vnstat='vnstat -i enp0s25'
# interface traffic
alias iftop='iftop -i enp0s25'
alias tcpdump='tcpdump -i enp0s24'
alias ethtool='ethtool enp0s25'

## remoting into windows machines
alias remote='rdesktop -g 1820x980'

## Something for python
alias py='python'
alias webserver="python /home/mwaldorf/Web/pyhtml.py"

## Shrewsoft VPN Help
alias VPN="/bin/bash /home/mwaldorf/shrewVPNconnect.sh"
alias vpnhelp="echo -e 'shrewVPNconnect.sh can be used to connect to the Cisco VPNs via CLI\nThe VPN command will run shrewVPNconnect.sh\nikec -r ConnName -u USER -p PASSWORD -a \nArk-LasVegas\nArk-Lindon\nArk-Lindonfailover\nBay-Health\nBay-Health-Vegas\nBronx\nDHIN\nHASA\nJHIE\nPOC\nor use vpnstart to launch the ShrewSoft GUI'"

## Simple git help because I can never Remember the order
alias githelp="echo -e 'git add . (add new files)\ngit commit (commit the changes made)\ngit push (push to the branch)\n-sparky loves alice'"

# work on wlan0 by default #
# Only useful for laptop as all servers are without wireless interface
alias iwconfig='iwconfig wlan0'

# some memory info
alias vmstat='vmstat -w 5'
alias meminfo='free -m -h -l -t'
 
## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
 
## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
 
## Get server cpu info ##
alias cpuinfo='lscpu'

## Start Virtual Windows Machine
alias startvm='VBoxManage startvm Kumonga'

## Weather
alias W='curl -s -N wttr.in | head -7'

## Emulator
alias psx='pcsxr &'
alias ps2='pcsx2 &'
alias snes='zsnes &'
alias play='sudo xboxdrv --silent &'
alias controller='play &'
alias games='jobs'

## Color tests
alias colortest1='(x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)
'
alias colortest2='/bin/bash /home/mwaldorf/colortest.sh'
alias colortest3='for x in {0..8}; do for i in {30..37}; do for a in {40..47}; do echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; done; echo; done; done; echo ""'

## Adding ldap aliases
. /home/mwaldorf/ldapfunctions

extract() { 
    if [ -f $1 ] ; then 
      case $1 in 
        *.tar.bz2)   tar xjf $1     ;; 
        *.tar.gz)    tar xzf $1     ;; 
        *.bz2)       bunzip2 $1     ;; 
        *.rar)       unrar e $1     ;; 
        *.gz)        gunzip $1      ;; 
        *.tar)       tar xf $1      ;; 
        *.tbz2)      tar xjf $1     ;; 
        *.tgz)       tar xzf $1     ;; 
        *.zip)       unzip $1       ;; 
        *.Z)         uncompress $1  ;; 
        *.7z)        7z x $1        ;; 
        *)     echo "'$1' cannot be extracted via extract()" ;; 
         esac 
     else 
         echo "'$1' is not a valid file" 
     fi 
}

