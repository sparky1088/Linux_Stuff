#! /bin/bash

## Debian LXC Container Creation
## This will only make privleged containers and must be run as sudo
echo "This script must be run as sudo"
echo "Please Specify Debian Release:
     1) Jessie 
     2) Stretch 
     3) Buster"

read -n1 release
## adding a space to make it prettier
echo ""

if [[ $release == "1" ]]; then
       release="jessie"
elif [[ $release == "2" ]]; then
       release="stretch"
elif [[ $release == "3" ]]; then
       release="buster"
else
	echo "Please specify a valid number!"
fi

echo "Name the container"
read containerName
#sleep 5
#echo $release
lxc-create -t download -n $containerName -- -r $release -d debian -a amd64
