#! /bin/bash

## This is intended to remove the translator image from downloaded manga. 
## It will need to be run on individual chapters until I figure out more.
## This only removes the first image. More modification will be needed for more.


echo "Name of Manga"
read NAME

echo "Image Name"
echo "example: *001.jpeg"
read iNAME

echo "Which Chapter?"
echo "example: 0[0-9][1-9] are chapters 1-99"
read CHAPTERS

for f in $NAME.$CHAPTERS.cbz; 
    do zip -d ${f} $INAME; 
done;
