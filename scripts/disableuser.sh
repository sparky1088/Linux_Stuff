#!/bin/bash

## script to disable an ssh user.

echo "Changing shell to /sbin/nologin"
usermod -s /sbin/nologin $1
echo "Locking account"
passwd $1 -l
echo "Expiring account"
usermod --expiredate 1 $1
echo "Moving key files"
mv /home/$1/.ssh /home/$1/.ssh_bak
