#!/bin/bash

export DISPLAY=:0

#DIR="/home/mwaldorf/Pictures/wallpapers/WallpapersDualScreen/"
DIR="/home/mwaldorf/Pictures/wallpapers/"
PIC=$(find $DIR/ -type f | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$PIC"
