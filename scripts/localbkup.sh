#! /bin/bash
## backup multiple directories in individual tar files.

DATE=$(date +%Y%m%d)
## Directory to be backuped up
WORKINGDIR=/home/USER/Downloads/tmp/test/
## Directory to backup to
BKDIR=/home/USER/Downloads/tmp/test/bkup/
LOGFILE=/home/USER/Downloads/tmp/test/log$DATE
exec &> $LOGFILE

for dir in $WORKINGDIR*/
do
#       echo $dir
        base=$(basename "$dir")
        echo $base
        tar -cvzf "$BKDIR/${base}-$DATE.tar.gz" "$dir" --exclude $BKDIR
done
## Only keep 30 days of backups
find $BKDIR/* -mtime +30 -exec rm {} \;
