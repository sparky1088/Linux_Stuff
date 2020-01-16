#! /bin/bash
## Remote backup multiple directories in individual tar files.

DATE=$(date +%Y%m%d)
## Directory we want backedup
WORKINGDIR=/home/user/Downloads/tmp/test/
## Place to backup locally
BKDIR=/home/user/Downloads/tmp/test/bkup/
## Destination of rsync and final backup location
DESTDIR=/bkup/
LOGFILE=/bkup/logs/bklog$DATE
exec &> $LOGFILE

ssh root@server "for dir in $WORKINGDIR*/       
        do
        #       echo $dir
                base=$(basename "$dir")
                echo $base
                tar -cvzf "$BKDIR/${base}-$DATE.tar.gz" "$dir" --exclude $BKDIR
        done"
rsync -vah -e ssh root@server:$BKDIR $DESTDIR
ssh root@basan "rm $BKDIR/*.tar.gz"
## Only keep the last 30 days
find $DESTDIR -mtime +30 -exec rm {} \;
