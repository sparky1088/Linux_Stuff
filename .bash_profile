# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

#                       .-.
#          .-._    _.../   `,    _.-.
#          |   `'-'    \     \_'`   |
#          \            '.__,/ `\_.--,
#           /                '._/     |
#          /                    '.    /
#         ;   _                  _'--;
#      '--|- (_)       __       (_) -|--'
#      .--|-          (__)          -|--.
#       .-\-                        -/-.
#      '   '.                      .'   `
#            '-._              _.-'
#                `""--....--""`


# MOTD
let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

# get the load averages
read one five fifteen rest < /proc/loadavg

echo "`curl -s -N wttr.in | head -7`$(tput setaf 2)
   .~~.   .~~.    `date +"%A, %e %B %Y, %r"`
  '. \ ' ' / .'   `uname -srmo`$(tput setaf 1)
   .~ .~~~..~.    
  : .~.'~'.~. :   Uptime.............: ${UPTIME}
 ~ (   ) (   ) ~  Memory.............: `free -hm | grep Mem | awk '{ print $4 }'`(Free) / `free -hm | grep Mem | awk '{ print $2 }'`(Total)
( : '~'.~.'~' : ) Load Averages......: ${one}, ${five}, ${fifteen} (1, 5, 15 min)
 ~ .~ (   ) ~. ~  Running Processes..: `ps ax | wc -l | tr -d " "`
  (  : '~' :  )   IP Addresses.......: `ip -4 addr|grep -v "127.0.0.1" | grep -oP '(?<=inet\s)\d+(\.\d+){3}'| tr '\n' ','`
   '~ .~~~. ~'    Free Space on Home.: `df -Pkh | grep -E 'home' | awk '{ print $4 }'`
       '~'        Free Space on Root.: `df -Pkh | grep -E 'root' | awk '{ print $4 }'`
                  CPU Temperature....: `sensors | grep CPU | awk '{ print $2 }' | cut -b 2-8`
$(tput sgr0)"

