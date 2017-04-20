#!/bin/sh

#This script is intended to ping everything on a /24 subnet and let you know which hosts are up.

subnet=`ip route | grep default | cut -d " " -f 3 | sed 's/.$//'`
for addr in `seq 0 1 255 `; do
#   ( echo $subnet$addr)
( ping -c 3 -t 5 $subnet$addr > /dev/null && echo $subnet$addr is Alive ) &
done 
