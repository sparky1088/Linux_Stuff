#!/bin/bash

## Simple header to add color to echo and printf statements in a bash script.

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LTGREY='\033[0;37m'
DKGREY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'

NC='\033[0m' # No Color
printf "I ${RED}love${NC} Stack Overflow\n"

## You can also use tput commands
#
#tput setaf 1; echo "this is red text"
#red=`tput setaf 1`
#green=`tput setaf 2`
#reset=`tput sgr0`
#echo "${red}red text ${green}green text${reset}"

## Foreground & background colour commands
#
#tput setab [1-7] # Set the background colour using ANSI escape
#tput setaf [1-7] # Set the foreground colour using ANSI escape
#Colours are as follows:
#
#Num  Colour    #define         R G B
#
#0    black     COLOR_BLACK     0,0,0
#1    red       COLOR_RED       1,0,0
#2    green     COLOR_GREEN     0,1,0
#3    yellow    COLOR_YELLOW    1,1,0
#4    blue      COLOR_BLUE      0,0,1
#5    magenta   COLOR_MAGENTA   1,0,1
#6    cyan      COLOR_CYAN      0,1,1
#7    white     COLOR_WHITE     1,1,1
#There are also non-ANSI versions of the colour setting functions (setb instead of setab, and setf instead of setaf) which use different numbers, not given here.
#
#Text mode commands
#
#tput bold    # Select bold mode
#tput dim     # Select dim (half-bright) mode
#tput smul    # Enable underline mode
#tput rmul    # Disable underline mode
#tput rev     # Turn on reverse video mode
#tput smso    # Enter standout (bold) mode
#tput rmso    # Exit standout mode
#Cursor movement commands
#
#tput cup Y X # Move cursor to screen postion X,Y (top left is 0,0)
#tput cuf N   # Move N characters forward (right)
#tput cub N   # Move N characters back (left)
#tput cuu N   # Move N lines up
#tput ll      # Move to last line, first column (if no cup)
#tput sc      # Save the cursor position
#tput rc      # Restore the cursor position
#tput lines   # Output the number of lines of the terminal
#tput cols    # Output the number of columns of the terminal
#Clear and insert commands
#
#tput ech N   # Erase N characters
#tput clear   # Clear screen and move the cursor to 0,0
#tput el 1    # Clear to beginning of line
#tput el      # Clear to end of line
#tput ed      # Clear to end of screen
#tput ich N   # Insert N characters (moves rest of line forward!)
#tput il N    # Insert N lines
#Other commands
#
#tput sgr0    # Reset text format to the terminal's default
#tput bel     # Play a bell

## Lastly the colortest3 command will print a list of all the possible colors you can use

