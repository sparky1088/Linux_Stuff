#!/bin/bash

## This script was designed to change the gnome wallpaper based on a directory as 
## I couldnt get all of the pictures to load in the settings

export DISPLAY=:0

#DIR="/home/user/Pictures/wallpapers/WallpapersDualScreen/"
DIR="/home/user/Pictures/wallpapers/"
PIC=$(find $DIR/ -type f | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$PIC"
