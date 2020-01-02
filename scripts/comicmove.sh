#! /bin/bash

## This is intended to copy downloaded manga to the ubooquity lxc
## Make sure you get the folder name right.
## It is intended to be run as root

#ls $HOME/Downloads/manga_downloader-master/src/$1

cp -a $HOME/git/manga_downloader-master/src/$1 $HOME/.local/share/lxc/ubooquity/rootfs/srv/ubooquity/Comics/

## This fixes the lxc permissions
chown -R 100000:100000 $HOME/.local/share/lxc/ubooquity/rootfs/srv/ubooquity/

