#!/bin/bash

## script to disable an ssh user.
## Errors will be thrown if it is not a valid username

echo 'Script must be run as sudo'

echo "Enter a valid username:"
read USERNAME

id -u $USERNAME

if [ $? -eq 0 ]; then
    echo "Specified user exists"
    echo "Changing shell to /sbin/nologin"
    usermod -s /sbin/nologin $USERNAME
    echo "Locking account"
    passwd $USERNAME -l
    echo "Expiring account"
    usermod --expiredate 1 $USERNAME
    echo "Moving key files"
    mv /home/$USERNAME/.ssh /home/$USERNAME/.ssh_bak

else
    echo "User not Found, check /etc/passwd for specified user."
fi

exit
