#!/bin/bash
ping -c 1 10.40.40.53
    if [ "$?" -ge 1 ]
        then echo $(date) >> test
    fi
