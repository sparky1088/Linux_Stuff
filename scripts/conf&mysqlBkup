#!/bin/bash

#backup of conf files
tar cf - /opt/search/appliance5/conf /opt/nlp/conf | gzip > /var/spool/holland/conf$(date +"%Y-%m-%d").tar.gz
#backup of mysql tables see if we can separate individual databases
mysqldump --all-databases | gzip > /var/spool/holland/mysql$(date +"%Y-%m-%d").gz
