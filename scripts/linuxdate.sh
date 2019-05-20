#! /bin/bash

# This script is to know how many days since the start of linux.

/bin/echo $(($(date --utc --date "$1" +%s)/86400))
