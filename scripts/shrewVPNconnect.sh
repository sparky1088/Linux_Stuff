#!/bin/bash

## A simple Script to connect to ShrewSoft VPN Clients via the command line
RED='\033[0;31m'
NC='\033[0m' # No Color

echo 'Connections cannot have a space in the name for this script to run properly.'
echo -e "The ${RED}vpnhelp${NC} command will show a list of available connections."

echo "Please enter Connection Name"
read ConnName
echo "Please enter Username"
read USER
echo "Please enter password"
read -s PASSWORD

## If you wish to show '*' instead of blank for entering in your password comment out the read -s PASSWORD line 
## and uncomment out the password lines below

#PASSWORD=''
#while IFS= read -r -s -n1 char; do
#  [[ -z $char ]] && { printf '\n'; break; } # ENTER pressed; output \n and break.
#  if [[ $char == $'\x7f' ]]; then # backspace was pressed
#      # Remove last char from output variable.
#      [[ -n $PASSWORD ]] && PASSWORD=${PASSWORD%?}
#      # Erase '*' to the left.
#      printf '\b \b' 
#  else
#    # Add typed char to output variable.
#    PASSWORD+=$char
#    # Print '*' in its stead.
#    printf '*'
#  fi
#done

ikec -r $ConnName -u $USER -p $PASSWORD -a
