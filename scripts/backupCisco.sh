#!/bin/bash
##Get the date
DATE_YMD="$(date +%Y-%m-%d)"
RUNNINGCFG="8_2_5_0_startup_cfg.sav"
STARTUPCFG="startup-config.cfg"

## Use sshpass to scp the backup files
sshpass -p 'password' scp -v backup@ASADevice:disk0:${STARTUPCFG} startup-config${DATE_YMD}.cfg
sshpass -p 'password' scp -v backup@ASADevice:disk0:${RUNNINGCFG} RunningConfig.cfg${DATE_YMD}.cfg
